@echo off
haxe -main TestMain -cp ../tests/test -xml x.xml -cp .. -lib munit -neko n.n
chxdoc x.xml --includeOnly=pony.* --ignoreRoot=true --showAuthorTags=true --title=Pony --subtitle="Haxe Cross-Library" --template="docTemplate"
del n.n x.xml /Q
rd __chxdoctmp /S /Q
pause