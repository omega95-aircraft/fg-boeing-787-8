var door = aircraft.door.new("/services/deicing_truck/crane", 20);
var door3 = aircraft.door.new("/services/deicing_truck/deicing", 20);

var ground_services = {
	init : func {
		me.UPDATE_INTERVAL = 0.1;
	me.loopid = 0;
	
	me.ice_time = 0;

	# Fuel Truck
	
	setprop("/services/fuel-truck/enable", 0);
	setprop("/services/fuel-truck/connect", 0);
	setprop("/services/fuel-truck/transfer", 0);
	setprop("/services/fuel-truck/clean", 0);
	setprop("/services/fuel-truck/request-kg", 0);
	
	# External Power
	
	setprop("/services/ext-pwr/active", 0);
	
	# De-icing Truck
	
	setprop("/services/deicing_truck/enable", 0);
	setprop("/services/deicing_truck/de-ice", 0);

	me.reset();
	},
	update : func {
	
		# Fuel Truck Controls
		
		if (getprop("/services/fuel-truck/enable") and getprop("/services/fuel-truck/connect")) {
		
			if (getprop("/services/fuel-truck/transfer")) {
			
				if (getprop("consumables/fuel/total-fuel-kg") < getprop("/services/fuel-truck/request-kg")) {
					setprop("/consumables/fuel/tank/level-kg", getprop("/consumables/fuel/tank/level-kg") + 20);
					setprop("/consumables/fuel/tank[1]/level-kg", getprop("/consumables/fuel/tank[1]/level-kg") + 20);
					setprop("/consumables/fuel/tank[2]/level-kg", getprop("/consumables/fuel/tank[2]/level-kg") + 20);
				} else {
					setprop("/services/fuel-truck/transfer", 0);
					screen.log.write("Re-fueling complete! Have a nice flight... :)", 1, 1, 1);
				}				
			
			}
			
			if (getprop("/services/fuel-truck/clean")) {
			
				if (getprop("consumables/fuel/total-fuel-kg") > 90) {
				
					setprop("/consumables/fuel/tank/level-kg", getprop("/consumables/fuel/tank/level-kg") - 80);
					setprop("/consumables/fuel/tank[1]/level-kg", getprop("/consumables/fuel/tank/level-kg") - 80);
					setprop("/consumables/fuel/tank[2]/level-kg", getprop("/consumables/fuel/tank/level-kg") - 80);
				
				} else {
					setprop("/services/fuel-truck/clean", 0);
					screen.log.write("Finished draining the fuel tanks...", 1, 1, 1);
				}	
			
			}
		
		}
		
		# De-icing Truck
		
		if (getprop("/services/deicing_truck/enable") and getprop("/services/deicing_truck/de-ice"))
		{
		
			if (me.ice_time == 2){
				door.move(1);
				print ("Lifting De-icing Crane...");
			}
			
			if (me.ice_time == 220){
				door3.move(1);
				print ("Starting De-icing Process...");
			}
			
			if (me.ice_time == 420){
				door3.move(0);
				print ("De-icing Process Completed...");
			}
				
			if (me.ice_time == 650){
				door.move(0);
				print ("Lowering De-icing Crane...");
			}
			
			if (me.ice_time == 900) {
				screen.log.write("De-icing Completed!", 1, 1, 1);
				setprop("/services/deicing_truck/de-ice", 0);
				setprop("/controls/ice/wing/temp", 30);
				setprop("/controls/ice/wing/eng1", 30);
				setprop("/controls/ice/wing/eng2", 30);
			}
		
		} else 
			me.ice_time = 0;
		
		
	me.ice_time += 1;
	
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

setlistener("sim/signals/fdm-initialized", func {
	ground_services.init();
	print("Ground Services ..... Initialized");
});
