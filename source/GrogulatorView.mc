import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time.Gregorian;

class GrogulatorView extends WatchUi.WatchFace {

    private var grogu as BitmapResource?;
    private var knob as BitmapResource?;
    private var font as FontResource?;
    //private var smallfont as FontResource?;

    const knobWidth = 32;
    const knobHeight = 31;

    function initialize() {
        WatchFace.initialize();
   }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        grogu = Application.loadResource( Rez.Drawables.bitmap_id ) as BitmapResource;
        font = Application.loadResource( Rez.Fonts.font_id ) as FontResource;
        //smallfont = Application.loadResource( Rez.Fonts.smallfont_id ) as FontResource;
        knob = Application.loadResource( Rez.Drawables.knob_id ) as BitmapResource;

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    function drawDisplay(dc as Dc, x as Float, y as Float) as Void {
        // Draw background and Grogu bitmap
        //dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        //dc.clear();

        // Display time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var DDD = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$", [DDD.month, DDD.day.format("%02d")]);

        var z = View.findDrawableById("TimeLabel");
        (z as Text).setText(timeString);
        var z2 = View.findDrawableById("DateLabel");
        (z2 as Text).setText(dateString);

        View.onUpdate(dc);

        dc.drawBitmap(120, 120, grogu);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Display battery
        var batteryLevel = System.getSystemStats().battery;

        var stepsX = 24;
        var stepsY = 139;
        var hrX = 48;
        var hrY = 171;

        var meterX = 77;
        var meterY = 34;

        // Display steps
        var cadenceString = Lang.format("steps $1$", [ActivityMonitor.getInfo().steps]);
        // cadenceString = "steps 10905";
        dc.drawText(stepsX, stepsY, Graphics.FONT_TINY, cadenceString,
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        // Display heart rate
        var heartRateString = Lang.format("hr $1$", [Activity.getActivityInfo().currentHeartRate]);
        // heartRateString = "hr 143";
        dc.drawText(hrX, hrY, Graphics.FONT_TINY, heartRateString,
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        var meterWidth = 40;
        var meterHeight = 12;
        var lowLevel = 20;

        // the bar itself
        if (batteryLevel < lowLevel)
        {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        }
        else
        {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        }
        dc.fillRectangle(meterX, meterY,
                            0.01 * meterWidth * batteryLevel, meterHeight); 

        var batteryString = Lang.format("$1$%", [batteryLevel.format("%.0f")]);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(meterX + meterWidth + 4, meterY + 0.5 * meterHeight,
                    Graphics.FONT_SYSTEM_XTINY, batteryString,
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        // Horizontal lines
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.drawLine(meterX, meterY, meterX + meterWidth, meterY);
        dc.drawLine(meterX + meterWidth, meterY, meterX + meterWidth, meterY + meterHeight);
        dc.drawLine(meterX + meterWidth, meterY + meterHeight, meterX, meterY + meterHeight);
        dc.drawLine(meterX, meterY + meterHeight, meterX, meterY);

        // Knob
        dc.drawBitmap(x, y, knob);

    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var clockTime = System.getClockTime();
        var angle = clockTime.sec*2*Math.PI/60;

        var x = 104 + 85*Math.sin(angle) - knobWidth/2;
        var y = 104 - 85*Math.cos(angle) - knobHeight/2;
        drawDisplay(dc, x, y);
    }

    function onPartialUpdate(dc as Dc) as Void {
        var clockTime = System.getClockTime();
        var angle = clockTime.sec*2*Math.PI/60;

        var x = 104 + 85*Math.sin(angle) - knobWidth/2;
        var y = 104 - 85*Math.cos(angle) - knobHeight/2;

        dc.setClip(x - knobWidth / 2, y - knobHeight / 2,
                   2 * knobWidth, 2 * knobHeight);
        drawDisplay(dc, x, y);
        dc.clearClip();
    }    

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
