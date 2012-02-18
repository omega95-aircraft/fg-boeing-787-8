# CONSTANTS

var RAD2DEG = 57.2957795;
var DEG2RAD = 0.0174532925;
var htree = "/autopilot/hold/";

var hold = {
	init : func { 
        me.UPDATE_INTERVAL = 0.001; 
        me.loopid = 0; 
		setprop(htree ~"track-magnetic-deg", 0);
		setprop(htree ~"corrected-hold-time", 60);
		me.timer_started = 0;
		me.start_time = 0;
        me.reset(); 
}, 
	update : func {
	var hold_time = getprop(htree ~"hold-time");
	var hold_direction = getprop(htree ~"hold-direction");
	var hold_radial = getprop(htree ~"hold-radial");
	var hold_altitude = getprop(htree ~"altitude");
	var active = getprop(htree ~"active");
	var entry = getprop(htree ~"entry");
	var phase = getprop(htree ~"phase");
	var hdg = getprop("/orientation/heading-magnetic-deg");
	var fix = getprop(htree ~"fix");
	var brg = getprop("/instrumentation/gps[2]/scratch/mag-bearing-deg");
	var diff1 = hold_radial - brg;
	var diff2 = brg - hold_radial;
	var dist = getprop("/instrumentation/gps[2]/scratch/distance-nm");
	#var corrected_hold_time = getprop(htree ~"corrected-hold-time");
	
	setprop(htree ~"track-error-deg", getprop(htree ~"track-magnetic-deg") - hdg);
	setprop(htree ~"brg-error-deg", brg - hdg);
	
	var hdgdiff = hdg - hold_radial;
	
	if (hold_radial > 270)
		var holddiff2 = 360 - hold_radial;
	else
		var holddiff2 = hold_radial;
	if (hdg > 270)
		var hdgdiff3 = 360 - hdg;
	else
		var hdgdiff3 = hdg;
	if ((hdgdiff) < 0)
		hdgdiff = 360 - math.abs(hdgdiff);
	if (hold_radial < 90)
		var holddiff = 360 + hold_radial;
	else
		var holddiff = hold_radial;
	if (hdg < 90)
		var hdgdiff2 = 360 + hdg;
	else
		var hdgdiff2 = hdg;
	if (diff1 <= 0)
		diff1 = 360 - math.abs(diff1);
	if (diff2 <= 0)
		diff2 = 360 - math.abs(diff2);
	if (active == 0){
		phase = 0;
		setprop(htree ~"phase-enable", 0);
	}
	else{
		setprop("/autopilot/panel/master", 0);
		setprop("/autopilot/locks/altitude", "");
		setprop("/autopilot/locks/heading", "");
		if (phase == 1)
			setprop(htree ~"phase-enable", 1);
		elsif (phase == 2)
			setprop(htree ~"phase-enable", 2);
		elsif (phase == 3)
			setprop(htree ~"phase-enable", 2);
		elsif (phase == 4)
			setprop(htree ~"phase-enable", 2);
	}
	if (fix != ""){
		if (phase == 0){
			if ((diff1 <= 110) or (diff2 <= 70)){
				entry = 0;
				}
			elsif ((diff1 > 110) and (diff2 <= 180)){
				entry = 2;
				phase = 5;
				}
			else{
				entry = 1;
				phase = 5;
				}
			setprop(htree ~"entry", entry);
			if (entry == 0)
				phase = 1;
		}
		elsif (phase == 5){
			if (entry == 1){
				
			}
			if (entry == 2){
				if (me.timer_started == 0){
					me.timer_started = 1;
					me.start_time = getprop("/sim/time/elapsed-sec");
				}
				else{
					if ((getprop("/sim/time/elapsed-sec") - me.start_time) >= hold_time){
						phase = 4;
						me.time_started = 0;
					}
				}
			}
			else{
				phase = 1;
			}
		}
		elsif ((phase == 1) and (dist <= 0.3))
			phase = 2;
		elsif (phase == 2){
			if (hdgdiff3 < holddiff2 + 90)
				setprop(htree ~"track-magnetic-deg", holddiff2 + 90);
			else
				phase = 3;
		}
		elsif (phase == 3){
			if (me.timer_started == 0){
					me.timer_started = 1;
					me.start_time = getprop("/sim/time/elapsed-sec");
				}
				else{
					if ((getprop("/sim/time/elapsed-sec") - me.start_time) >= hold_time){
						phase = 4;
						me.time_started = 0;
					}
				}
		}
		elsif (phase == 4){
			if (hdgdiff2 < holddiff - 90)
				setprop(htree ~"track-magnetic-deg", holddiff - 90);
			else
				phase = 1;
		}
	}
},
    reset : func {
        me.loopid += 1;
        me._loop_(me.loopid);
    },
    _loop_ : func(id) {
        id == me.loopid or return;
        me.update();
        settimer(func { me._loop_(id); }, me.UPDATE_INTERVAL);
    }

};

setlistener("sim/signals/fdm-initialized", func
 {
 hold.init();
 });


