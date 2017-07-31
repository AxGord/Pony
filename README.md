[![Lang](https://img.shields.io/badge/language-haxe-orange.svg)](http://haxe.org)
[![License](https://img.shields.io/badge/license-BSD-blue.svg)](LICENSE.txt)
[![Haxelib](https://img.shields.io/badge/haxelib-0.4.5-blue.svg)](http://lib.haxe.org/p/pony)
[![Build status](https://ci.appveyor.com/api/projects/status/83l5njueb4k0ns60?svg=true)](https://ci.appveyor.com/project/AxGord/pony)

<p align="center"><img width="65%" src="http://qlex.ru/pony_logo_hor.svg?v=1"/></p>

Installation
============
Stable version

    haxelib install pony

Unstable version

    haxelib git pony https://github.com/AxGord/Pony

Pony Tools
============
Supported OS: Windows and Mac OS

Installation

    haxelib run pony

Create project file

    cd PROJECT_PATH
    pony create PROJECT_NAME

Then open pony.xml in editor

Prepare sections
------------------
```xml
<haxelib>
    <lib>LIBRARY_NAME</lib>
</haxelib>

<download path="DOWNLOADS_PATH/">
    <unit url="DOWNLOAD_URL" />
    <unit
        url="DOWNLOAD_URL_PART{v}DOWNLOAD_URL_PART"
        v="VERSION" check="STABLE_FILE_DATA{v}STABLE_FILE_DATA" />
    <!-- Pixi example: -->
    <unit
        url="https://pixijs.download/v{v}/pixi.min.js"
        check="pixi.js - v{v}" v="4.5.3" />
</download>

<poeditor>
    <token>TOKEN</token>
    <id>ID</id>
    <path>PATH_TO_JSON_FILES</path>
    <list>
        <FILE_NAME>LANG_ID</FILE_NAME/>
    </list>
</poeditor>
```
Prepare run command:

    pony prepare

Build sections
------------------
```xml
<build>
    <ANY_HAXE_OPTION>VALUE</ANY_HAXE_OPTION>
    <d name="FLAG_NAME">FLAG_VALUE</d>
    <apps>
        <BUILD_NAME>
            <ANY_HAXE_OPTION>VALUE</ANY_HAXE_OPTION>
        </BUILD_NAME>
        <BUILD_NAME>
            <ANY_HAXE_OPTION>VALUE</ANY_HAXE_OPTION>
        </BUILD_NAME>
    </apps>
    <release>
        <ANY_HAXE_OPTION>VALUE</ANY_HAXE_OPTION>
    </release>
    <debug>
        <ANY_HAXE_OPTION>VALUE</ANY_HAXE_OPTION>
    </debug>
</build>

<uglify>
    <release><c/><m/></release>
    <debug>
        <input>jslib/stacktrace.min.js</input>
        <sourcemap>
            <input>HAXE_OUTPUT_PATH/HAXE_OUTPUT_FILE.js.map</input>
            <output>OUTPUT_PATH/OUTPUT_FILE.js.map</output>
            <url>OUTPUT_FILE.js.map</url>
            <source>OUTPUT_FILE.js</source>
        </sourcemap>
    </debug>
    <input>ANY_JS_LIBRARY</input>
    <input>HAXE_OUTPUT_PATH/HAXE_OUTPUT_FILE.js</input>
    <output>OUTPUT_PATH/OUTPUT_FILE.js</output>
    <apps><!-- See build section --></apps>
</uglify>

<wrapper>
    <file>FILE</file>
    <pre>FILE_CONTENT_PREFIX</pre>
    <post>FILE_COUNTENT_POSTFIX</pre>
</wrapper>
```
Build commands:

    pony build
    pony build PROJECT_NAME
    pony build debug
    pony build PROJECT_NAME debug
    pony build PROJECT_NAME release

Post build sections
------------------
```xml
<zip>
    <compress>COMPRESS_LEVEL_1_9</compress>
    <prefix>PREFIX_TO_COMPRESS_FOLDER</prefix>
    <input>ANY_FILE</input>
    <input>ANY_FOLDER/</input>
    <output>ARCHIVE_FILE_NAME.zip</output>
    <apps><!-- See build section --></apps>
    <debug><!-- ... --></debug>
    <release><!-- ... --></release>
</zip>
```
Zip commands:

    pony zip
    pony zip PROJECT_NAME
    pony zip debug
    pony zip PROJECT_NAME debug
    pony zip PROJECT_NAME release

```xml
<ftp path="PATH_FOR_UPLOADS/">
    <host>HOST</host>
    <user>USERNAME</user>
    <pass>PASSWORD</pass>
    <output>SERVER_FOLDER</output>
    <input>FILE_FOR_UPLOAD</input>
    <input>FOLDER_FOR_UPLOAD</input>
    <apps><!-- See build section --></apps>
    <debug><!-- ... --></debug>
    <release><!-- ... --></release>
</ftp>
```
Ftp commands:

    pony ftp
    pony ftp PROJECT_NAME
    pony ftp debug
    pony ftp PROJECT_NAME debug
    pony ftp PROJECT_NAME release

Pony good with
==============
* [HUGS (Haxe Unity Glue...Stuff!)](https://github.com/proletariatgames/HUGS)
* [Pixi.js](https://github.com/pixijs/pixi-haxe)
* [Node.js](https://github.com/dionjwa/nodejs-std)
* [Lime or OpenFL](https://github.com/openfl/openfl)
* [Adobe Animate CC (Flash Professional)](http://www.adobe.com/products/animate.html)
* [FlashDevelop Haxe Upgrade Pack](https://github.com/AxGord/FD-Haxe-Up)
* [Base files for PonyNode site engine](https://github.com/AxGord/PonyNode)
* [haxe-continuation](https://github.com/Atry/haxe-continuation)

Sometimes need npm
------------------
* [node-midi](https://github.com/justinlatimer/node-midi)
* [node-mysql](https://github.com/felixge/node-mysql)
* [send](https://github.com/pillarjs/send)
* [NodeJS Library for Facebook](https://github.com/node-facebook/facebook-node-sdk)
* [SPDY Server for node.js](https://github.com/indutny/node-spdy)

Manual
------
- <a href="http://axgord.github.io/Pony/#signals">Signals</a>
- <a href="http://axgord.github.io/Pony/#deltatime">DeltaTime</a>
- <a href="http://axgord.github.io/Pony/#priority">Priority</a>
- <a href="http://axgord.github.io/Pony/#declarator">Declarator</a>

Reference book
--------------
[Explore more feature](http://axgord.github.io/Pony/docs)
