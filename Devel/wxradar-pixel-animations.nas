var location = "/temp/test/";
var filename = getprop("/sim/fg-home") ~ "/Drawing/terrain-map-pixel.xml";

var create_pixels = func() {

	for (var row = 0; row < 32; row += 1)
	{

		for (var col = 1; col <= 32; col += 1)
		{

			var pixel = ((row * 32) + col);
			
			if (pixel < 10) var pixel_no = "00" ~ pixel;
			elsif (pixel < 100) var pixel_no = "0" ~ pixel;
			else var pixel_no = pixel;

			setprop(location ~ "animation[" ~ pixel ~ "]/type", "textranslate");
			setprop(location~"animation[" ~ pixel ~ "]/object-name", "Plane." ~ pixel_no);
			setprop(location~"animation[" ~ pixel ~ "]/property", "/instrumentation/terrain-map/pixels/row[" ~ row ~ "]/col[" ~ col ~ "]/elevation-ft");
			setprop(location ~ "animation[" ~ pixel ~ "]/factor", 0.000055556);
			setprop(location ~ "animation[" ~ pixel ~ "]/axis/x", 1);

		}

	}    

	io.write_properties(filename, location);

}
