    var tcas = {
       init : func {
            me.UPDATE_INTERVAL = 0.05;
            me.loopid = 0;
            me.reset();
    },
       update : func {

    var heading = getprop("orientation/heading-magnetic-deg");

	var altitude = getprop("/position/altitude-ft");

    var poslat = getprop("/position/latitude-deg");
    var poslon = getprop("/position/longitude-deg");

if (getprop("/instrumentation/ndfull/active") == 1) {

	var ytop = getprop("/instrumentation/ndfull/range");
	var ybottom = getprop("/instrumentation/ndfull/range") * 0.3;
	var xext = getprop("/instrumentation/ndfull/range");

}

	# 1 carterian co-ordinate unit = 1 nm = 1/60 degree (lat/lon)

	var xcoord = poslon * 60;
	var ycoord = poslat * 60;

var closestmpn = 0;
var closestain = 0;

for (var n = 0; n < 30; n = n + 1) {

if (getprop("ai/models/multiplayer[" ~ n ~ "]/valid") and (getprop("ai/models/multiplayer[" ~ n ~ "]/callsign") != nil)) {

var mpxcoord = 60 * getprop("ai/models/multiplayer[" ~ n ~ "]/position/longitude-deg");
var mpycoord = 60 * getprop("ai/models/multiplayer[" ~ n ~ "]/position/latitude-deg");

# Radial Calculations for Half Screen ND

setprop("instrumentation/mptcas/mp[" ~ n ~ "]/bearing-defl",Deflection((57.2957795 * math.atan2(mpxcoord - xcoord, mpycoord - ycoord)), 60));

setprop("instrumentation/mptcas/mp[" ~ n ~ "]/bearing-deg" ,(57.2957795 * math.atan2(mpxcoord - xcoord, mpycoord - ycoord)));

setprop("instrumentation/mptcas/mp[" ~ n ~ "]/distance-nm", math.sqrt(((mpxcoord - xcoord) * (mpxcoord - xcoord)) + ((mpycoord - ycoord) * (mpycoord - ycoord))));

# Planar Calculations for Full Screen ND

if (getprop("/instrumentation/ndfull/active") == 1) {

var xoffset = (mpxcoord - xcoord) * (100 / ytop);
var yoffset = (mpycoord - ycoord) * (100 / ytop);

setprop("instrumentation/mptcas/mp[" ~ n ~ "]/xoffset", xoffset);

setprop("instrumentation/mptcas/mp[" ~ n ~ "]/yoffset", yoffset);

}

# Commmon Properties

setprop("instrumentation/mptcas/mp[" ~ n ~ "]/callsign", getprop("ai/models/multiplayer[" ~ n ~ "]/callsign"));

setprop("instrumentation/mptcas/mp[" ~ n ~ "]/altitude-ft", getprop("ai/models/multiplayer[" ~ n ~ "]/position/altitude-ft"));

var altitudediff = getprop("ai/models/multiplayer[" ~ n ~ "]/position/altitude-ft") - altitude;

setprop("instrumentation/mptcas/mp[" ~ n ~ "]/tas-kt", getprop("ai/models/multiplayer[" ~ n ~ "]/velocities/true-airspeed-kt"));

var vsfps = getprop("ai/models/multiplayer[" ~ n ~ "]/velocities/vertical-speed-fps");

if (vsfps < -8) {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/phase", "descend");
} elsif (vsfps >= 8) {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/phase", "climb");
} else {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/phase", "level");
}

var distance = getprop("instrumentation/mptcas/mp[" ~ n ~ "]/distance-nm");

if ((distance <= 3) and (altitudediff <= 1000)) {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/color", "red");
} elsif ((distance <= 5) and (altitudediff <= 2000)) {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/color", "orange");
} elsif ((distance <= 10) and (altitudediff <= 3000)) {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/color", "yellow");
} else {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/color", "cyan");
}

if (distance <= 30) {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/show", 1);
} else {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/show", 0);
}

if (getprop("/instrumentation/ndfull/active") == 1) {

if ((xoffset <= xext*5) and (xoffset >= 0 - xext*5) and (yoffset <= ytop*5) and (yoffset >= 0 - ybottom*5)) {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/show-ndfull", 1);
} else {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/show-ndfull", 0);
}

}

} else {
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/show", 0);
setprop("instrumentation/mptcas/mp[" ~ n ~ "]/show-ndfull", 0);
}

var distance = getprop("instrumentation/mptcas/mp[" ~ n ~ "]/distance-nm");


if (distance != nil) {

if (distance <= getprop("instrumentation/mptcas/mp[" ~ closestmpn ~ "]/distance-nm")) {
closestmpn = n;
}

}

}

for (var n = 0; n < 20; n = n + 1) {

if (getprop("ai/models/aircraft[" ~ n ~ "]/callsign") != nil) {

var mpxcoord = 60 * getprop("ai/models/aircraft[" ~ n ~ "]/position/longitude-deg");
var mpycoord = 60 * getprop("ai/models/aircraft[" ~ n ~ "]/position/latitude-deg");

# Radial Calculations for Half Screen ND

setprop("instrumentation/mptcas/ai[" ~ n ~ "]/bearing-defl",Deflection((57.2957795 * math.atan2(mpxcoord - xcoord, mpycoord - ycoord)), 60));

setprop("instrumentation/mptcas/ai[" ~ n ~ "]/bearing-deg" ,(57.2957795 * math.atan2(mpxcoord - xcoord, mpycoord - ycoord)));

setprop("instrumentation/mptcas/ai[" ~ n ~ "]/distance-nm", math.sqrt(((mpxcoord - xcoord) * (mpxcoord - xcoord)) + ((mpycoord - ycoord) * (mpycoord - ycoord))));

# Planar Calculations for Full Screen ND

if (getprop("/instrumentation/ndfull/active") == 1) {

var xoffset = (mpxcoord - xcoord) * (100 / ytop);
var yoffset = (mpycoord - ycoord) * (100 / ytop);

setprop("instrumentation/mptcas/ai[" ~ n ~ "]/xoffset", xoffset);

setprop("instrumentation/mptcas/ai[" ~ n ~ "]/yoffset", yoffset);

}

# Commmon Properties

setprop("instrumentation/mptcas/ai[" ~ n ~ "]/callsign", getprop("ai/models/aircraft[" ~ n ~ "]/callsign"));

setprop("instrumentation/mptcas/ai[" ~ n ~ "]/altitude-ft", getprop("ai/models/aircraft[" ~ n ~ "]/position/altitude-ft"));

var altitudediff = getprop("ai/models/aircraft[" ~ n ~ "]/position/altitude-ft") - altitude;

setprop("instrumentation/mptcas/ai[" ~ n ~ "]/tas-kt", getprop("ai/models/aircraft[" ~ n ~ "]/velocities/true-airspeed-kt"));

var vsfps = getprop("ai/models/aircraft[" ~ n ~ "]/velocities/vertical-speed-fps");

if (vsfps < -8) {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/phase", "descend");
} elsif (vsfps >= 8) {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/phase", "climb");
} else {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/phase", "level");
}

var distance = getprop("instrumentation/mptcas/ai[" ~ n ~ "]/distance-nm");

if ((distance <= 3) and (altitudediff <= 1000)) {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/color", "red");
} elsif ((distance <= 5) and (altitudediff <= 2000)) {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/color", "orange");
} elsif ((distance <= 10) and (altitudediff <= 3000)) {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/color", "yellow");
} else {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/color", "cyan");
}

if (distance <= 30) {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/show", 1);
} else {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/show", 0);
}

if (getprop("/instrumentation/ndfull/active") == 1) {

if ((xoffset <= xext*5) and (xoffset >= 0 - xext*5) and (yoffset <= ytop*5) and (yoffset >= 0 - ybottom*5)) {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/show-ndfull", 1);
} else {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/show-ndfull", 0);
}

}

} else {
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/show", 0);
setprop("instrumentation/mptcas/ai[" ~ n ~ "]/show-ndfull", 0);
}

var distance = getprop("instrumentation/mptcas/mp[" ~ n ~ "]/distance-nm");

if (distance != nil) {

if (distance <= getprop("instrumentation/mptcas/mp[" ~ closestain ~ "]/distance-nm")) {
closestain = n;
}

}

}

if ((getprop("instrumentation/mptcas/ai[" ~ closestain ~ "]/distance-nm") != nil) and (getprop("instrumentation/mptcas/mp[" ~ closestmpn ~ "]/distance-nm") != nil)) {

if (getprop("instrumentation/mptcas/ai[" ~ closestain ~ "]/distance-nm") > getprop("instrumentation/mptcas/mp[" ~ closestmpn ~ "]/distance-nm")) {
var closesttype = "mp";
var closestn = closestmpn;
setprop("/instrumentation/mptcas/closest/callsign", getprop("instrumentation/mptcas/mp[" ~ closestn ~ "]/callsign"));
} else {
var closesttype = "ai";
var closestn = closestain;
setprop("/instrumentation/mptcas/closest/callsign", getprop("instrumentation/mptcas/ai[" ~ closestn ~ "]/callsign"));
}

setprop("/instrumentation/mptcas/closest/n", closestn);
setprop("/instrumentation/mptcas/closest/type", closesttype);

var traffic = 0;
# TCAS Sounds

if (getprop("/position/altitude-agl-ft") >= 3000) {

if (getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") == "yellow") {
setprop("/sim/sound/tcas/traffic", 1);
setprop("/sim/sound/tcas/clear", 0); 
traffic = 1;
} else {
setprop("/sim/sound/tcas/traffic", 0); 
setprop("/sim/sound/tcas/clear", 0);
}

if ((getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") == "orange") and ( altitude > getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/altitude-ft")) and (getprop("/velocities/vertical-speed-fps") <= 8)) {
setprop("/sim/sound/tcas/climb", 1);
traffic = 1;
} else {
setprop("/sim/sound/tcas/climb", 0);
}

if ((getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") == "red") and ( altitude > getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/altitude-ft")) and (getprop("/velocities/vertical-speed-fps") <= 8)) {
setprop("/sim/sound/tcas/climb_now", 1);
traffic = 1;
} else {
setprop("/sim/sound/tcas/climb_now", 0);
}

if ((getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") == "orange") and ( altitude < getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/altitude-ft")) and (getprop("/velocities/vertical-speed-fps") >= -8) and (getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/phase" != "climb"))) {
setprop("/sim/sound/tcas/descend", 1);
traffic = 1;
} else {
setprop("/sim/sound/tcas/descend", 0);
}

if ((getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") == "red") and ( altitude < getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/altitude-ft")) and (getprop("/velocities/vertical-speed-fps") >= -8)) {
setprop("/sim/sound/tcas/descend_now", 1);
traffic = 1;
} else {
setprop("/sim/sound/tcas/descend_now", 0);
}

if ((getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") == "red") and ( altitude < getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/altitude-ft")) and (getprop("/velocities/vertical-speed-fps") > -8)) {
setprop("/sim/sound/tcas/increase_descent", 1);
traffic = 1;
} else {
setprop("/sim/sound/tcas/increase_descent", 0);
}

if ((getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") == "red") and ( altitude > getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/altitude-ft")) and (getprop("/velocities/vertical-speed-fps") > 8) and (getprop("/velocities/vertical-speed-fps") <= 60)) {
setprop("/sim/sound/tcas/increase_climb", 1);
traffic = 1;
} else {
setprop("/sim/sound/tcas/increase_climb", 0);
}

if ((getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") == "red") and ( altitude > getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/altitude-ft")) and (getprop("/velocities/vertical-speed-fps") < -8)) {
setprop("/sim/sound/tcas/do_not_descend", 1);
traffic = 1;
} else {
setprop("/sim/sound/tcas/do_not_descend", 0);
}

if ((getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") == "red") and ( altitude < getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/altitude-ft")) and (getprop("/velocities/vertical-speed-fps") > 8)) {
setprop("/sim/sound/tcas/do_not_climb", 1);
traffic = 1;
} else {
setprop("/sim/sound/tcas/do_not_climb", 0);
}

if ((traffic == 1) and ((getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") != "yellow") and (getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") != "orange") and (getprop("instrumentation/mptcas/" ~ closesttype ~ "[" ~ closestn ~ "]/color") != "red"))) {
setprop("/sim/sound/tcas/clear", 1);
traffic = 0;
} else {
setprop("/sim/sound/tcas/clear", 0);
}

} else {
setprop("/sim/sound/tcas/traffic", 0);
setprop("/sim/sound/tcas/climb", 0);
setprop("/sim/sound/tcas/climb_now", 0);
setprop("/sim/sound/tcas/increase_climb", 0);
setprop("/sim/sound/tcas/descend", 0);
setprop("/sim/sound/tcas/descend_now", 0);
setprop("/sim/sound/tcas/increase_descent", 0);
setprop("/sim/sound/tcas/do_not_climb", 0);
setprop("/sim/sound/tcas/do_not_descend", 0);
setprop("/sim/sound/tcas/clear", 0);
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

    var Deflection = func(bug, limit) {
      var heading = getprop("orientation/heading-magnetic-deg");
      var bugDeg = 0;

      while (bug < 0)
       {
       bug += 360;
       }
      while (bug > 360)
       {
       bug -= 360;
       }
      if (bug < limit)
       {
       bug += 360;
       }
      if (heading < limit)
       {
       heading += 360;
       }
      # bug is adjusted normally
      if (math.abs(heading - bug) < limit)
       {
       bugDeg = heading - bug;
       }
      elsif (heading - bug < 0)
       {
       # bug is on the far right
       if (math.abs(heading - bug + 360 >= 180))
        {
        bugDeg = -limit;
        }
       # bug is on the far left
       elsif (math.abs(heading - bug + 360 < 180))
        {
        bugDeg = limit;
        }
       }
      else
       {
       # bug is on the far right
       if (math.abs(heading - bug >= 180))
        {
        bugDeg = -limit;
        }
       # bug is on the far left
       elsif (math.abs(heading - bug < 180))
        {
        bugDeg = limit;
        }
       }

      return bugDeg;
    }

setlistener("sim/signals/fdm-initialized", func
 {
 tcas.init();
 });
