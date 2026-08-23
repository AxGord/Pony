# `<resize>` — coarsening art before it is packed

`<texturepacker scale="...">` scales a whole sheet. That is the only scale there is, so art
that has to end up smaller than the rest — pixel art lifted from a pack drawn at some other
resolution — used to need an atlas of its own just to carry a different `scale`. `<resize>`
moves the shrink one step earlier, onto the files, and the packer then has one size to deal
with and the game one atlas to load.

It runs in the `prepare` section at priority 2, alongside `<spritesheet>` and before
`<texturepacker>` (3), so what it writes is on disk when the packer walks its inputs.

```xml
<resize group="assets" from="assets_source/world/" to="assets_built/world/" wh="24">
	<dir>tiles/</dir>
</resize>
```

reads every PNG under `assets_source/world/tiles/` — three 70x70 tiles — and writes them 24x24
into `assets_built/world/tiles/`.

`<dir>` walks the directory recursively and keeps each file's path below it, which is what you
want when the packer will read the whole output tree: art dropped into the source directory is
resized without touching this file. `<unit>` names one file instead, for the cases where the
directory holds something that must not be resized, or must be resized differently:

```xml
<unit wh="24">tiles/ground.png</unit>
<unit w="48" to="tiles/big_fence.png">tiles/fence.png</unit>
```

## Attributes

Attributes may sit on `<resize>`, on a nested `<path>`, or on a `<unit>` / `<dir>`; the inner
value wins. `<before>` / `<after>` and the section tags (`<prepare>`, `<build>`, …) work as in
every other module.

| Attribute | Meaning |
|-----------|---------|
| `from`    | Prefix for input paths (accumulates through nesting). |
| `to`      | Prefix for output paths (accumulates through nesting). |
| `wh`      | Target size — `"24 24"` or `"24x24"`. A single number means a square. |
| `w`, `h`  | Target size one side at a time. Give only one and the other follows the source aspect ratio. |

A `<unit>`'s body is the input file and a `<dir>`'s is the input directory; the `to` attribute is
the output path in both cases, defaulting to the input path. Writing back over the input is
therefore what you get by leaving `from` and `to` alone — point them at different roots unless
editing the source in place is the intent.

A size that is not a plain number (`wh="24px"`, `wh="24  16"` with the extra space) is an error,
not a value to fall back from: the alternative is a typo quietly meaning "not set" and the build
going on to write a differently-sized image. A unit with no size at all on either side is the same
error, and so is a directory that does not exist. All of them end the build.

## Nearest neighbour, and only that

Every pixel of the output is one pixel of the input, sampled at the centre of the area it
covers. There is no filter and no option for one: this exists for art that is going to be
blown back up, where averaging neighbours means averaging the palette away, and the point of
shrinking was to make the pixels bigger rather than to make the picture smaller. Smooth
scaling is what `<texturepacker>`'s own `scale` already does — see
[texturepacker-scale.md](texturepacker-scale.md).

Sampling at pixel centres rather than corners is what keeps a thin feature near the far edge:
corner sampling never reaches the last source row and column, so the whole picture creeps up
and to the left by half a target pixel.

Pick the target size from the grid the game draws on, not from the ratio you have in mind. A
70px tile in a game whose pixel is 3 wants 24 and not 23 (`1/3` rounded), because 24 blows
back up to a whole 72 while 23 lands the art on a fractional grid and its pixels come out
uneven.

Only 32-bit PNG in, 32-bit PNG out.
