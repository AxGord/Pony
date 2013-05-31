package pony.flash;

import flash.display.Stage;
import flash.events.Event;
import flash.events.TouchEvent;
import flash.geom.Point;
import flash.Lib;
import flash.events.MouseEvent;
import flash.display.InteractiveObject;
import pony.events.Signal;

using pony.flash.FLExtends;

/**
 * ...
 * @author AxGord
 */
class CPP_FL_TouchFix {

	public static var stage:Stage;
	public static var useFix:Bool = false;
	
	public static var move:Signal = new Signal();
	public static var down:Signal = new Signal();
	public static var up:Signal = new Signal();
	
	//signals
	private static var _move:Signal;
	private static var _up:Signal;
	
	public static function init():Void {
		stage = Lib.current.stage;
		_move = stage.buildSignal(MouseEvent.MOUSE_MOVE);
		_move.once(fMoveHandler);
		_up = stage.buildSignal(MouseEvent.MOUSE_UP);
		useFix = true;
	}
	
	private static function fMoveHandler(event:MouseEvent):Void {
		_up.once(fUpHandler);
		_move.add(moveHandler);
		down.dispatch(event.target);
	}
	
	private static function fUpHandler(event:MouseEvent):Void {
		_move.remove(moveHandler);
		_move.once(fMoveHandler);
		up.dispatch(event.target);
	}
	
	private static function moveHandler(event:MouseEvent):Void {
		move.dispatch(event.target);
	}
	
	
	private static var downSignals:Map<InteractiveObject, Signal> = new Map<InteractiveObject, Signal>();
	public static inline function downSignal(o:InteractiveObject):Signal {
		if (!downSignals.exists(o)) downSignals.set(o, CPP_FL_TouchFix.down.sub([o]));
		return downSignals.get(o);
	}
	
	
	private static var upSignals:Map<InteractiveObject, Signal> = new Map<InteractiveObject, Signal>();
	public static inline function upSignal(o:InteractiveObject):Signal {
		if (!upSignals.exists(o)) upSignals.set(o, CPP_FL_TouchFix.up.sub([o]));
		return upSignals.get(o);
	}
	
	
	private static var moveSignals:Map<InteractiveObject, Signal> = new Map<InteractiveObject, Signal>();
	public static inline function moveSignal(o:InteractiveObject):Signal {
		if (!moveSignals.exists(o)) moveSignals.set(o, CPP_FL_TouchFix.move.sub([o]));
		return moveSignals.get(o);
	}
	
}