package pony.js.node;

import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.Encoding;
import haxe.io.UInt8Array;
import js.Node;
import js.lib.ArrayBuffer;
import js.lib.Uint8Array;
import js.node.Buffer;

using pony.text.TextTools;

/**
 * NodeJS utils
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class NodeJSUtils {

	public static var majorVersion(get, never): UInt;

	private static var _majorVersion: Int = -1;

	private static inline function get_majorVersion(): UInt {
		if (_majorVersion == -1) {
			var s: Null<Int> = Std.parseInt(Node.process.version.substr(1).allBefore('.'));
			_majorVersion = s ?? 0;
		}
		return _majorVersion;
	}

	public static inline function arrayBufferToBytes(buffer: ArrayBuffer): Bytes {
		// Array buffer is a string on older versions of node - fromArray is used to parse the string
		return Bytes.ofData(majorVersion == 0 ? UInt8Array.fromArray(cast buffer).getData().buffer : buffer);
	}

	public static inline function bufferToBytes(buffer: Buffer): Bytes {
		// Buffer is a string on older versions of node - fromArray is used to parse the string
		return Bytes.ofData(majorVersion == 0 ? UInt8Array.fromArray(cast buffer).getData().buffer : buffer.buffer);
	}

	public static inline function bytesToBuffer(bytes: Bytes): Buffer {
		return majorVersion < 6 ? new Buffer(UInt8Array.fromBytes(bytes)) : Buffer.from(bytes.getData(), 0, bytes.length);
	}

}
