package pony.magic.builder;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr.Position;

using Lambda;

/**
 * Kind of a producer field. `Own` registers the instance in the local scope only;
 * `Share` guards construction on an ancestor fallback and publishes the instance at root.
 */
enum ProducerKind {
	Own;
	Share;
}

/**
 * Producer entry collected from a DI class's `@:own` / `@:share` field.
 */
typedef ProducerEntry = {
	final fieldName: String;
	final producerTypeNames: Array<String>;
	final childDITypeName: Null<String>;
	final kind: ProducerKind;
	final pos: Position;
};

/**
 * Consumer entry collected from a DI class's `@:use` field.
 */
typedef ConsumerEntry = {
	final fieldName: String;
	final consumerTypeName: String;
	final pos: Position;
};

/**
 * Per-class summary collected by `DIBuilder` and consumed by `DIVerifier.analyze`.
 */
typedef DIClassSummary = {
	final typeName: String;
	final pos: Position;
	final superTypeName: Null<String>;
	final producers: Array<ProducerEntry>;
	final consumers: Array<ConsumerEntry>;
};

/**
 * Level 1 compile-time DI verifier.
 *
 * `DIBuilder` pushes per-class summaries into the static registry as `@:autoBuild`
 * fires. The first registration installs an `onAfterTyping` callback that runs
 * once after typing completes and verifies each use-form consumer against its
 * instantiation scope chain. Missing and ambiguous producers are reported via
 * `Context.error` at the consumer field's position.
 */
@:nullSafety(Strict) final class DIVerifier {

	private static final summaries: Map<String, DIClassSummary> = [];
	private static final erroredPositions: Array<String> = [];
	private static var analyzerInstalled: Bool = false;

	/**
	 * Create the summary for `typeName`. The first call installs the `onAfterTyping`
	 * analyzer hook.
	 */
	public static function beginClass(typeName: String, pos: Position, ?superTypeName: String): DIClassSummary {
		final summary: DIClassSummary = {
			typeName: typeName,
			pos: pos,
			superTypeName: superTypeName,
			producers: [],
			consumers: []
		};
		summaries[typeName] = summary;
		if (!analyzerInstalled) {
			analyzerInstalled = true;
			Context.onAfterTyping(_ -> analyze());
		}
		return summary;
	}

	public static inline function addProducer(summary: DIClassSummary, entry: ProducerEntry): Void {
		summary.producers.push(entry);
	}

	public static inline function addConsumer(summary: DIClassSummary, entry: ConsumerEntry): Void {
		summary.consumers.push(entry);
	}

	private static function analyze(): Void {
		if (hasCycle()) return;
		final parentsOf: Map<String, Array<String>> = buildParentMap();
		final subclassesOf: Map<String, Array<String>> = buildSubclassMap();
		final rootExports: Map<String, Array<ProducerEntry>> = collectRootExports(parentsOf);
		for (typeName => summary in summaries)
			if (hasInstantiationParent(typeName, parentsOf) || !hasSubclassesInRegistry(typeName, subclassesOf))
				verifyClass(summary, parentsOf, rootExports);
	}

	private static function buildParentMap(): Map<String, Array<String>> {
		final result: Map<String, Array<String>> = [];
		for (typeName => summary in summaries) for (producer in summary.producers) {
			final child: Null<String> = producer.childDITypeName;
			if (child == null) continue;
			final arr: Array<String> = getOrCreateBucket(result, child);
			if (!arr.contains(typeName)) arr.push(typeName);
		}
		return result;
	}

	private static function buildSubclassMap(): Map<String, Array<String>> {
		final result: Map<String, Array<String>> = [];
		for (typeName => summary in summaries) {
			final parent: Null<String> = summary.superTypeName;
			if (parent == null) continue;
			getOrCreateBucket(result, parent).push(typeName);
		}
		return result;
	}

	private static inline function getOrCreateBucket(map: Map<String, Array<String>>, key: String): Array<String> {
		final existing: Null<Array<String>> = map[key];
		if (existing != null) return existing;
		final fresh: Array<String> = [];
		map[key] = fresh;
		return fresh;
	}

	private static inline function hasSubclassesInRegistry(typeName: String, subclassesOf: Map<String, Array<String>>): Bool {
		final subs: Null<Array<String>> = subclassesOf[typeName];
		return subs != null && subs.length > 0;
	}

	private static inline function hasInstantiationParent(typeName: String, parentsOf: Map<String, Array<String>>): Bool {
		final parents: Null<Array<String>> = parentsOf[typeName];
		return parents != null && parents.length > 0;
	}

	/**
	 * DFS cycle detection across the instantiation DAG. Emits a single hard error at
	 * the first offending class position and returns `true` so the caller bails.
	 */
	private static function hasCycle(): Bool {
		final state: Map<String, Int> = []; // 1=in-stack, 2=done
		for (typeName in summaries.keys()) if ((state[typeName] ?? 0) != 2) {
			final stack: Array<String> = [];
			if (dfsCycle(typeName, state, stack)) return true;
		}
		return false;
	}

	private static function dfsCycle(typeName: String, state: Map<String, Int>, stack: Array<String>): Bool {
		final current: Int = state[typeName] ?? 0;
		if (current == 2) return false;
		if (current == 1) {
			final startIndex: Int = stack.indexOf(typeName);
			final cyclePath: Array<String> = startIndex >= 0 ? stack.slice(startIndex) : stack.copy();
			cyclePath.push(typeName);
			reportCycle(cyclePath);
			return true;
		}
		state[typeName] = 1;
		stack.push(typeName);
		final summary: Null<DIClassSummary> = summaries[typeName];
		if (summary != null) for (producer in summary.producers) {
			final child: Null<String> = producer.childDITypeName;
			if (child == null) continue;
			if (dfsCycle(child, state, stack)) return true;
		}
		stack.pop();
		state[typeName] = 2;
		return false;
	}

	private static function reportCycle(cyclePath: Array<String>): Void {
		final chain: String = cyclePath.join(' -> ');
		final headTypeName: String = cyclePath[0];
		final head: Null<DIClassSummary> = summaries[headTypeName];
		final pos: Position = head != null ? head.pos : Context.currentPos();
		Context.error('DI: instantiation cycle: $chain', pos);
	}

	/**
	 * Walk each root's subtree via the instantiation DAG and collect all producers
	 * marked `exprt`. Exported producers land in the root's provider at runtime, so
	 * statically they are visible at the root level regardless of where they were
	 * declared in the subtree.
	 */
	private static function collectRootExports(parentsOf: Map<String, Array<String>>): Map<String, Array<ProducerEntry>> {
		final result: Map<String, Array<ProducerEntry>> = [];
		for (typeName in summaries.keys()) if (!hasInstantiationParent(typeName, parentsOf)) {
			final exports: Array<ProducerEntry> = [];
			final visited: Array<String> = [];
			collectExportsInSubtree(typeName, exports, visited);
			if (exports.length > 0) result[typeName] = exports;
		}
		return result;
	}

	private static function collectExportsInSubtree(typeName: String, out: Array<ProducerEntry>, visited: Array<String>): Void {
		if (visited.contains(typeName)) return;
		visited.push(typeName);
		final summary: Null<DIClassSummary> = summaries[typeName];
		if (summary == null) return;
		for (producer in summary.producers) {
			if (producer.kind == Share) out.push(producer);
			final child: Null<String> = producer.childDITypeName;
			if (child != null) collectExportsInSubtree(child, out, visited);
		}
	}

	private static function verifyClass(
		summary: DIClassSummary, parentsOf: Map<String, Array<String>>, rootExports: Map<String, Array<ProducerEntry>>
	): Void {
		final mergedConsumers: Array<ConsumerEntry> = collectMergedConsumers(summary);
		if (mergedConsumers.length == 0) return;
		final paths: Array<Array<String>> = enumeratePaths(summary.typeName, parentsOf);
		for (consumer in mergedConsumers) for (path in paths)
			if (!checkConsumerOnPath(consumer, path, rootExports)) break;
	}

	private static function collectMergedConsumers(summary: DIClassSummary): Array<ConsumerEntry> {
		final result: Array<ConsumerEntry> = [];
		var current: Null<DIClassSummary> = summary;
		final visited: Array<String> = [];
		while (current != null && !visited.contains(current.typeName)) {
			visited.push(current.typeName);
			for (cons in current.consumers) result.push(cons);
			final parentName: Null<String> = current.superTypeName;
			current = parentName != null ? summaries[parentName] : null;
		}
		return result;
	}

	/**
	 * Enumerate all paths from a class up through its instantiation ancestors to a
	 * root. Each path is a list of class names starting with the origin and ending
	 * at a class with no instantiation parent.
	 */
	private static function enumeratePaths(typeName: String, parentsOf: Map<String, Array<String>>): Array<Array<String>> {
		final result: Array<Array<String>> = [];
		walkPaths(typeName, parentsOf, [], result);
		return result;
	}

	private static function walkPaths(
		typeName: String,
		parentsOf: Map<String, Array<String>>,
		acc: Array<String>,
		out: Array<Array<String>>
	): Void {
		final next: Array<String> = acc.concat([typeName]);
		final parents: Null<Array<String>> = parentsOf[typeName];
		if (parents == null || parents.length == 0) {
			out.push(next);
			return;
		}
		for (parent in parents) walkPaths(parent, parentsOf, next, out);
	}

	/**
	 * Walk `path` from the consumer's class upward. At each level gather the class's
	 * own producers (folded with its DI super chain); the final level additionally
	 * includes the root's collected `exprt` producers. Returns `true` when the
	 * consumer resolves on this path, `false` when an error has been emitted.
	 */
	private static function checkConsumerOnPath(
		consumer: ConsumerEntry, path: Array<String>, rootExports: Map<String, Array<ProducerEntry>>
	): Bool {
		final lastIndex: Int = path.length - 1;
		for (i in 0...path.length) {
			final levelClass: String = path[i];
			final locals: Array<ProducerEntry> = mergedLocalProducers(levelClass);
			final exports: Null<Array<ProducerEntry>> = i == lastIndex ? rootExports[levelClass] : null;
			final levelProducers: Array<ProducerEntry> = exports != null ? locals.concat(exports) : locals;
			final candidates: Array<ProducerEntry> = levelProducers.filter(
				p -> p.producerTypeNames.contains(consumer.consumerTypeName)
			);
			if (candidates.length == 0) continue;
			if (candidates.length == 1) return true;
			final named: Null<ProducerEntry> = candidates.find(p -> p.fieldName == consumer.fieldName);
			if (named != null) return true;
			emitAmbiguityError(consumer, levelClass, candidates);
			return false;
		}
		emitMissingError(consumer);
		return false;
	}

	/**
	 * Local producers at `typeName` including everything merged in from its DI
	 * super chain. `DIBuilder` generates `super.load(provider, ...)` so at runtime
	 * ancestor producers live in the subclass's provider at the same level.
	 */
	private static function mergedLocalProducers(typeName: String): Array<ProducerEntry> {
		final result: Array<ProducerEntry> = [];
		var current: Null<DIClassSummary> = summaries[typeName];
		final visited: Array<String> = [];
		while (current != null && !visited.contains(current.typeName)) {
			visited.push(current.typeName);
			for (producer in current.producers) result.push(producer);
			final parentName: Null<String> = current.superTypeName;
			current = parentName != null ? summaries[parentName] : null;
		}
		return result;
	}

	private static function emitMissingError(consumer: ConsumerEntry): Void {
		if (markErrored(consumer.pos)) return;
		final msg: String = 'DI: no producer for type "${consumer.consumerTypeName}" reachable from field "${consumer.fieldName}"';
		Context.error(msg, consumer.pos);
	}

	private static function emitAmbiguityError(
		consumer: ConsumerEntry, atClass: String, candidates: Array<ProducerEntry>
	): Void {
		if (markErrored(consumer.pos)) return;
		final names: String = candidates.map(p -> '"${p.fieldName}"').join(', ');
		final msg: String = 'DI: ambiguous service "${consumer.consumerTypeName}" at scope of $atClass — field name "${consumer.fieldName}" matches none of {$names}';
		Context.error(msg, consumer.pos);
	}

	/**
	 * Returns `true` if this position has already produced an error in this run
	 * (dedupe across multi-path verification).
	 */
	private static function markErrored(pos: Position): Bool {
		final info: {file: String, min: Int, max: Int} = Context.getPosInfos(pos);
		final key: String = '${info.file}:${info.min}:${info.max}';
		if (erroredPositions.contains(key)) return true;
		erroredPositions.push(key);
		return false;
	}

}

#end
