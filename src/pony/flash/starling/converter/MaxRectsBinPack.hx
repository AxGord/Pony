package pony.flash.starling.converter;

/*
	Based on the Public Domain MaxRectanglesBinPack.cpp source by Jukka Jylänki
	https://github.com/juj/RectangleBinPack/

	Based on C# port by Sven Magnus
	http://unifycommunity.com/wiki/index.php?title=MaxRectanglesBinPack


	Ported to ActionScript3 by DUZENGQIANG
	http://www.duzengqiang.com/blog/post/971.html
	This version is also public domain - do whatever you want with it.
 */
import flash.display.*;
import flash.events.*;
import flash.geom.Rectangle;
import flash.net.*;
import flash.Vector;

class MaxRectsBinPack {

	public static inline var MAX_VALUE: Int = 2147483647;

	public var binWidth: Int = 0;
	public var binHeight: Int = 0;
	public var allowRotations: Bool = false;

	public var usedRectangles: Vector<Rectangle> = new Vector<Rectangle>();
	public var freeRectangles: Vector<Rectangle> = new Vector<Rectangle>();

	private var score1: Int = 0; // Unused in this function. We don't need to know the score after finding the position.
	private var score2: Int = 0;
	private var bestShortSideFit: Int;
	private var bestLongSideFit: Int;

	public function new(width: Int, height: Int, rotations: Bool = true) {
		init(width, height, rotations);
	}

	private function init(width: Int, height: Int, rotations: Bool = true): Void {
		// if( count(width) % 1 != 0 ||count(height) % 1 != 0)
		//    throw new Error("Must be 2,4,8,16,32,...512,1024,...");
		binWidth = width;
		binHeight = height;
		allowRotations = rotations;

		var n: Rectangle = new Rectangle();
		n.x = 0;
		n.y = 0;
		n.width = width;
		n.height = height;

		usedRectangles.length = 0;

		freeRectangles.length = 0;
		freeRectangles.push(n);
	}

	private function count(n: Float): Float {
		if (n >= 2)
			return count(n / 2);
		return n;
	}

	/**
	 * Insert a new Rectangle
	 */
	public function insert(width: Int, height: Int, method: Int): Rectangle {
		var newNode: Rectangle = new Rectangle();
		score1 = 0;
		score2 = 0;
		switch (method) {
			case FreeRectangleChoiceHeuristic.BestShortSideFit:
				newNode = findPositionForNewNodeBestShortSideFit(width, height);
			case FreeRectangleChoiceHeuristic.BottomLeftRule:
				newNode = findPositionForNewNodeBottomLeft(width, height, score1, score2);
			case FreeRectangleChoiceHeuristic.ContactPoIntRule:
				newNode = findPositionForNewNodeContactPoInt(width, height, score1);
			case FreeRectangleChoiceHeuristic.BestLongSideFit:
				newNode = findPositionForNewNodeBestLongSideFit(width, height, score2, score1);
			case FreeRectangleChoiceHeuristic.BestAreaFit:
				newNode = findPositionForNewNodeBestAreaFit(width, height, score1, score2);
		}

		if (newNode.height == 0)
			return newNode;

		placeRectangle(newNode);
		// trace(newNode);
		return newNode;
	}

	private function insert2(rectangles: Vector<Rectangle>, dst: Vector<Rectangle>, method: Int): Void {
		dst.length = 0;
		while (rectangles.length > 0) {
			var bestScore1: Int = MAX_VALUE;
			var bestScore2: Int = MAX_VALUE;
			var bestRectangleIndex: Int = -1;
			var bestNode: Rectangle = new Rectangle();
			for (i in 0...rectangles.length) {
				var score1: Int = 0;
				var score2: Int = 0;
				var newNode: Rectangle = scoreRectangle(cast rectangles[i].width, cast rectangles[i].height, method, score1, score2);
				if (score1 < bestScore1 || (score1 == bestScore1 && score2 < bestScore2)) {
					bestScore1 = score1;
					bestScore2 = score2;
					bestNode = newNode;
					bestRectangleIndex = i;
				}
			}
			if (bestRectangleIndex == -1) return;
			placeRectangle(bestNode);
			rectangles.splice(bestRectangleIndex, 1);
		}
	}

	private function placeRectangle(node: Rectangle): Void {
		var numRectanglesToProcess: Int = freeRectangles.length;
		// for(i in 0...numRectanglesToProcess) {
		var i: Int = 0;
		while (i < numRectanglesToProcess) {
			if (splitFreeNode(freeRectangles[i], node)) {
				freeRectangles.splice(i, 1);
				--i;
				--numRectanglesToProcess;
			}
			i++;
		}

		pruneFreeList();

		usedRectangles.push(node);
	}

	private function scoreRectangle(width: Int, height: Int, method: Int, score1: Int, score2: Int): Rectangle {
		var newNode: Rectangle = new Rectangle();
		score1 = MAX_VALUE;
		score2 = MAX_VALUE;
		switch (method) {
			case FreeRectangleChoiceHeuristic.BestShortSideFit:
				newNode = findPositionForNewNodeBestShortSideFit(width, height);
			case FreeRectangleChoiceHeuristic.BottomLeftRule:
				newNode = findPositionForNewNodeBottomLeft(width, height, score1, score2);
			case FreeRectangleChoiceHeuristic.ContactPoIntRule:
				newNode = findPositionForNewNodeContactPoInt(width, height, score1);
				// todo: reverse
				score1 = -score1; // Reverse since we are minimizing, but for contact poInt score bigger is better.
			case FreeRectangleChoiceHeuristic.BestLongSideFit:
				newNode = findPositionForNewNodeBestLongSideFit(width, height, score2, score1);
			case FreeRectangleChoiceHeuristic.BestAreaFit:
				newNode = findPositionForNewNodeBestAreaFit(width, height, score1, score2);
		}

		// Cannot fit the current Rectangle.
		if (newNode.height == 0) {
			score1 = MAX_VALUE;
			score2 = MAX_VALUE;
		}

		return newNode;
	}

	/// Computes the ratio of used surface area.
	private function occupancy(): Float {
		var usedSurfaceArea: Float = 0;
		for (i in 0...usedRectangles.length)
			usedSurfaceArea += usedRectangles[i].width * usedRectangles[i].height;

		return usedSurfaceArea / (binWidth * binHeight);
	}

	private function findPositionForNewNodeBottomLeft(width: Int, height: Int, bestY: Int, bestX: Int): Rectangle {
		var bestNode: Rectangle = new Rectangle();
		// memset(bestNode, 0, sizeof(Rectangle));

		bestY = MAX_VALUE;
		var rect: Rectangle;
		var topSideY: Int;
		for (i in 0...freeRectangles.length) {
			rect = freeRectangles[i];
			// Try to place the Rectangle in upright (non-flipped) orientation.
			if (rect.width >= width && rect.height >= height) {
				topSideY = cast(rect.y + height);
				if (topSideY < bestY || (topSideY == bestY && rect.x < bestX)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = width;
					bestNode.height = height;
					bestY = topSideY;
					bestX = cast rect.x;
				}
			}
			if (allowRotations && rect.width >= height && rect.height >= width) {
				topSideY = cast(rect.y + width);
				if (topSideY < bestY || (topSideY == bestY && rect.x < bestX)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = height;
					bestNode.height = width;
					bestY = topSideY;
					bestX = cast rect.x;
				}
			}
		}
		return bestNode;
	}

	private function findPositionForNewNodeBestShortSideFit(width: Int, height: Int): Rectangle {
		var bestNode: Rectangle = new Rectangle();
		// memset(&bestNode, 0, sizeof(Rectangle));

		bestShortSideFit = MAX_VALUE;
		bestLongSideFit = score2;
		var rect: Rectangle;
		var leftoverHoriz: Int;
		var leftoverVert: Int;
		var shortSideFit: Int;
		var longSideFit: Int;

		for (i in 0...freeRectangles.length) {
			rect = freeRectangles[i];
			// Try to place the Rectangle in upright (non-flipped) orientation.
			if (rect.width >= width && rect.height >= height) {
				leftoverHoriz = cast Math.abs(rect.width - width);
				leftoverVert = cast Math.abs(rect.height - height);
				shortSideFit = cast Math.min(leftoverHoriz, leftoverVert);
				longSideFit = cast Math.max(leftoverHoriz, leftoverVert);

				if (shortSideFit < bestShortSideFit || (shortSideFit == bestShortSideFit && longSideFit < bestLongSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = width;
					bestNode.height = height;
					bestShortSideFit = shortSideFit;
					bestLongSideFit = longSideFit;
				}
			}
			var flippedLeftoverHoriz: Int;
			var flippedLeftoverVert: Int;
			var flippedShortSideFit: Int;
			var flippedLongSideFit: Int;
			if (allowRotations && rect.width >= height && rect.height >= width) {
				flippedLeftoverHoriz = cast Math.abs(rect.width - height);
				flippedLeftoverVert = cast Math.abs(rect.height - width);
				flippedShortSideFit = cast Math.min(flippedLeftoverHoriz, flippedLeftoverVert);
				flippedLongSideFit = cast Math.max(flippedLeftoverHoriz, flippedLeftoverVert);

				if (flippedShortSideFit < bestShortSideFit
					|| (flippedShortSideFit == bestShortSideFit && flippedLongSideFit < bestLongSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = height;
					bestNode.height = width;
					bestShortSideFit = flippedShortSideFit;
					bestLongSideFit = flippedLongSideFit;
				}
			}
		}

		return bestNode;
	}

	private function findPositionForNewNodeBestLongSideFit(width: Int, height: Int, bestShortSideFit: Int, bestLongSideFit: Int): Rectangle {
		var bestNode: Rectangle = new Rectangle();
		// memset(&bestNode, 0, sizeof(Rectangle));
		bestLongSideFit = MAX_VALUE;
		var rect: Rectangle;

		var leftoverHoriz: Int;
		var leftoverVert: Int;
		var shortSideFit: Int;
		var longSideFit: Int;
		for (i in 0...freeRectangles.length) {
			rect = freeRectangles[i];
			// Try to place the Rectangle in upright (non-flipped) orientation.
			if (rect.width >= width && rect.height >= height) {
				leftoverHoriz = cast Math.abs(rect.width - width);
				leftoverVert = cast Math.abs(rect.height - height);
				shortSideFit = cast Math.min(leftoverHoriz, leftoverVert);
				longSideFit = cast Math.max(leftoverHoriz, leftoverVert);

				if (longSideFit < bestLongSideFit || (longSideFit == bestLongSideFit && shortSideFit < bestShortSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = width;
					bestNode.height = height;
					bestShortSideFit = shortSideFit;
					bestLongSideFit = longSideFit;
				}
			}

			if (allowRotations && rect.width >= height && rect.height >= width) {
				leftoverHoriz = cast Math.abs(rect.width - height);
				leftoverVert = cast Math.abs(rect.height - width);
				shortSideFit = cast Math.min(leftoverHoriz, leftoverVert);
				longSideFit = cast Math.max(leftoverHoriz, leftoverVert);

				if (longSideFit < bestLongSideFit || (longSideFit == bestLongSideFit && shortSideFit < bestShortSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = height;
					bestNode.height = width;
					bestShortSideFit = shortSideFit;
					bestLongSideFit = longSideFit;
				}
			}
		}
		trace(bestNode);
		return bestNode;
	}

	private function findPositionForNewNodeBestAreaFit(width: Int, height: Int, bestAreaFit: Int, bestShortSideFit: Int): Rectangle {
		var bestNode: Rectangle = new Rectangle();
		// memset(&bestNode, 0, sizeof(Rectangle));

		bestAreaFit = MAX_VALUE;

		var rect: Rectangle;

		var leftoverHoriz: Int;
		var leftoverVert: Int;
		var shortSideFit: Int;
		var areaFit: Int;

		for (i in 0...freeRectangles.length) {
			rect = freeRectangles[i];
			areaFit = cast(rect.width * rect.height - width * height);

			// Try to place the Rectangle in upright (non-flipped) orientation.
			if (rect.width >= width && rect.height >= height) {
				leftoverHoriz = cast Math.abs(rect.width - width);
				leftoverVert = cast Math.abs(rect.height - height);
				shortSideFit = cast Math.min(leftoverHoriz, leftoverVert);

				if (areaFit < bestAreaFit || (areaFit == bestAreaFit && shortSideFit < bestShortSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = width;
					bestNode.height = height;
					bestShortSideFit = shortSideFit;
					bestAreaFit = areaFit;
				}
			}

			if (allowRotations && rect.width >= height && rect.height >= width) {
				leftoverHoriz = cast Math.abs(rect.width - height);
				leftoverVert = cast Math.abs(rect.height - width);
				shortSideFit = cast Math.min(leftoverHoriz, leftoverVert);

				if (areaFit < bestAreaFit || (areaFit == bestAreaFit && shortSideFit < bestShortSideFit)) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = height;
					bestNode.height = width;
					bestShortSideFit = shortSideFit;
					bestAreaFit = areaFit;
				}
			}
		}
		return bestNode;
	}

	/// Returns 0 if the two Intervals i1 and i2 are disjoInt, or the length of their overlap otherwise.
	private function commonIntervalLength(i1start: Int, i1end: Int, i2start: Int, i2end: Int): Int {
		if (i1end < i2start || i2end < i1start)
			return 0;
		return cast(Math.min(i1end, i2end) - Math.max(i1start, i2start));
	}

	private function contactPoIntScoreNode(x: Int, y: Int, width: Int, height: Int): Int {
		var score: Int = 0;

		if (x == 0 || x + width == binWidth)
			score += height;
		if (y == 0 || y + height == binHeight)
			score += width;
		var rect: Rectangle;
		for (i in 0...usedRectangles.length) {
			rect = usedRectangles[i];
			if (rect.x == x + width || rect.x + rect.width == x)
				score += commonIntervalLength(cast rect.y, cast(rect.y + rect.height), y, y + height);
			if (rect.y == y + height || rect.y + rect.height == y)
				score += commonIntervalLength(cast rect.x, cast(rect.x + rect.width), x, x + width);
		}
		return score;
	}

	private function findPositionForNewNodeContactPoInt(width: Int, height: Int, bestContactScore: Int): Rectangle {
		var bestNode: Rectangle = new Rectangle();
		// memset(&bestNode, 0, sizeof(Rectangle));

		bestContactScore = -1;

		var rect: Rectangle;
		var score: Int;
		for (i in 0...freeRectangles.length) {
			rect = freeRectangles[i];
			// Try to place the Rectangle in upright (non-flipped) orientation.
			if (rect.width >= width && rect.height >= height) {
				score = contactPoIntScoreNode(cast rect.x, cast rect.y, width, height);
				if (score > bestContactScore) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = width;
					bestNode.height = height;
					bestContactScore = score;
				}
			}
			if (allowRotations && rect.width >= height && rect.height >= width) {
				score = contactPoIntScoreNode(cast rect.x, cast rect.y, height, width);
				if (score > bestContactScore) {
					bestNode.x = rect.x;
					bestNode.y = rect.y;
					bestNode.width = height;
					bestNode.height = width;
					bestContactScore = score;
				}
			}
		}
		return bestNode;
	}

	private function splitFreeNode(freeNode: Rectangle, usedNode: Rectangle): Bool {
		// Test with SAT if the Rectangles even Intersect.
		if (usedNode.x >= freeNode.x + freeNode.width
			|| usedNode.x + usedNode.width <= freeNode.x
			|| usedNode.y >= freeNode.y + freeNode.height
			|| usedNode.y + usedNode.height <= freeNode.y)
			return false;
		var newNode: Rectangle;
		if (usedNode.x < freeNode.x + freeNode.width && usedNode.x + usedNode.width > freeNode.x) {
			// New node at the top side of the used node.
			if (usedNode.y > freeNode.y && usedNode.y < freeNode.y + freeNode.height) {
				newNode = freeNode.clone();
				newNode.height = usedNode.y - newNode.y;
				freeRectangles.push(newNode);
			}

			// New node at the bottom side of the used node.
			if (usedNode.y + usedNode.height < freeNode.y + freeNode.height) {
				newNode = freeNode.clone();
				newNode.y = usedNode.y + usedNode.height;
				newNode.height = freeNode.y + freeNode.height - (usedNode.y + usedNode.height);
				freeRectangles.push(newNode);
			}
		}

		if (usedNode.y < freeNode.y + freeNode.height && usedNode.y + usedNode.height > freeNode.y) {
			// New node at the left side of the used node.
			if (usedNode.x > freeNode.x && usedNode.x < freeNode.x + freeNode.width) {
				newNode = freeNode.clone();
				newNode.width = usedNode.x - newNode.x;
				freeRectangles.push(newNode);
			}

			// New node at the right side of the used node.
			if (usedNode.x + usedNode.width < freeNode.x + freeNode.width) {
				newNode = freeNode.clone();
				newNode.x = usedNode.x + usedNode.width;
				newNode.width = freeNode.x + freeNode.width - (usedNode.x + usedNode.width);
				freeRectangles.push(newNode);
			}
		}

		return true;
	}

	private function pruneFreeList(): Void {
		var i: Int = 0;
		var j: Int = 0;
		while (i < freeRectangles.length) {
			j = i + 1;
			while (j < freeRectangles.length) {
				if (isContainedIn(freeRectangles[i], freeRectangles[j])) {
					freeRectangles.splice(i, 1);
					break;
				}
				if (isContainedIn(freeRectangles[j], freeRectangles[i])) {
					freeRectangles.splice(j, 1);
				}
				j++;
			}
			i++;
		}
	}

	private function isContainedIn(a: Rectangle, b: Rectangle): Bool {
		return a.x >= b.x && a.y >= b.y && a.x + a.width <= b.x + b.width && a.y + a.height <= b.y + b.height;
	}

}

class FreeRectangleChoiceHeuristic {

	public static inline var BestShortSideFit: Int = 0; ///< -BSSF: Positions the Rectangle against the short side of a free Rectangle Into which it fits the best.
	public static inline var BestLongSideFit: Int = 1; ///< -BLSF: Positions the Rectangle against the long side of a free Rectangle Into which it fits the best.
	public static inline var BestAreaFit: Int = 2; ///< -BAF: Positions the Rectangle Into the smallest free Rectangle Into which it fits.
	public static inline var BottomLeftRule: Int = 3; ///< -BL: Does the Tetris placement.
	public static inline var ContactPoIntRule: Int = 4; ///< -CP: Choosest the placement where the Rectangle touches other Rectangles as much as possible.

}