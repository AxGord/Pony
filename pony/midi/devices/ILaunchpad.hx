/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.midi.devices;

import pony.events.Signal2;
import pony.geom.Point.IntPoint;
import pony.ILogable;
import pony.math.Matrix;
import pony.midi.devices.LaunchpadColor;

/**
 * @author AxGord
 */

interface ILaunchpad extends ILogable<ILaunchpad> {
  
	var areaState(default, null):Matrix<LaunchpadColor>;
	var topState(default, null):Array<LaunchpadColor>;
	var rightState(default, null):Array<LaunchpadColor>;
	
	var onArea(default, null):Signal2<ILaunchpad, IntPoint, Bool>;
	var onTop(default, null):Signal2<ILaunchpad, Int, Bool>;
	var onRight(default, null):Signal2<ILaunchpad, Int, Bool>;
	
	function setAreaPoint(p:IntPoint, color:LaunchpadColor = AmberFull):Void;
	function setMatrixCI(m:Matrix<Int>):Void;
	function setMatrix(m:Matrix<LaunchpadColor>):Void;
	function setTop(p:Int, color:LaunchpadColor = AmberFull):Void;
	function setRight(p:Int, color:LaunchpadColor = AmberFull):Void;
	function reset():Void;
}