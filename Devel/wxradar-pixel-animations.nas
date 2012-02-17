var location = "/temp/test/";
var filename = getprop("/sim/fg-home") ~ "/Drawing/wxradar-pixel.xml";

var drawline = func() {

	for (var deg = 0; deg < 60; deg += 1)
	{

		for (var dist = 0; dist < 20; dist += 1)
		{

			setprop(location ~ "animation[" ~ ((deg * 20) + dist) ~ "]/type", "textranslate");
			setprop(location~"animation[" ~ ((deg * 20) + dist) ~ "]/object-name", "wxr." ~ (dist + 1) ~ "." ~ (deg + 1));
			setprop(location~"animation[" ~ ((deg * 20) + dist) ~ "]/property", "/instrumentation/wxradar/pixels/deg[" ~ deg ~ "]/dist[" ~ dist ~ "]/reflectivity");
			setprop(location ~ "animation[" ~ ((deg * 20) + dist) ~ "]/factor", 0.92);
			setprop(location ~ "animation[" ~ ((deg * 20) + dist) ~ "]/axis/x", 1);

		}

	}    

	io.write_properties(filename, location);

}
