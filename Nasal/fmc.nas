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
	
		
	
	},
	select_flight: func {
	
		
	
	}
};
