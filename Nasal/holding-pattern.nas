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
	var gs = getprop("/velocities/groundspeed-kt");
	var leg_distance = gs * (hold_time / 3600)
	var turn_diameter = gs * (60 / 3600 * math.pi)
	var right1 = 45 + hold_radial;
	var right2 = 90 + hold_radial;
	var right3 = 180 + hold_radial;
	if ((fix != "") and (active == 1)){
		if (right1 > 360)
			right1 = right1 - 360;
		if (right2 > 360)
			right2 = right2 - 360;
		if (right3 > 360)
			right3 = right3 - 360;
		var x = getprop("/instrumentation/gps[2]/scratch/longitude-deg");
		var y = getprop("/instrumentation/gps[2]/scratch/latitude-deg");
		var x1 = x + turn_diameter * math.sqrt(2) * math.sin(right1);
		var y1 = y + turn_diameter * math.sqrt(2) * math.cos(right1);
		var x2 = x + turn_diameter * math.sin(right2);
		var y2 = y + turn_diameter * math.cos(right2);
		var x3 = x2 + leg_distance * math.sin(right3);
		var y3 = y2 + leg_distance * math.cos(right3);
		var x4 = x1 + turn_diameter * math.sin(right3);
		var y4 = y1 + turn_diameter * math.cos(right3);
		var x5 = x + leg_distance * math.sin(right3);
		var y5 = y + leg_distance * math.cos(right3);

		if (diff1 <= 0)
			diff1 = 360 - math.abs(diff1);
		if (diff2 <= 0)
			diff2 = 360 - math.abs(diff2);
		if (active == 0){
			phase = 0;

		# Disable Autopilot Controls while auto-holding

		setprop("/autopilot/panel/master", 0);
		setprop("/autopilot/locks/altitude", "");
		setprop("/autopilot/locks/heading", "");

		if (phase == 0) {
			if ((diff1 <= 110) or (diff2 <= 70)) {
				entry = 0; ## Direct Entry
				setprop(htree ~ "phase", 1);
				}
			elsif ((diff1 > 110) and (diff2 <= 180)) {
				entry = 2; ## Teardrop Entry
				setprop(htree ~ "phase", 7);
				}
			else{
				entry = 1; ## Parallel Entry
				setprop(htree ~ "phase", 7);	
				}
			setprop(htree ~"entry", entry);
		}
		elsif (phase == 7) { ## Fly Entry Phase
			
			if (entry == 1) { ## Parallel Entry

######################## COME BACK LATER ########################

			} else { ## Teardrop (entry 2)

				if (flyto(y, x) == 1)
					setprop(htree ~"phase", 4);

			}

		}

# HOLD POINTS LAYOUT ###########
#       5           FIX        #
#    4                  1      #
#       3            2         #
################################

		elsif (phase == 1) { ## Fly to Fix
			if (flyto(y,x) == 1)
				setprop(htree ~"phase", 2);
		}
		elsif (phase == 2) { ## Fly to point 1
			if (flyto(y1,x1) == 1)
				setprop(htree ~"phase", 3);
		}
		elsif (phase == 3) { ## Fly to point 2
			if (flyto(y2,x2) == 1)
				setprop(htree ~"phase", 4);
		}
		elsif (phase == 4) { ## Fly to point 3
			if (flyto(y3,x3) == 1)
				setprop(htree ~"phase", 5);
		}
		elsif (phase == 5) { ## Fly to point 4
			if (flyto(y4,x4) == 1)
				setprop(htree ~"phase", 6);
		}
		elsif (phase == 6) { ## Fly to point 5
			if (flyto(y5,x5) == 1)
				setprop(htree ~"phase", 1);
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
var flyto = func(target_lat, target_lon)
{

 var pos_lat = getprop("/position/latitude-deg");
 var pos_lon = getprop("/position/longitude-deg");
 
 # Calculate Required Track for leg

 var track_deg = 57.2957795 * math.atan2(target_lat - pos_lat, target_lon - pos_lon);

 setprop("/autopilot/auto-hold/track-deg", track_deg);
 setprop("/autopilot/auto-hold/enable-track", 1);

 # Check if Target is Reached

 if ((pos_lat <= target_lat + 0.005) and (pos_lat >= target_lat - 0.005) and (pos_lon <= target_lon + 0.005) and (pos_lon >= target_lon - 0.005)) {
  return 1; # Return 1 if reached
  setprop("/autopilot/auto-hold/enable-track", 0);
 } else {
  return 0; # Return 0 is not reached
 }

}
setlistener("sim/signals/fdm-initialized", func
 {
 hold.init();
 });


