Input in an iframe (js)
=======================

`HeapsApp` builds the heaps window as `new Window(canvas, true)` — `globalEvents = true` — so every
mouse, touch, key and focus listener heaps registers goes on `js.Browser.window`, and nothing on the
canvas. On a page of its own that is invisible: the window already holds the focus and owns the
gesture. Served inside an iframe — which is how itch.io and most portals serve a build — the page
around holds the focus instead, and the game hears nothing until it is taken. This page is what
`HeapsApp.takeFocusFromPage` does and why; the touch half of the same problem is
`suppressTouchDefaults`, documented at the method.

Taking the focus back
---------------------

**A click in the game cannot hand it over by itself.** The default action of `mousedown` IS the
focus transfer, and heaps' own canvas handler calls `preventDefault()` on it. So `pointerdown` on
the window takes it explicitly.

**The portal's fullscreen button is a click in the PAGE, which the frame never sees.** The element
put into fullscreen belongs to the page's document, so no `fullscreenchange` arrives in the frame
and `document.fullscreenElement` stays null there. Measured in a cross-origin frame, the only trace
of it inside is the `resize`:

```
load     hasFocus=false fsEl=no size=0x0
pageshow hasFocus=false fsEl=no size=640x360
resize   hasFocus=false fsEl=no size=1280x720   <- the whole signal
```

That is why the second listener waits for `resize`. Without it the keyboard is dead in fullscreen
until the player clicks, which reads as the game being broken BY fullscreen rather than as a focus
problem. The listener is registered only when `window != window.top`: a page of its own already
holds the focus, and a resize there is the user working in another window.

**A frame may focus ITSELF with no user activation of its own.** Measured cross-origin:
`hasFocus` false -> `window.focus()` -> true, and the next key arrived. Nothing gates this, so the
recovery needs no gesture of its own — which is the whole reason it can run from a resize.

Why NOT at load
---------------

Taking the focus as soon as the game boots would make the keyboard work with no click at all. It is
deliberately not done, because on a portal the game sits in a page the player also reads and
scrolls, and the frame holding the focus costs that page its keyboard scrolling. Measured on the
same page, game below the fold:

| | host page scrolls on PageDown | game gets keys |
|---|---|---|
| focus left alone | yes, 0 -> 680 | no, until a click |
| focus taken at load | no, 0 -> 0 | yes |

The page keeps scrolling only while the focus is outside the frame — an unfocused frame lets the key
through to the page, a focused one consumes it. Both existing triggers carry an intent signal the
load does not: a click in the game is "I am playing", a fullscreen transition is "only the game on
screen". A load carries none, and the frame cannot see one either — a click on the portal's own
"Run game" button lands in the portal's document, and user activation does not propagate down into
the frame, so it is indistinguishable from an embed that autoloaded.
