var fmc = {
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
		
				# If VNAV is available, enter VNAV altitudes too
				if (getprop(flightsDB ~ "route/vnav") == 1) {
				
					setprop("/autopilot/route-manager/input", "@INSERT999:" ~ getprop(flightsDB ~ "route/wp[" ~ n ~ "]/id") ~ "@" ~ getprop(flightsDB ~ "route/wp[" ~ n ~ "]/alt"));
				
				} else { # If not, just put in the waypoints
			
					setprop("/autopilot/route-manager/input", "@INSERT999:" ~ getprop(flightsDB ~ "route/wp[" ~ n ~ "]/id"));
			
				}
		
				n += 1;
			}
		}
		
		# If VNAV is enabled, enter crz altitude and crz wps
		
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
