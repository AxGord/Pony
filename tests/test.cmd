@echo off
haxelib run munit test -neko
rd build /S /Q
rd report /S /Q