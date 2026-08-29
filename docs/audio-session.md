Audio session (js)
==================

`HeapsApp` starts `pony.heaps.AudioSessionKeeper` on js. It takes no configuration and there is
nothing to call — this page exists because one of its effects is visible to the player and has no
other explanation.

What it does
------------

**Asks for the `playback` audio session.** Measured on iOS 18.7 / Safari 18.7: of the five types
`navigator.audioSession` accepts, only `playback` produces audible WebAudio at all. `auto`,
`ambient`, `transient` and `transient-solo` are silent — a heaps game, which plays through WebAudio
and nothing else, is mute under every one of them. Why the other four are silent is not established.

**Keeps a looping silent `<audio>` element playing.** A long screen lock tears the playback session
down. Afterwards the `AudioContext` reports `running` while its clock is frozen and no output
reaches the speaker, and it stays that way past a page reload — a freshly constructed
`AudioContext` is dead too, so what died is the tab's session and not the document's. Nothing
revives it from inside the page: `resume()`, `suspend()` then `resume()`, a new context and
re-requesting the type were each tried and each failed. `<audio>` playback, meanwhile, survives the
same lock untouched, so keeping one alive is what stops the session from being taken away. The clip
is one second of silence built at runtime, so no project ships an asset for it.

**Freezes the context while the tab is hidden.** A hidden tab gets no `requestAnimationFrame`, so
heaps stops feeding its streaming driver and the sound starves into stutter — audible on the
desktop after a minute on another tab. Suspending the context stops that, and resuming continues
where it left off rather than replaying what went stale. The game itself needs no pausing: the
heaps main loop is driven by the same `requestAnimationFrame`, and `hxd.Timer.update` discards any
frame gap over `maxDeltaTime` (0.5 s), so the first frame back arrives with an ordinary `dt`.

What it costs
-------------

While the game is in the background, iOS shows it in Now Playing — on the lock screen and in
Control Center, with transport buttons. That entry is the price of the sound surviving a lock, and
it cannot be removed while keeping it: dropping the session to `ambient` while hidden makes the
entry disappear and the sound die with it, and clearing `mediaSession.metadata` and `playbackState`
leaves the entry standing. The entry is held by the playing element itself.

`HeapsApp` at least fills it in, from what the document already declares, so it reads as the game
rather than as a host name:

```html
<title>Stirrup Trouble</title>
<meta name="author" content="AxGord">
<link rel="icon" href="icon.png">
```

Title, artist and artwork come from those three. A page that declares none of them still works; it
just shows what Safari falls back to.

A game that would rather respect the ring/silent switch can set `navigator.audioSession.type` back
to `'ambient'` after startup — at the price of the silence described above.
