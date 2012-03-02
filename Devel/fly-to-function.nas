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
