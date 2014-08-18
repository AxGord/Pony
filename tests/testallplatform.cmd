@echo off
haxelib run munit test
rd build /S /Q
rd report /S /Q
pause