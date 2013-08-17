@echo off
haxelib run munit test -neko -as3 -js
rd build /S /Q
rd report /S /Q
pause