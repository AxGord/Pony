package pony.heaps;

#if js
import js.Browser;
import js.html.AudioElement;
import js.html.Blob;
import js.html.URL;
import js.html.VisibilityState;
import js.html.audio.AudioContext;
import js.lib.ArrayBuffer;
import js.lib.DataView;
#end

/**
 * Two unrelated things silence a browser game, and both are cured here because both are cured the
 * same way — by not letting the page's audio be something the system may quietly take away.
 *
 * On iOS only the `playback` session is audible at all; a long lock then tears that session down,
 * after which WebAudio is dead past a page reload while `<audio>` playback survives untouched. A
 * looping silent `<audio>` is therefore what holds the session open. It costs a Now Playing entry
 * while the game is in the background: measured, that entry cannot be removed without losing the
 * session with it.
 *
 * On every platform a hidden tab gets no `requestAnimationFrame`, so heaps stops feeding its
 * streaming driver and the sound starves into stutter. Freezing the context stops that, and it
 * resumes where it left off rather than replaying whatever went stale.
 */
@:nullSafety(Strict) class AudioSessionKeeper {

	#if js
	/** The clip is silence, so its length decides only how often the loop wraps. */
	private static inline final RATE: Int = 8000;

	/** Audible enough that the system counts it as playing, quiet enough to be nothing. */
	private static inline final VOLUME: Float = 0.001;

	// The WAV container, which is all these are: a 44-byte header whose RIFF size field counts
	// everything after its own first 8 bytes, then one 16-byte PCM `fmt ` chunk.
	private static inline final HEADER: Int = 44;
	private static inline final RIFF_PREFIX: Int = 8;
	private static inline final FMT_SIZE: Int = 16;
	private static inline final PCM: Int = 1;
	private static inline final CHANNELS: Int = 1;
	private static inline final BITS: Int = 16;
	private static inline final SAMPLE_BYTES: Int = 2;
	private static inline final INT32: Int = 4;
	private static inline final INT16: Int = 2;

	private static var keeper: Null<AudioElement> = null;

	public static function init(): Void {
		if (keeper != null) return;
		requestPlayback();
		final element: AudioElement = Browser.document.createAudioElement();
		element.src = silentWav();
		element.loop = true;
		element.volume = VOLUME;
		keeper = element;
		// Autoplay needs a gesture, and the first one is also when the game starts wanting sound.
		Browser.document.addEventListener('pointerdown', pointerHandler, true);
		Browser.document.addEventListener('visibilitychange', visibilityHandler);
	}

	private static function pointerHandler(): Void {
		Browser.document.removeEventListener('pointerdown', pointerHandler, true);
		playKeeper();
	}

	private static function visibilityHandler(): Void {
		final context: Null<AudioContext> = @:privateAccess hxd.snd.webaudio.Context.ctx;
		if (Browser.document.visibilityState == VisibilityState.VISIBLE) {
			requestPlayback();
			playKeeper();
			if (context != null) context.resume();
		} else if (context != null) {
			context.suspend();
		}
	}

	/** A lock can stop it; it has to be put back or the next background spell is unguarded. */
	private static function playKeeper(): Void {
		final element: Null<AudioElement> = keeper;
		if (element != null && element.paused) element.play().catchError(ignoreHandler);
	}

	private static function ignoreHandler(error: Any): Void {}

	private static inline function requestPlayback(): Void
		js.Syntax.code('if (navigator.audioSession) navigator.audioSession.type = "playback"');

	/** A second of 8 kHz silence, built here so that no project has to ship an asset for it. */
	private static function silentWav(): String {
		final size: Int = RATE * SAMPLE_BYTES;
		final buffer: ArrayBuffer = new ArrayBuffer(HEADER + size);
		final view: DataView = new DataView(buffer);
		var pos: Int = 0;
		inline function text(value: String): Void {
			for (i in 0...value.length) view.setUint8(pos++, value.charCodeAt(i) ?? 0);
		}
		inline function u32(value: Int): Void {
			view.setUint32(pos, value, true);
			pos += INT32;
		}
		inline function u16(value: Int): Void {
			view.setUint16(pos, value, true);
			pos += INT16;
		}
		text('RIFF');
		u32(HEADER - RIFF_PREFIX + size);
		text('WAVE');
		text('fmt ');
		u32(FMT_SIZE);
		u16(PCM);
		u16(CHANNELS);
		u32(RATE);
		u32(RATE * SAMPLE_BYTES);
		u16(SAMPLE_BYTES);
		u16(BITS);
		text('data');
		u32(size);
		return URL.createObjectURL(new Blob([buffer], { type: 'audio/wav' }));
	}
	#end

}
