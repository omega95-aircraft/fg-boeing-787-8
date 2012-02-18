var terrain = "/instrumentation/terrain-map/pixels/";

    var terrain_map = {
       init : func {
            me.UPDATE_INTERVAL = 0.01;
            me.loopid = 0;
			me.sweepdegree = 0;
			me.radarradius = 0;
            me.reset();
    },
       update : func {

if (getprop("/controls/mfd/extra") == "terr") {

var pos_lon = getprop("/position/longitude-deg");
var pos_lat = getprop("/position/latitude-deg");
var heading = getprop("orientation/heading-magnetic-deg");

## To convert Distance and Bearing to Point as a new Latitude and Longitude

var getDeg = heading - 60 + (me.sweepdegree * 2);

var y0 = (((me.radarradius * 5) + 11) * math.cos(getDeg) / 60) + pos_lat;
var x0 = (((me.radarradius * 5) + 11) * math.sin(getDeg) / 60) + pos_lon;

var y1 = (((me.radarradius * 5) + 12) * math.cos(getDeg) / 60) + pos_lat;
var x1 = (((me.radarradius * 5) + 12) * math.sin(getDeg) / 60) + pos_lon;

var y2 = (((me.radarradius * 5) + 13) * math.cos(getDeg) / 60) + pos_lat;
var x2 = (((me.radarradius * 5) + 13) * math.sin(getDeg) / 60) + pos_lon;

var y3 = (((me.radarradius * 5) + 14) * math.cos(getDeg) / 60) + pos_lat;
var x3 = (((me.radarradius * 5) + 14) * math.sin(getDeg) / 60) + pos_lon;

var y4 = (((me.radarradius * 5) + 15) * math.cos(getDeg) / 60) + pos_lat;
var x4 = (((me.radarradius * 5) + 15) * math.sin(getDeg) / 60) + pos_lon;

setprop(terrain ~ "deg[" ~ me.sweepdegree ~ "]/dist[" ~ (me.radarradius * 5) ~ "]/elevation", get_elevation(y0, x0));

setprop(terrain ~ "deg[" ~ me.sweepdegree ~ "]/dist[" ~ ((me.radarradius * 5) + 1) ~ "]/elevation", get_elevation(y1, x1));

setprop(terrain ~ "deg[" ~ me.sweepdegree ~ "]/dist[" ~ ((me.radarradius * 5) + 2) ~ "]/elevation", get_elevation(y2, x2));

setprop(terrain ~ "deg[" ~ me.sweepdegree ~ "]/dist[" ~ ((me.radarradius * 5) + 3) ~ "]/elevation", get_elevation(y3, x3));

setprop(terrain ~ "deg[" ~ me.sweepdegree ~ "]/dist[" ~ ((me.radarradius * 5) + 4) ~ "]/elevation", get_elevation(y4, x4));

## For Sweep and Radar Incrementation and Reset

me.radarradius += 1;

if (me.radarradius == 4) {
me.sweepdegree += 1;
me.radarradius = 0;
}

if (me.sweepdegree == 60) me.sweepdegree = 1;

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

    # Function to get Elevation at latitude and longitude

    var get_elevation = func (lat, lon) {

    var info = geodinfo(lat, lon);
       if (info != nil) {var elevation = info[0] * 3.2808399;}
       else {var elevation = -1.0; }

    return elevation;
    }


setlistener("sim/signals/fdm-initialized", func
 {
 terrain_map.init();
 });
