# How a layout measures a text

A layout asks every child for a box and then places the boxes. For everything that implements
`IWH` — a node, an image, another layout — that box is a declared size and never moves. A
`h2d.Text` is not `IWH`, so the box used to come from `getBounds()`, which is the **ink** of the
string the text holds at that moment: the union of the glyph tiles actually drawn.

That is the wrong box in two ways, and both of them show up as "the layout looks slightly off"
rather than as anything obviously broken.

## Vertically: the ink is not the line

`getBounds()` measures from the text's origin down to the lowest glyph, so a line of capitals
reports a box that ends at the baseline and still includes the ascender gap above the caps. Centre
that box in a button and the caps land **`dy / 2` below** the middle, where `dy` is the top bearing
of the tallest glyph — 3.5 px for a 28 px default font, and a different amount for every font size
on the screen. Nothing about the label is wrong; it is just never quite centred, and no attribute
in the XML explains why.

The line box is what a text is laid out on: `textHeight` is `font.lineHeight` for a single line,
measured from the object's own `y`, and it does not depend on which glyphs are in the string. A
label centred on it sits on its baseline, which is where a reader expects it.

## Horizontally: a column cannot be as wide as its content

`maxWidth` + `align` is the one alignment heaps re-applies by itself whenever `text` is assigned —
which makes it the only alignment that survives a table being filled in from code, since a layout
runs its pass once at `createUI` and does not re-run when a child's content changes
(`layout.update()` is the manual way).

But the box `getBounds()` reported was the ink, not `maxWidth`. So a column of texts inside an
`ih` layout was sized by whatever happened to be in it when the pass ran — for a table built
empty, zero — and every column collapsed onto the same `x`. The only thing that worked was
absolute `x`/`y` inside a plain `<node>`, one hardcoded pair per cell.

## The rule

`GUIUtils.textSize` is the single answer both paths use — `BaseLayout._getSize` for a plain
`h2d.Text`, and `DText` / `ExtendedTextInput` for their own `IWH` size:

```haxe
public static inline function textSize(t: Text): Point<Float>
	return new Point<Float>(t.maxWidth ?? t.textWidth, t.textHeight);
```

**A text's layout box is the `maxWidth` it was given, or the current string's width when it has
none, by the line box — never by the ink.** Give a data-driven text a `maxWidth` and it owns that
much room whatever is put in it later, so a table is columns of `maxWidth` boxes and nothing else:

```xml
<layout>
	<Panel w="500" h="191"/>
	<layout iv="7">
		<layout ih="16">
			<Row id="row0rank" maxWidth="40" align="left"/>
			<Row id="row0name" maxWidth="300" align="left"/>
			<Row id="row0coins" maxWidth="80" align="right"/>
		</layout>
		<!-- … -->
	</layout>
</layout>
```

The rows layout measures itself from the column widths, the `AlignLayout` around it centres it
over the panel, and the padding is equal on both sides because nothing named it.

A text with no `maxWidth` is still measured by its content, so a label whose text changes at
runtime moves its neighbours' idea of where it ends — give it a `maxWidth` too, or re-run the
layout.
