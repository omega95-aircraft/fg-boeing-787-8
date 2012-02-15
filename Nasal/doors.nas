var doors =
 {
 new: func(name, transit_time)
  {
  doors[name] = aircraft.door.new("sim/model/door-positions/" ~ name, transit_time);
  },
 toggle: func(name)
  {
  doors[name].toggle();
  },
 open: func(name)
  {
  doors[name].open();
screen.log.write("Opening ~ name ~ Door", 1, 1, 1);
  },
 close: func(name)
  {
  doors[name].close();
screen.log.write("Closing ~ name ~ Door", 1, 0, 0);
  },
 setpos: func(name, value)
  {
  doors[name].setpos(value);
  }
 };
doors.new("l1", 5);
doors.new("l2", 5);
doors.new("r1", 5);
doors.new("r2", 5);
doors.new("cargo", 10);
