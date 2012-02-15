var mcp = {
	init : func { 
        me.UPDATE_INTERVAL = 0.01; 
        me.loopid = 0; 

# Initialize Panel Settings

setprop("/autopilot/panel/auto-throttle", 0);
setprop("/autopilot/panel/master", 0);
setprop("/autopilot/panel/speed-mode", "ias");
setprop("/autopilot/panel/larm", 1);
setprop("/autopilot/panel/rarm", 1);
setprop("/autopilot/panel/hdg", "hdg");
setprop("/autopilot/panel/alt", "alt");
setprop("/autopilot/settings/vertical-speed-fpm", 0);

        me.reset(); 
}, 
	update : func {

# Connect L and R arms to AP throttle props

if ((getprop("/autopilot/panel/larm") == 1) and (getprop("/autopilot/locks/speed") == "speed-with-throttle")) setprop("/autopilot/speed/lthrottle", "ias");
elsif ((getprop("/autopilot/panel/larm") == 1) and (getprop("/autopilot/locks/speed") == "mach")) setprop("/autopilot/speed/lthrottle", "mach");
else setprop("/autopilot/speed/lthrottle", "");

if ((getprop("/autopilot/panel/rarm") == 1) and (getprop("/autopilot/locks/speed") == "speed-with-throttle")) setprop("/autopilot/speed/rthrottle", "ias");
elsif ((getprop("/autopilot/panel/rarm") == 1) and (getprop("/autopilot/locks/speed") == "mach")) setprop("/autopilot/speed/rthrottle", "mach");
else setprop("/autopilot/speed/rthrottle", "");

if ((getprop("/connection/fgfscopilot/connected") != 1) and (getprop("/autopilot/dialog/override") != 1)) {

# Speed Models (convert panel props to generic)

if ((getprop("/autopilot/panel/auto-throttle") == 1) and (getprop("/autopilot/panel/speed-mode") == "ias")) setprop("/autopilot/locks/speed", "speed-with-throttle");
elsif ((getprop("/autopilot/panel/auto-throttle") == 1) and (getprop("/autopilot/panel/speed-mode") == "mach")) setprop("/autopilot/locks/speed", "mach");
else setprop("/autopilot/locks/speed", "");

# Master Autopilot controls (convert panel props to generic)

if (getprop("/autopilot/panel/master") == 1) {

	## Vertical Autopilot Settings
	if (getprop("/autopilot/panel/alt") == "alt") {
		setprop("/autopilot/locks/altitude", "altitude-hold");
	} elsif (getprop("/autopilot/panel/alt") == "vs") {
		setprop("/autopilot/locks/altitude", "vertical-speed-hold");
	} elsif (getprop("/autopilot/panel/atl") == "vnav") {
		setprop("/autopilot/locks/altitude", "vnav");
	} elsif (getprop("/autopilot/panel/alt") == "app") {
		setprop("/autopilot/locks/altitude", "gs1-hold");
	} else setprop("/autopilot/locks/altitude", "");

	## Lateral Autopilot Settings
	if (getprop("/autopilot/panel/hdg") == "hdg") {
		setprop("/autopilot/locks/heading", "dg-heading-hold");
	} elsif (getprop("/autopilot/panel/hdg") == "lnav") {
		setprop("/autopilot/locks/heading", "true-heading-hold");
	} elsif (getprop("/autopilot/panel/hdg") == "loc") {
		setprop("/autopilot/locks/heading", "nav1-hold");
	} else setprop("/autopilot/locks/heading", "");

} else {
	setprop("/autopilot/locks/altitude", "");
	setprop("/autopilot/locks/heading", "");
}

}

# Vertical Speed FDM Display

if (getprop("/autopilot/settings/vertical-speed-fpm") >= 0) setprop("/autopilot/panel/disp-vs", getprop("/autopilot/settings/vertical-speed-fpm"));
else setprop("/autopilot/panel/disp-vs", -1 * getprop("/autopilot/settings/vertical-speed-fpm"));

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
 mcp.init();
 });

