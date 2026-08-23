# `scaleMode` — keeping a downscale pixelated

`<texturepacker scale="0.5">` hands TexturePacker `--scale`, and TexturePacker interpolates.
For a pixel-art game that is the wrong half of the job: the art comes out smaller *and*
blurred, so drawing it back up gives mush instead of bigger pixels. `scaleMode` picks the
filter:

```xml
<texturepacker group="assets" format="libgdx png" from="assets_source/" to="bin/assets/"
	ext="atlas" rotation="false" trim="None" pot="true" extrude="1">
	<unit>
		<output>game</output>
		<input>frames/</input>
		<input>art/</input>
	</unit>
	<unit scale="0.35" scaleMode="Fast">
		<output>world</output>
		<input>world/</input>
	</unit>
</texturepacker>
```

The value goes straight to `--scale-mode`, so it takes whatever the installed TexturePacker
accepts — `Smooth` (the default, and what the module used unconditionally before), `Fast`
(nearest neighbour, the one that keeps hard edges), and the fixed-ratio upscalers `Scale2x`,
`Scale3x`, `Scale4x`, `Eagle`, `Hq2x`. It is read only when `scale` is not 1.

Like every other attribute it may sit on `<texturepacker>`, on a nested `<path>` or on a
single `<unit>`, and the inner one wins — which is what lets one atlas keep its native size
while another is packed small, as above. Note that `scale` is the exception that accumulates
by multiplication rather than overriding.

## Sizing the scale

Pick the factor from the size you want in the atlas, not from the ratio you have in mind:
TexturePacker rounds, so `1/3` of a 70px tile lands on 23 and `0.35` lands on 24. Aim for a
number that divides cleanly by the scale the game draws at, or the blown-up art sits on a
fractional grid and the pixels come out uneven.

Region names stay relative to each `<input>` root, so a `<unit>` that packs a subdirectory of
another unit's input renames everything under it. Give the art that gets scaled its own root
directory instead of reaching into a shared one.

A second scale means a second atlas, and a second atlas is a second file the game has to
load. When the scaled art is pixel art anyway, [`<resize>`](resize.md) shrinks the files
before the packer sees them and everything fits in one.
