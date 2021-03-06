[![Lang](https://img.shields.io/badge/language-haxe-orange.svg?style=flat-square&colorB=EA8220)](http://haxe.org)
[![Haxelib](https://img.shields.io/badge/haxelib-1.4.7-blue.svg?style=flat-square&colorB=FBC707)](http://lib.haxe.org/p/pony)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Build status](https://img.shields.io/appveyor/ci/AxGord/pony.svg?label=windows&style=flat-square)](https://ci.appveyor.com/project/AxGord/pony) [![Join the chat at https://gitter.im/Ponylib/Lobby](https://img.shields.io/gitter/room/Ponylib/Lobby.svg?style=flat-square&colorB=71B79C)](https://gitter.im/Ponylib/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Donate PayPal](https://img.shields.io/badge/Donate-PayPal-green.svg?style=flat-square)](https://paypal.me/axgord)

<br/><br/>
<p align="center"><img width="65%" src="https://raw.githubusercontent.com/AxGord/Pony/haxe3/logo/pony_logo_hor.svg"/></p>
<br/>

Pony is a set of tools for developing, preparing, building, testing and publishing projects.
It can be used for creating Heaps, PixiJS, NodeJS, Electron, Cordova, PHP, OpenFL, Unity3D, Flash and Cocos Creator applications.

It works on servers or client-side.

The library has an XML-based UI building system and components, a powerful event system, and many utility functions.

Installation
============
Stable version

    haxelib install pony

Unstable version

    haxelib git pony https://github.com/AxGord/Pony

Install Pony Tools

    haxelib run pony

Silent install example

    haxelib run pony install +code -code-insiders +npm +userpath -nodepath +ponypath

`+` - enable option

`-` - disable option

`code` - Install Visual Studio Code recommended plugins

`code-insiders` - Install Visual Studio Code Insiders recommended plugins

`npm` - Install NPM (Node Package Manager) modules

`userpath` - Set user paths

`nodepath` - Set user path to node_modules, only for Windows

`ponypath` - Set user path to pony.exe, only for Windows

CI install example

    haxelib run pony install -code -code-insiders +npm +userpath

[Installation Video Guide](https://www.youtube.com/watch?v=ufYIEmQcv4o)


Manual
------
* [Home](https://github.com/AxGord/Pony/wiki)

* [Pony Tools](https://github.com/AxGord/Pony/wiki/Pony-Tools)

    * [Server section](https://github.com/AxGord/Pony/wiki/Server-section)
    * [Prepare sections](https://github.com/AxGord/Pony/wiki/Prepare-sections)
    * [Build sections](https://github.com/AxGord/Pony/wiki/Build-sections)
    * [Post build sections](https://github.com/AxGord/Pony/wiki/Post-build-sections)


Old Manual
------
- <a href="http://axgord.github.io/Pony/#signals">Signals</a>
- <a href="http://axgord.github.io/Pony/#deltatime">DeltaTime</a>
- <a href="http://axgord.github.io/Pony/#priority">Priority</a>
- <a href="http://axgord.github.io/Pony/#declarator">Declarator</a>

Reference book
--------------
[Explore more feature](http://axgord.github.io/Pony/docs)
