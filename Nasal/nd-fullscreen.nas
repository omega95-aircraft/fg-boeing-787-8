    var nd = {
       init : func {
            me.UPDATE_INTERVAL = 0.01;
            me.loopid = 0;

			setprop("/instrumentation/ndfull/range", 100);
			setprop("/instrumentation/groundradar/range", 100);
			setprop("/instrumentation/ndfull/show-vor1", 0);
			setprop("/instrumentation/ndfull/show-vor2", 0);

       		me.loopnum = 1;

			me.nearestairport = "";

            me.reset();
    },
       update : func {

setprop("/instrumentation/groundradar/range", getprop("/instrumentation/ndfull/range"));

if (getprop("/instrumentation/ndfull/active") == 1) {

    var heading = getprop("orientation/heading-magnetic-deg");
    var poslat = getprop("/position/latitude-deg");
    var poslon = getprop("/position/longitude-deg");

	var ytop = getprop("/instrumentation/ndfull/range");
	var ybottom = getprop("/instrumentation/ndfull/range") * 0.3;
	var xext = getprop("/instrumentation/ndfull/range");

	# 1 carterian co-ordinate unit = 1 nm = 1/60 degree (lat/lon)

	var xcoord = poslon * 60;
	var ycoord = poslat * 60;

	## Airport Diagram

	if (getprop("/sim/airport/closest-airport-id") != nil) {
	if (getprop("/sim/airport/closest-airport-id") != me.nearestairport) {

	me.nearestairport = getprop("/sim/airport/closest-airport-id");

	setprop("/instrumentation/gps[1]/scratch/query", me.nearestairport);
	setprop("/instrumentation/gps[1]/scratch/type", "airport");

	setprop("/instrumentation/gps[1]/command", "search");

	}
	}

	if (getprop("/instrumentation/gps[1]/scratch/longitude-deg") != nil) {

	var naxcoord = 60 * getprop("/instrumentation/gps[1]/scratch/longitude-deg");
	var naycoord = 0.24 + (60 * getprop("/instrumentation/gps[1]/scratch/latitude-deg"));

	var xoffset = (naxcoord - xcoord) * (100 / ytop);
	var yoffset = (naycoord - ycoord) * (100 / ytop);

setprop("/instrumentation/ndfull/airport/xoffset", xoffset);

setprop("/instrumentation/ndfull/airport/yoffset", yoffset);

	}	

	# RADIAL CALCULATIONS

	## Heading Bug

	if (getprop("/autopilot/settings/heading-bug-deg") != nil) {
	setprop("/instrumentation/ndfull/heading-bug", Deflection(getprop("/autopilot/settings/heading-bug-deg"), 125)); }

	## Navigation Bugs

    setprop("/instrumentation/ndfull/nav1-brg", Deflection(getprop("/instrumentation/nav/heading-deg"),125));
    setprop("/instrumentation/ndfull/nav2-brg", Deflection(getprop("/instrumentation/nav[1]/heading-deg"),125));

	## Next WP Bearing

	setprop("/instrumentation/ndfull/next-wp-brg", Deflection(getprop("/instrumentation/gps/wp/leg-mag-course-deg"), 125));

	## VOR 1

if (getprop("/instrumentation/nav/nav-distance") != nil) {

	setprop("/instrumentation/ndfull/vor1-dist", (getprop("/instrumentation/nav/nav-distance") / 1852) * (20 / ytop));

if (getprop("instrumentation/ndfull/vor1-dist") <= ytop) {
 	setprop("/instrumentation/ndfull/show-vor1", 1);
} else {
 	setprop("/instrumentation/ndfull/show-vor1", 0);
}
}

	## VOR 2

if (getprop("/instrumentation/nav[1]/nav-distance") != nil) {
	setprop("/instrumentation/ndfull/vor2-dist", (getprop("/instrumentation/nav[1]/nav-distance") / 1852) * (20 / ytop));

if (getprop("instrumentation/ndfull/vor2-dist") <= ytop) {
 	setprop("/instrumentation/ndfull/show-vor2", 1);
} else {
 	setprop("/instrumentation/ndfull/show-vor2", 0);
}
}

	# PLANAR CALCULATIONS

	## Waypoints

var currentwp = getprop("/autopilot/route-manager/current-wp");
var numberofwps = getprop("/autopilot/route-manager/route/num");

for (var n = 1; n <= 10; n += 1) {

if (numberofwps - currentwp > n - 1) {

var wp = currentwp + n - 1;

if (getprop("/autopilot/route-manager/route/wp[" ~ wp ~ "]/longitude-deg") != nil) {

var wpxcoord = 60 * getprop("/autopilot/route-manager/route/wp[" ~ wp ~ "]/longitude-deg");
var wpycoord = 60 * getprop("/autopilot/route-manager/route/wp[" ~ wp ~ "]/latitude-deg");
setprop("/instrumentation/ndfull/route/wp[" ~ (wp + 1) ~ "]/id" ,getprop("/autopilot/route-manager/route/wp[" ~ wp ~ "]/id"));

var xoffset = (wpxcoord - xcoord) * (100 / ytop);
var yoffset = (wpycoord - ycoord) * (100 / ytop);

if (n == 1) {
setprop("/instrumentation/ndfull/route/wp[1]/bearing-deg",270 + (57.2957795 * math.atan2(yoffset, xoffset)));
} else {

setprop("/instrumentation/ndfull/route/wp[" ~ (wp + 1) ~ "]/bearing-deg",270 + (57.2957795 * math.atan2(yoffset - getprop("/instrumentation/ndfull/route/wp[" ~ wp ~ "]/yoffset"), xoffset - getprop("/instrumentation/ndfull/route/wp[" ~ wp ~ "]/xoffset"))));

}

if (n == 1) {
setprop("/instrumentation/ndfull/route/wp[1]/line-length", math.sqrt((yoffset * yoffset) + (xoffset * xoffset)));
} else {

var linelength = math.sqrt(((yoffset - getprop("/instrumentation/ndfull/route/wp[" ~ wp ~ "]/yoffset")) * (yoffset - getprop("/instrumentation/ndfull/route/wp[" ~ wp ~ "]/yoffset"))) + ((xoffset - getprop("/instrumentation/ndfull/route/wp[" ~ wp ~ "]/xoffset")) * (xoffset - getprop("/instrumentation/ndfull/route/wp[" ~ wp ~ "]/xoffset"))));

setprop("/instrumentation/ndfull/route/wp[" ~ (wp + 1) ~ "]/line-length", linelength);

}

setprop("/instrumentation/ndfull/route/wp[" ~ (wp + 1) ~ "]/xoffset", xoffset);

setprop("/instrumentation/ndfull/route/wp[" ~ (wp + 1) ~ "]/yoffset", yoffset);

if ((xoffset <= xext*5) and (xoffset >= 0 - xext*5) and (yoffset <= ytop*5) and (yoffset >= 0 - ybottom*5)) {
setprop("/instrumentation/ndfull/route/wp[" ~ (wp + 1) ~ "]/show", 1);
} else {
setprop("/instrumentation/ndfull/route/wp[" ~ (wp + 1) ~ "]/show", 0);
}

} else {
setprop("/instrumentation/ndfull/route/wp[" ~ (wp + 1) ~ "]/show", 0);
}

} else {
setprop("/instrumentation/ndfull/route/wp[" ~ (currentwp + n) ~ "]/show", 0);
}
}

}   },
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
