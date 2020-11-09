package module.server;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import pony.net.SocketClient;
import pony.net.SocketServer;
import pony.Logable;
import types.SniffConfig;

/**
 * Sniff submodule
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Sniff extends Logable {

    private var cfg: SniffConfig;
    private var server: SocketServer;

	public function new(cfg: SniffConfig) {
        super();
        this.cfg = cfg;
        server = new SocketServer(cfg.serverPort, false);
        listenErrorAndLog(server);
        server.onConnect << socketServerConnectHandler;
    }

	public function init(): Void log('Sniff: ' + Std.string(cfg));

    private function socketServerConnectHandler(a: SocketClient): Void {
        log('Connect to sniff');
        var b: SocketClient = new SocketClient(cfg.clientHost, cfg.clientPort, -1, 0, false);
        listenErrorAndLog(b);
        a.onData << function(bi: BytesInput): Void {
            var bo: BytesOutput = new BytesOutput();
            log('Send to server, length: ' + bi.length);
            bo.write(bi.readAll());
            b.send(bo);
        }
        b.onData << function(bi: BytesInput): Void {
            var bo: BytesOutput = new BytesOutput();
            log('Send to client, length: ' + bi.length);
            bo.write(bi.readAll());
            a.send(bo);
        }
        a.onDisconnect < function(): Void {
            log('Client disconnect');
            b.destroy();
        }
        b.onDisconnect < function(): Void {
            log('Server disconnect');
            a.destroy();
        }
    }

}