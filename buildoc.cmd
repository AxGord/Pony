haxe -cs cs --no-output -xml api/unity.xml --macro include('pony',false,['pony.Timer']) --macro include('pony.unity3d',true) --macro include('pony.net',false,['pony.net.Protobuf']) -lib HUGS -lib traits -D dox
haxe -cs cs  api/cs.xml --macro include('pony',false,['pony.Timer']) --macro include('pony.net',false,['pony.net.Protobuf']) -lib HUGS -lib traits -D dox
haxe -swf fl.swf --no-output -xml api/flash.xml --macro include('pony.flash',true) --macro include('pony.net',true,['pony.net.Protobuf']) --macro include('pony',false) -lib mconsole -lib traits -swf-version 11.8
haxe -neko n.n --no-output -xml api/neko.xml -cp tests/test -main TestMain -lib mconsole -lib traits -lib munit --macro include('pony',false) --macro include('pony.macro',true) -D dox
haxe -js --no-output -xml api/nodejs.xml --macro include('pony',false,['pony.Timer']) -lib traits  --macro include('pony.net',false,['pony.net.Protobuf']) -D dox -lib nodejs
neko RemStar.n api
haxelib run dox -r /Pony/docs/ -o "C:\data\WeSer\www\Pony\docs" -i api --title Pony -in pony.*