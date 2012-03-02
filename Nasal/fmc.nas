var fmc = {
	autogen_alt : func {
	# Determine direction of flight
	var start_long = getprop("/autopilot/route-manager/route/wp/longitude-deg");
	var max = getprop("/autopilot/route-manager/route/num") - 1;
	var end_long = getprop("/autopilot/route-manager/route/wp"[ ~ max ~ ]"/longitude-deg");
	if (end_long >= start_long)
		setprop("/instrumentation/b787-fmc/VNAV-calcs/direction", "East");	# altitude recommendations will be rounded to nearest odd thousand
	else
		setprop("/instrumentation/b787-fmc/VNAV-calcs/direction", "West");	# altitude recommendations will be rounded to nearest even thousand
	# Generate climb and cruise altitude recommendations
	var altitudes = [];
	var base_alt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	var leg_distance = [];
	var TOD_MAX = 172.2;
	var tod_wp = 9999;
	var descent_distance = 0;
	var current_wp = 0;
	for (var x = 0; x < getprop("/autopilot/route-manager/route/num") - 1; x++){
		current_wp = x;
		leg_distance[x] = getprop("/autopilot/route-manager/route/wp"[~ x ~]);
		if ((x == 0) and (x < tod_wp))
			altitudes[x] = base_alt;
		elsif ((x > 0) and (x < tod_wp))
			altitudes[x] = base_alt + 74.1873 * 1.013 * climb_gs(altitudes[x]);
		else
			altitudes[x] = 0.1418 * math.pow(descent_gs(altitudes[x]), 2) + 15.9504 * descent_gs(altitudes[x]) + 626.1109;
		for (var y = getprop("/autopilot/route-manager/route/num") - 1; y >= 0; y--){
			if (descent_distance < TOD_MAX)
				descent_distance += getprop("/autopilot/route-manager/route/wp"[~ y ~]);
		}
		# Make the plane climb ONLY if it has not reached the max TOD distance
		while ((altitudes[x] < 35000) and (current_wp < tod_wp)){
			if ((getprop("/instrumentation/b787-fmc/VNAV-calcs/direction") == "East")){
				altitudes[x] = round_odd(altitudes[x]);
				if (altitudes[x] < 18000)
					setprop("/instrumentation/b787-fmc/VNAV-calcs/altitude"[~ x + 1 ~]"/altitude", 2500 * (60 * getprop("/autopilot/route-manager/route/wp"[~ x ~]"/leg-distance-nm") / climb_gs(altitudes[x])) + altitudes[x];
				elsif ((altitudes[x] > 18000) and (altitudes[x] < 26000))
					setprop("/instrumentation/b787-fmc/VNAV-calcs/altitude"[~ x + 1 ~]"/altitude", 1800 * (60 * getprop("/autopilot/route-manager/route/wp"[~ x ~]"/leg-distance-nm") / climb_gs(altitudes[x])) + altitudes[x];
				else
					setprop("/instrumentation/b787-fmc/VNAV-calcs/altitude"[~ x + 1 ~]"/altitude", 1000 * (60 * getprop("/autopilot/route-manager/route/wp"[~ x ~]"/leg-distance-nm") / climb_gs(altitudes[x])) + altitudes[x];
			}
			else{
				altitudes[x] = round_even(altitudes[x]);
				if (altitudes[x] < 18000)
					setprop("/instrumentation/b787-fmc/VNAV-calcs/altitude"[~ x + 1 ~]"/altitude", 2500 * (60 * getprop("/autopilot/route-manager/route/wp"[~ x ~]"/leg-distance-nm") / climb_gs(altitudes[x])) + altitudes[x];
				elsif ((altitudes[x] > 18000) and (altitudes[x] < 26000))
					setprop("/instrumentation/b787-fmc/VNAV-calcs/altitude"[~ x + 1 ~]"/altitude", 1800 * (60 * getprop("/autopilot/route-manager/route/wp"[~ x ~]"/leg-distance-nm") / climb_gs(altitudes[x])) + altitudes[x];
				else
					setprop("/instrumentation/b787-fmc/VNAV-calcs/altitude"[~ x + 1 ~]"/altitude", 1000 * (60 * getprop("/autopilot/route-manager/route/wp"[~ x ~]"/leg-distance-nm") / climb_gs(altitudes[x])) + altitudes[x];
			}
		}
		# After the max TOD distance, make the plane descend
		while (current_wp > tod_wp){
			if ((getprop("/instrumentation/b787-fmc/VNAV-calcs/direction") == "East")){
				altitudes[x] = round_odd(altitudes[x]);
				if (altitudes[x] > 10000)
					setprop("/instrumentation/b787-fmc/VNAV-calcs/altitude"[~ x + 1 ~]"/altitude", -1 * (-2300 * (60 * getprop("/autopilot/route-manager/route/wp"[~ x ~]"/leg-distance-nm") / descent_gs(altitudes[x])) - altitudes[x]);
				else
					setprop("/instrumentation/b787-fmc/VNAV-calcs/altitude"[~ x + 1 ~]"/altitude", -1 * (-1800 * (60 * getprop("/autopilot/route-manager/route/wp"[~ x ~]"/leg-distance-nm") / descent_gs(altitudes[x])) - altitudes[x]);
			}
			else
				altitudes[x] = round_odd(altitudes[x]);
				if (altitudes[x] > 10000)
					setprop("/instrumentation/b787-fmc/VNAV-calcs/altitude"[~ x + 1 ~]"/altitude", -1 * (-2300 * (60 * getprop("/autopilot/route-manager/route/wp"[~ x ~]"/leg-distance-nm") / descent_gs(altitudes[x])) - altitudes[x]);
				else
					setprop("/instrumentation/b787-fmc/VNAV-calcs/altitude"[~ x + 1 ~]"/altitude", -1 * (-1800 * (60 * getprop("/autopilot/route-manager/route/wp"[~ x ~]"/leg-distance-nm") / descent_gs(altitudes[x])) - altitudes[x]);
		}
	}
},
	round_odd : func (altitudes[x]) {
	if (altitudes[x] < 2000)
		altitudes[x] = 1000;
	elsif ((altitudes[x] >= 2000) and altitudes[x] < 4000)
		altitudes[x] = 3000;
	elsif ((altitudes[x] >= 4000) and altitudes[x] < 6000)
		altitudes[x] = 5000;
	elsif ((altitudes[x] >= 6000) and altitudes[x] < 8000)
		altitudes[x] = 7000;
	elsif ((altitudes[x] >= 8000) and altitudes[x] < 10000)
		altitudes[x] = 9000;
	elsif ((altitudes[x] >= 10000) and altitudes[x] < 12000)
		altitudes[x] = 11000;
	elsif ((altitudes[x] >= 12000) and altitudes[x] < 14000)
		altitudes[x] = 13000;
	elsif ((altitudes[x] >= 14000) and altitudes[x] < 16000)
		altitudes[x] = 15000;
	elsif ((altitudes[x] >= 16000) and altitudes[x] < 18000)
		altitudes[x] = 17000;
	elsif ((altitudes[x] >= 18000) and altitudes[x] < 20000)
		altitudes[x] = 19000;
	elsif ((altitudes[x] >= 20000) and altitudes[x] < 22000)
		altitudes[x] = 21000;
	elsif ((altitudes[x] >= 22000) and altitudes[x] < 24000)
		altitudes[x] = 23000;
	elsif ((altitudes[x] >= 24000) and altitudes[x] < 26000)
		altitudes[x] = 25000;
	elsif ((altitudes[x] >= 26000) and altitudes[x] < 28000)
		altitudes[x] = 27000;
	elsif ((altitudes[x] >= 28000) and altitudes[x] < 30000)
		altitudes[x] = 29000;
	elsif ((altitudes[x] >= 30000) and altitudes[x] < 32000)
		altitudes[x] = 31000;
	elsif ((altitudes[x] >= 32000) and altitudes[x] < 34000)
		altitudes[x] = 33000;
	elsif ((altitudes[x] >= 34000) and altitudes[x] < 36000)
		altitudes[x] = 35000;
	elsif ((altitudes[x] >= 36000) and altitudes[x] < 38000)
		altitudes[x] = 37000;
	elsif ((altitudes[x] >= 38000) and altitudes[x] < 40000)
		altitudes[x] = 39000;
	else
		altitudes[x] = 41000;
},
	round_even : func (altitudes[x]) {
	if (altitudes[x] < 3000)
		altitudes[x] = 2000;
	elsif ((altitudes[x] >= 3000) and altitudes[x] < 5000)
		altitudes[x] = 4000;
	elsif ((altitudes[x] >= 5000) and altitudes[x] < 7000)
		altitudes[x] = 6000;
	elsif ((altitudes[x] >= 7000) and altitudes[x] < 9000)
		altitudes[x] = 8000;
	elsif ((altitudes[x] >= 9000) and altitudes[x] < 11000)
		altitudes[x] = 10000;
	elsif ((altitudes[x] >= 11000) and altitudes[x] < 13000)
		altitudes[x] = 12000;
	elsif ((altitudes[x] >= 13000) and altitudes[x] < 15000)
		altitudes[x] = 14000;
	elsif ((altitudes[x] >= 15000) and altitudes[x] < 17000)
		altitudes[x] = 16000;
	elsif ((altitudes[x] >= 17000) and altitudes[x] < 19000)
		altitudes[x] = 18000;
	elsif ((altitudes[x] >= 19000) and altitudes[x] < 21000)
		altitudes[x] = 20000;
	elsif ((altitudes[x] >= 21000) and altitudes[x] < 23000)
		altitudes[x] = 22000;
	elsif ((altitudes[x] >= 23000) and altitudes[x] < 25000)
		altitudes[x] = 24000;
	elsif ((altitudes[x] >= 25000) and altitudes[x] < 27000)
		altitudes[x] = 26000;
	elsif ((altitudes[x] >= 27000) and altitudes[x] < 29000)
		altitudes[x] = 28000;
	elsif ((altitudes[x] >= 29000) and altitudes[x] < 31000)
		altitudes[x] = 30000;
	elsif ((altitudes[x] >= 31000) and altitudes[x] < 33000)
		altitudes[x] = 32000;
	elsif ((altitudes[x] >= 33000) and altitudes[x] < 35000)
		altitudes[x] = 34000;
	elsif ((altitudes[x] >= 35000) and altitudes[x] < 37000)
		altitudes[x] = 36000;
	elsif ((altitudes[x] >= 37000) and altitudes[x] < 39000)
		altitudes[x] = 38000;
	else
		altitudes[x] = 40000;
},
	climb_gs : func (altitudes[x]) {
	return 101.66 * math.ln(altitudes[x]) - 32.875;
},
	descent_gs : func (altitudes[x]) {
	return -1.6819 * math.pow(10,-7) * math.pow(altitudes[x], 2) + 0.0171 * altitudes[x] + 51.3853
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
