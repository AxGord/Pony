package pony.ui.gui;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.ui.touch.Touchable;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.SliderCore;

/**
 * ScrollBoxBarCore
 * @author AxGord <axgord@gmail.com>
 */
class ScrollBoxBarCore implements HasSignal {

    @:auto public var onHide:Signal0;
    @:auto public var onPos:Signal2<Float, Float>;
    @:auto public var onSize:Signal2<Float, Float>;
    @:auto public var onContentPos:Signal1<Float>;
    @:auto public var onMaskSize:Signal1<Float>;

    public var c(default, null):Float;
    private var slider:SliderCore;
    private var scrollPanelSize:Float;
    private var totalA:Float;
    private var totalB:Float;
    private var scrollerSize:Float;

    public function new(t:ButtonCore, scrollPanelSize:Float, totalA:Float, totalB:Float, vert:Bool, wheelSpeed:Float) {
        slider = new SliderCore(t, 0, vert);
        slider.wheelSpeed = wheelSpeed;
        this.scrollPanelSize = scrollPanelSize;
        this.totalA = totalA;
        this.totalB = totalB;
        if (vert) {
            slider.changeY = posHandler;
        } else {
            slider.changeX = posHandler;
        }
        slider.changePercent << percentHandler;
    }

    public function content(c:Float):Void {
        this.c = c;
        if (c <= totalA) {
            eHide.dispatch();
            eContentPos.dispatch(0);
            eMaskSize.dispatch(totalB);
        } else {
            scrollerSize = totalA * totalA / c;
            slider.pos = 0;
            slider.setSize(totalA - scrollerSize);
            ePos.dispatch(0, totalB - scrollPanelSize);
            eContentPos.dispatch(0);
            eSize.dispatch(scrollerSize, scrollPanelSize);
            eMaskSize.dispatch(totalB - scrollPanelSize);
        }
    }

    private function posHandler(pos:Float):Void {
        ePos.dispatch(pos, totalB - scrollPanelSize);
    }

    private function percentHandler(p:Float):Void {
        eContentPos.dispatch(-(c - totalA) * p);
    }

    public function wheelHandler(delta:Int):Void {
        slider.wheel(delta);
    }

}