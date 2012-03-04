var fmc = {
	autogen_alts: func {
		# Determine direction of flight
		var start_long = getprop("/autopilot/route-manager/route/wp/longitude-deg");
		var total = getprop("/autopilot/route-manager/route/num") - 1;
		var end_long = getprop("/autopilot/route-manager/route/wp[" ~ total ~ "]/longitude-deg");
		if (end_long >= start_long)
			setprop("/instrumentation/b787-fmc/vnav-calcs/direction", "East");	# altitude recommendations will be rounded to nearest odd thousand
		else
			setprop("/instrumentation/b787-fmc/vnav-calcs/direction", "West");	# altitude recommendations will be rounded to nearest even thousand
		
		# Determine climb altitudes
		setprop("/instrumentation/b787-fmc/vnav-calcs/wp/altitude", getprop("/instrumentation/altimeter/indicated-altitude-ft"));
		var tod_wp = 9999;
		var descent_distance = 0;
		var vs_climb = 2750;
		var distance = 0;
		var climb_gs = 0;
		var index = 0;
		var altitude = 1;
		var factor = 1;
		for (var y = getprop("/autopilot/route-manager/route/num") - 2; y > 0; y -= 1){
			if (descent_distance < 124){
				descent_distance += getprop("/autopilot/route-manager/route/wp["~ y ~"]/leg-distance-nm");
				tod_wp = y;
			}
			else
				y = -1;
		}
		for (var x = 1; x < getprop("/autopilot/route-manager/route/num") - 1; x += 1){
			if (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude") < 10000)
				vs_climb = 2750;
			elsif ((getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude") >= 10000) and (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude") < 30000))
				vs_climb = 2250;
			else
				vs_climb = 1000;
			distance = getprop("/autopilot/route-manager/route/wp["~ index ~"]/leg-distance-nm");
			index=(x - 1);
			altitude = getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude");
			#if (!altitude > 0) die("Altitude is not > 0");
			factor = math.ln(altitude);
			climb_gs = -314.287 + (75.242 *  factor);
			if (climb_gs < 288)
				climb_gs = 288;
			setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ x ~"]/climb-gs", climb_gs);
			setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ x ~"]/vs-climb", vs_climb);
			setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ x ~"]/distance", distance);
			setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ x ~"]/altitude", vs_climb * (60 * distance / climb_gs) + getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude"));
			if ((getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude") < 35000) and (x < tod_wp)){
				if (getprop("/instrumentation/b787-fmc/vnav-calcs/direction") == "East"){
					for (var n = -1000; n < 41000; n += 2000){
						if ((getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude") >= n) and (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude") < n + 1000))
							setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ x ~"]/altitude", n);
						elsif (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude") >= n + 1000)
							setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ x ~"]/altitude", n + 2000);
					}
				}
				else{
					for (var n = -2000; n < 40000; n += 2000){
						if ((getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude") >= n) and (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude") < n + 1000))
							setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ x ~"]/altitude", n);
						elsif (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude") >= n + 1000)
							setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ x ~"]/altitude", n + 2000);
					}
				}
			}
		}
		# Determine descent altitudes
		vs_descent = -2300;
		var descent_gs = 0;
		for (var z = tod_wp; z < getprop("/autopilot/route-manager/route/num") - 1; z += 1){
			if (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ (z - 1) ~"]/altitude") > 10000)
				vs_descent = -2300;
			else
				vs_descent = -1800;
			distance = getprop("/autopilot/route-manager/route/wp["~ (z - 1) ~"]/leg-distance-nm");
			altitude = getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ index ~"]/altitude");
			#if (!altitude > 0) die("Altitude is not > 0");
			descent_gs = -1.682 * math.pow(10, -7) * math.pow(altitude, 2) + 0.017 * altitude + 51.385;
			setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ z ~"]/altitude", altitude + (vs_climb * (60 * distance) / descent_gs));
			if (getprop("/instrumentation/b787-fmc/vnav-calcs/direction") == "East"){
				for (var n = 41000; n > -1000; n -= 2000){
					if ((getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ (z - 1) ~"]/altitude") <= n) and (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ (z - 1) ~"]/altitude") >= n - 1000))
						setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ z ~"]/altitude", n);
					elsif (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ (z - 1) ~"]/altitude") < n - 1000)
						setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ z ~"]/altitude", n - 2000);
				}
			}
			else{
				for (var n = 40000; n > -2000; n -= 2000){
					if ((getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ (z - 1) ~"]/altitude") <= n) and (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ (z - 1) ~"]/altitude") >= n - 1000))
						setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ z ~"]/altitude", n);
					elsif (getprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ (z - 1) ~"]/altitude") < n - 1000)
						setprop("/instrumentation/b787-fmc/vnav-calcs/wp["~ z ~"]/altitude", n - 2000);
				}
			}
		}
	},
	calc_speeds: func {
	
		# Take-off and Approach Flap Extension Speeds
		
		var total_weight = getprop("/fdm/jsbsim/inertia/weight-lbs");
		
		## FLAPS: 1 DEG
		setprop("/instrumentation/b787-fmc/speeds/flaps1", (2.8303320214779 * 0.0001 * total_weight) + 118.28007981769);
		
		## FLAPS: 5 DEG
		setprop("/instrumentation/b787-fmc/speeds/flaps5", (2.6844176662278 * 0.0001 * total_weight) + 119.04376832572);
		
		## FLAPS: 10 DEG
		setprop("/instrumentation/b787-fmc/speeds/flaps10", (2.4794813791967 * 0.0001 * total_weight) + 101.66786689933);
		
		## FLAPS: 15 DEG
		setprop("/instrumentation/b787-fmc/speeds/flaps15", (2.3086744918531 * 0.0001 * total_weight) + 81.372486004066);
		
		## FLAPS: 25 DEG
		setprop("/instrumentation/b787-fmc/speeds/flaps25", (2.5112138808426 * 0.0001 * total_weight) + 61.051881021611);
		
		## FLAPS: 35 DEG
		setprop("/instrumentation/b787-fmc/speeds/flaps35", (1.7977818210994 * 0.0001 * total_weight) + 72.319797126439);
		
		# Appraoch Speed
		
		setprop("/instrumentation/b787-fmc/speeds/ap", (1.0044642857143 * 0.0001 * total_weight) + 101.84654017857);
		
		# Touchdown Speed
		
		setprop("/instrumentation/b787-fmc/speeds/td", (1.1160714285714 * 0.0001 * total_weight) + 85.385044642858);
	
	},
	parse_flightsDB: func {
	
		io.read_properties(getprop("/sim/aircraft-dir") ~ "/FMC-DB/FMC_Flights.xml", "/instrumentation/b787-fmc");
	
	},
	search_flight: func(flightnum) {
	
		var flightsDB = "/instrumentation/b787-fmc/flightsDB/" ~ flightnum ~ "/";
	
		# Check if the flight exists
		if (getprop(flightsDB ~ "depicao") != nil) {
			
			# Display Flight Data in the CDU
			setprop("/controls/cdu/display/l1", flightnum);
			setprop("/controls/cdu/display/l2", getprop(flightsDB ~ "depicao"));
			setprop("/controls/cdu/display/l3", getprop(flightsDB ~ "arricao"));
			setprop("/controls/cdu/display/l4", getprop(flightsDB ~ "reg"));
			setprop("/controls/cdu/display/l5", getprop(flightsDB ~ "flight-time"));
			
			# Whether route is available
			
			if (getprop(flightsDB ~ "route/pre") == 1) {
				setprop("/controls/cdu/display/l6", "Available");
			} else {
				setprop("/controls/cdu/display/l6", "Unavailable");
			}	

		} else {
			setprop("/controls/cdu/display/page", "DEP/ARR");
		}
	
	},
	confirm_flight: func(flightnum) {
	
		var flightsDB = "/instrumentation/b787-fmc/flightsDB/" ~ flightnum ~ "/";
	
	
		# Used to clear the current route entered
		setprop("/autopilot/route-manager/input", "@CLEAR");
		
		if (getprop(flightsDB ~ "route/pre") == 1) {
			# Enter Route from the Database
			var n = 0;
			while(getprop(flightsDB ~ "route/wp[" ~ n ~ "]/id") != nil) {
		
				# If vnav is available, enter vnav altitudes too
				if (getprop(flightsDB ~ "route/vnav") == 1) {
				
					setprop("/autopilot/route-manager/input", "@INSERT999:" ~ getprop(flightsDB ~ "route/wp[" ~ n ~ "]/id") ~ "@" ~ getprop(flightsDB ~ "route/wp[" ~ n ~ "]/alt"));
				
				} else { # If not, just put in the waypoints
			
					setprop("/autopilot/route-manager/input", "@INSERT999:" ~ getprop(flightsDB ~ "route/wp[" ~ n ~ "]/id"));
			
				}
		
				n += 1;
			}
		}
		
		# If vnav is enabled, enter crz altitude and crz wps
		
		if (getprop(flightsDB ~ "route/vnav") == 1) {
			setprop("/controls/cdu/vnav/crz-altitude-ft", getprop(flightsDB ~ "route/crz-altitude-ft"));
			setprop("/controls/cdu/vnav/start-crz", getprop(flightsDB ~ "route/start-crz"));
			setprop("/controls/cdu/vnav/end-crz", getprop(flightsDB ~ "route/end-crz"));
		}
		
		# Set Departure and Arrival Airport
		setprop("/autopilot/route-manager/departure/airport", getprop(flightsDB ~ "depicao"));
		setprop("/autopilot/route-manager/destination/airport", getprop(flightsDB ~ "arricao"));
		
		# If a preset route doesn't exist, generate a route
		
		if (getprop(flightsDB ~ "route/pre") != 1)
			setprop("/autopilot/route-manager/input", "@ROUTE1")		
	
	}
};
