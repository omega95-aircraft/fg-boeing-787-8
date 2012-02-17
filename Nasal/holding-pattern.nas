# CONSTANTS

var RAD2DEG = 57.2957795;
var DEG2RAD = 0.0174532925;
var htree = "/autopilot/hold/";

var hold = {
	init : func { 
        me.UPDATE_INTERVAL = 0.001; 
        me.loopid = 0; 
		setprop(htree ~"hold-time", 60);
		setprop(htree ~"hold-direction", 0);	# 0 = right, 1 = left
		setprop(htree ~"hold-radial", 0);
		setprop(htree ~"altitude", 5000);
		setprop(htree ~"active", 0);
		setprop(htree ~"entry", 0);	#0 = direct, 1 = parallel, 2 = teardrop
		setprop(htree ~"phase", 0);	#0 = define entry, 1 = inbound leg, 2 = outbound turn, 3 = outbound leg, 4 = inbound turn, 5 = fly entry
		setprop(htree ~"entry-phase", 0) #0 = parallel - fly to fix, 1 =  fly parallel, 2 = turn inbound, 3 intercept inbound leg
		setprop(htree ~"fix", "");
		setprop(htree ~"nav-type", "vor");
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
	var brg = getprop("/instrumentation/gps/scratch/mag-bearing-deg");
	var diff1 = hold_radial - brg;
	var diff2 = brg - hold_radial;
	
	if (diff1 <= 0)
		diff1 = 360 - math.abs(diff1);
	if (diff2 <= 0)
		diff2 = 360 - math.abs(diff2);
	if (active == 0)
		phase = 0;
	else{
		setprop("/autopilot/panel/master", 0);
		setprop("/autopilot/locks/altitude", "");
		setprop("/autopilot/locks/heading", "");
	}
	if (fix != ""){
		if (phase == 0){
			if ((diff1 <= 110) or (diff2 <= 70)){
				entry = 0;
				phase = 1;
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
		}
		elsif (phase == 5){
			if (entry == 1){
				
			}
			if (entry == 2){
				
			}
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

