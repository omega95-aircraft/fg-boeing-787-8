var light = {
	init : func { 
        me.UPDATE_INTERVAL = 0.1; 
        me.loopid = 0; 

		setprop("/controls/lighting/dome-input", 0.6);
		setprop("/controls/lighting/ovhd-input", 0.6);
		setprop("/controls/lighting/master-bright", 0.6);

        me.reset(); 
}, 
	update : func {

setprop("/controls/lighting/dome-output", getprop("/controls/lighting/dome-input") * getprop("/controls/lighting/master-bright"));

setprop("/controls/lighting/ovhd-output", getprop("/controls/lighting/ovhd-input") * getprop("/controls/lighting/master-bright"));

if (getprop("/controls/lighting/landing-lights[0]")) { 
setprop("/controls/lighting/cab-and-land", 1);
setprop("/controls/lighting/only-cab", 0);
} else {
setprop("/controls/lighting/cab-and-land", 0);
setprop("/controls/lighting/only-cab", 1);
}

# Ground Landing Lights

if (getprop("/position/altitude-agl-ft") <= 300) setprop("/controls/lighting/landing-ground", 1 - (0.0033333 * getprop("/position/altitude-agl-ft")));
else setprop("/controls/lighting/landing-ground", 0);

setprop("/controls/lighting/shad-light-alt", getprop("/position/altitude-agl-ft") - 14.3);

setprop("/controls/lighting/ground-scale-factor", 1 - getprop("/controls/lighting/landing-ground"));

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
 light.init();
 });

