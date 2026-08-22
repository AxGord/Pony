# `<spritesheet>` — cutting sheets into frames

Sprite packers take single-sprite files, so an artist-supplied sheet (a run cycle laid out
as one strip, a coin spun across eight cells) has to be cut before it can be packed. The
`<spritesheet>` module does that cut as a build step, so the sheet stays the only source
file in the repository.

It runs in the `prepare` section at priority 2 — before `<texturepacker>` (3), so the frames
it writes are already on disk when the packer walks the input directory.

```xml
<spritesheet group="assets" from="assets_pack/" to="assets_source/frames/">
	<unit wh="82 66" to="horse/run" colorKey="#FFFFFF">horse_run_cycle.png</unit>
	<unit wh="32 32" to="coin/gold">coin_gold.png</unit>
</spritesheet>
```

writes `assets_source/frames/horse/run_0.png` … `run_4.png` and `coin/gold_0.png` … `gold_7.png`.

The `_<index>` suffix is what a libgdx atlas folds back into a single region with frame
indices, which is what `pony.ui.AssetManager.animation` reads.

## Attributes

Attributes may sit on `<spritesheet>`, on a nested `<path>`, or on a `<unit>`; the inner
value wins. `<before>` / `<after>` and the section tags (`<prepare>`, `<build>`, …) work as
in every other module.

| Attribute | Meaning |
|-----------|---------|
| `from`    | Prefix for input paths (accumulates through nesting). |
| `to`      | Prefix for output paths (accumulates through nesting). |
| `wh`      | Cell size — `"82 66"` or `"82x66"`. A single number means a square cell. |
| `w`, `h`  | Cell size one side at a time. |
| `count`   | How many frames to write. Omit to take the whole grid. |
| `colorKey`| Backdrop color to erase, e.g. `"#FFFFFF"`. Any pixel matching it exactly becomes fully transparent. |

A `<unit>`'s body is the input file; its `to` attribute is the output prefix, defaulting to
the input path without a suffix. Cells are read left to right, top to bottom, and numbering
follows that order — so `count` trims the tail of a sheet whose last row is padding.

`colorKey` matches exact pixel values, so it suits pixel art drawn on a flat backdrop and not
an anti-aliased render, where the halo around each edge is a different color on every pixel.

Only 32-bit PNG in, 32-bit PNG out, no scaling or trimming: an alpha-trimming pass belongs
to the packer, which knows the atlas layout. Keep `trim="None"` on `<texturepacker>` when the
frames are animation cells — trimming each cell to its own alpha bounds is exactly what makes
an animation wobble.
