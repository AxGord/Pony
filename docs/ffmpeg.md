# `<ffmpeg>` — converting media the other audio modules cannot read

`<lame>` and `<oggenc>` drive one encoder each, and both encoders read wav and nothing else. So
a source kept in a lossless container — flac, aiff, the audio track of a movie file — has no way
through either of them; there is no wav to hand over and no module that makes one. `<ffmpeg>` is
the one that reads whatever ffmpeg reads.

It runs in the `prepare` section at priority 24, the same slot as `<lame>` and `<oggenc>`.

```xml
<ffmpeg group="assets" from="assets_source/" to="bin/assets/" ext="mp3" q="4">
	<dir filter=".flac">music/</dir>
	<dir filter=".flac">sound/</dir>
</ffmpeg>
```

converts every `.flac` under `assets_source/music/` and `assets_source/sound/` into mp3 under
`bin/assets/music/` and `bin/assets/sound/`, keeping each file's path below its directory.

`<unit>` names one file instead, for a source that needs different settings than the rest of
its directory:

```xml
<unit>music/main.flac</unit>
<unit to="music/theme.ogg">music/lose.flac</unit>
```

## The target format is `ext`, and nothing else

ffmpeg picks its encoder from the output file's extension, so `ext` is the whole format
decision and changing it is one attribute. `ext="ogg"` writes Vorbis, `ext="wav"` writes PCM,
and `q` — passed through as `-q:a` — means whatever the chosen encoder's quality scale means.
An encoder with no quality scale is why `q` is left off the command line entirely when the
attribute is absent, rather than defaulting to a number: `-q:a` on a PCM output is not a
setting, it is an error.

That matters more than it sounds. A format decision made for one reason — say mp3 for
universal browser support — can turn out to be wrong for another — say a music loop, where
mp3's encoder padding lands as a gap that ogg and wav do not have. When the format lives in
one attribute, finding that out costs an attribute rather than a pipeline.

## Attributes

Attributes may sit on `<ffmpeg>`, on a nested `<path>`, or on a `<unit>` / `<dir>`; the inner
value wins. `<before>` / `<after>` and the section tags (`<prepare>`, `<build>`, …) work as in
every other module.

| Attribute | Meaning |
|-----------|---------|
| `from`    | Prefix for input paths (accumulates through nesting). |
| `to`      | Prefix for output paths (accumulates through nesting). |
| `ext`     | Output extension, and so the output format. Default `mp3`. |
| `q`       | Encoder quality, passed as `-q:a`. Omitted from the command line when the attribute is absent. |
| `af`      | An ffmpeg audio filter chain, passed as `-af`. Inherited like the rest; a `<unit>` may override it. |
| `filter`  | On a `<dir>`: which files to take, as a plain filename suffix. Space-separated alternatives. |

A `<unit>`'s body is the input file and a `<dir>`'s is the input directory; `to` is the output
path in both cases, defaulting to the input path with its extension replaced.

`filter` is matched as a plain suffix, which is why it is worth writing the dot: `.flac` takes
`main.flac` and leaves a file named `weirdflac` alone, where `flac` takes both. A directory that
does not exist, and a directory where the filter matches nothing, both end the build — a source
that quietly failed to convert becomes an asset the game asks for at runtime and nobody wrote.

## `af`, and why a level belongs here rather than in the game

`af` is handed to ffmpeg as `-af`, so anything ffmpeg can do to a stream is available; the reason
it exists is `volume`. A pack of sounds authored in one sitting is rarely balanced — a click
recorded 16 dB below the rest is a click nobody hears — and the obvious place to fix that is the
game, by playing the quiet one louder.

That works in a browser and not on a desktop. Heaps plays through WebAudio on js, where a gain
above 1 is simply a multiplication, and through OpenAL on hl, where `AL_GAIN` is documented to
CLAMP at 1 — heaps even says so out loud under `#if hlopenal`. So a sound lifted in code comes
out right in one build and flat in the other, and nothing in the code says why.

Correcting it here has neither problem: the file ships at the level it should play at, every
channel volume stays in 0..1, and the number sits next to the filename where the next person can
read the whole mix at once.

```xml
<unit af="volume=12dB">btn_select.flac</unit>
<unit af="volume=-9dB">coin1.flac</unit>
```

Check the headroom before boosting — `ffmpeg -i in.flac -af volumedetect -f null -` prints the
peak, and a boost past it clips. Reducing is always safe.

## Replacing the extension

The output name is the input name with everything after its last dot replaced. `<lame>` and
`<oggenc>` cut a fixed three characters instead, which is correct for the one extension they
can read and wrong for every other length: through those modules `main.flac` comes out as
`main.flmp3`. A dot inside a directory name is not treated as an extension, and a name with no
dot at all gets one appended.

## ffmpeg's own flags

Every conversion runs as

```
ffmpeg -v error -y -i <input> [-q:a <q>] <output>
```

`-y` because a prepare that has already run leaves the output sitting there, and the overwrite
prompt would hang the build with no indication of why. `-v error` because ffmpeg prints its
whole build banner on each invocation, and a directory's worth of them buries everything else
in the log.

ffmpeg has to be on `PATH`.
