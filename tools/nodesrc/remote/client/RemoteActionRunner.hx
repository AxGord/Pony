/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package remote.client;

import pony.Logable;
import types.RemoteConfig;
import remote.client.actions.RemoteAction;
import remote.client.actions.RemoteActionGet;
import remote.client.actions.RemoteActionSend;
import remote.client.actions.RemoteActionExec;
import remote.client.actions.RemoteActionCommand;

class RemoteActionRunner extends Logable {

	public var onEnd:Void -> Void;
	private var protocol:RemoteProtocol;
	private var commands:Array<RemoteCommand>;

	public function new(protocol:RemoteProtocol, commands:Array<RemoteCommand>) {
		super();
		this.protocol = protocol;
		this.commands = commands;
	}

	public function run():Void runNext();

	private function runNext():Void {
		if (commands.length > 0) {
			switch commands.shift() {
				case Get(file): listen(new RemoteActionGet(protocol, file));
				case Send(file): listen(new RemoteActionSend(protocol, file));
				case Exec(command): listen(new RemoteActionExec(protocol, command));
				case Command(command): listen(new RemoteActionCommand(protocol, command));
			}
		} else {
			onEnd();
		}
	}

	private function listen(action:RemoteAction):Void {
		action.onLog << log;
		action.onError << error;
		action.onEnd = runNext;
	}

}