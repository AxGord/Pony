package pony.ui.gui;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.ui.touch.Touchable;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.SliderCore;

/**
 * ScrollBoxCore
 * @author AxGord <axgord@gmail.com>
 */
class ScrollBoxCore implements HasSignal {

    @:auto public var onScrollVertPos:Signal2<Float, Float>;
    @:auto public var onScrollVertSize:Signal2<Float, Float>;
    @:auto public var onHideScrollVert:Signal0;
    @:auto public var onScrollHorPos:Signal2<Float, Float>;
    @:auto public var onScrollHorSize:Signal2<Float, Float>;
    @:auto public var onHideScrollHor:Signal0;
    @:auto public var onContentPos:Signal2<Float, Float>;
    @:auto public var onMaskSize:Signal2<Float, Float>;

    public var w(default, null):Float;
    public var h(default, null):Float;
    public var vert(default, null):Bool;
    public var hor(default, null):Bool;

    private var tArea:Touchable;
    private var barVert:ScrollBoxBarCore;
    private var barHor:ScrollBoxBarCore;

    private var cx:Float = 0;
    private var cy:Float = 0;
    private var mw:Float;
    private var mh:Float;

    public function new(w:Float, h:Float, ?tArea:Touchable, ?tScrollerVert:ButtonCore, ?tScrollerHor:ButtonCore, scrollSize:Float = 10, wheelSpeed:Float = 1) {
        this.w = w;
        this.h = h;
        mw = w;
        mh = h;
        this.tArea = tArea;
        if (tScrollerVert != null) {
            barVert = new ScrollBoxBarCore(tScrollerVert, scrollSize, h, w, true, wheelSpeed);
            barVert.onHide << eHideScrollVert;
            barVert.onPos << function(a:Float, b:Float):Void eScrollVertPos.dispatch(b, a);
            barVert.onSize << function(a:Float, b:Float):Void eScrollVertSize.dispatch(b, a);
            barVert.onContentPos << vertContentHandler;
            barVert.onMaskSize << vertMaskSizeHandler;
            if (tArea != null) {
                tArea.onWheel << barVert.wheelHandler;
            }
        }
        if (tScrollerHor != null) {
            barHor = new ScrollBoxBarCore(tScrollerHor, scrollSize, w, h, false, wheelSpeed);
            barHor.onHide << eHideScrollHor;
            barHor.onPos << eScrollHorPos;
            barHor.onSize << eScrollHorSize;
            barHor.onContentPos << horContentHandler;
            barHor.onMaskSize << horMaskSizeHandler;
        }
    }

    private function vertMaskSizeHandler(v:Float):Void {
        mw = v;
        updateMaskSize();
    }

    private function horMaskSizeHandler(v:Float):Void {
        mh = v;
        updateMaskSize();
    }

    @:extern private inline function updateMaskSize():Void {
        eMaskSize.dispatch(mw, mh);
    }

    public function content(cw:Float, ch:Float):Void {
        if (barVert != null)
            barVert.content(ch);
        if (barHor != null)
            barHor.content(cw);
    }

    private function vertContentHandler(p:Float):Void {
        cy = p;
        updateContentPos();
    }

    private function horContentHandler(p:Float):Void {
        cx = p;
        updateContentPos();
    }


    @:extern private inline function updateContentPos():Void {
        eContentPos.dispatch(cx, cy);
    }

}