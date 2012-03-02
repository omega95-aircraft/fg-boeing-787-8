var location = "/teai/test/";
var filename = getprop("/sim/fg-home") ~ "/Drawing/tcas-ndfull-animations.xml";

var drawline = func() {

	for (var n = 0; n < 30; n += 1)
	{

		setprop(location ~ "animation[" ~ (329 + (n * 11)) ~ "]/type", "select");
		setprop(location ~ "animation[" ~ (329 + (n * 11)) ~ "]/object-name", "ai"~(n+1)~"text");
		setprop(location ~ "animation[" ~ (329 + (n * 11)) ~ "]/object-name", "ai"~(n+1)~"down");
		setprop(location ~ "animation[" ~ (329 + (n * 11)) ~ "]/object-name", "ai"~(n+1)~"up");
		setprop(location ~ "animation[" ~ (329 + (n * 11)) ~ "]/object-name", "ai"~(n+1)~"level");

		setprop(location ~ "animation[" ~ (329 + (n * 11)) ~ "]/condition/equals/property", "instrumentation/aitcas/ai["~ n ~"]/show");
		setprop(location ~ "animation[" ~ (329 + (n * 11)) ~ "]/condition/equals/value", 1);

		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 1) ~ "]/type", "select");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 1) ~ "]/object-name", "ai"~(n+1)~"level");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 1) ~ "]/condition/equals/property", "instrumentation/aitcas/ai["~ n ~"]/phase");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 1) ~ "]/condition/equals/value", "level");

		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 2) ~ "]/type", "select");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 2) ~ "]/object-name", "ai"~(n+1)~"down");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 2) ~ "]/condition/equals/property", "instrumentation/aitcas/ai["~ n ~"]/phase");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 2) ~ "]/condition/equals/value", "down");

		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 3) ~ "]/type", "select");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 3) ~ "]/object-name", "ai"~(n+1)~"up");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 3) ~ "]/condition/equals/property", "instrumentation/aitcas/ai["~ n ~"]/phase");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 3) ~ "]/condition/equals/value", "up");

		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/name", "ai"~ (n+1) ~"text");
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/offsets/x-m", 0.0001);
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/offsets/y-m", 0.005);
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/offsets/z-m", -0.0436);
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/alignment", "left-center");
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/axis-alignment", "yz-plane");
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/type", "text-value");
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/format", "%s");
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/property", "instrumentation/aitcas/ai[" ~ n ~ "]/callsign");
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/font", "courier-bold.txf");
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/character-size", 0.003);
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/character-aspect-ratio", 1.5);
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/font-resolution/width", 32);
		setprop(location ~ "text[" ~ (86 + (n * 3)) ~ "]/font-resolution/height", 32);

		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/name", "ai"~ (n+1) ~"text");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/offsets/x-m", 0.0001);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/offsets/y-m", 0.005);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/offsets/z-m", -0.0462);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/alignment", "left-center");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/axis-alignment", "yz-plane");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/type", "text-value");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/format", "%s");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/property", "instrumentation/aitcas/ai[" ~ n ~ "]/altitude-ft");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/font", "courier-bold.txf");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/character-size", 0.003);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/character-aspect-ratio", 1.5);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/font-resolution/width", 32);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 1) ~ "]/font-resolution/height", 32);

		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/name", "ai"~ (n+1) ~"text");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/offsets/x-m", 0.0001);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/offsets/y-m", 0.005);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/offsets/z-m", -0.0484);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/alignment", "left-center");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/axis-alignment", "yz-plane");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/type", "text-value");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/format", "%s");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/property", "instrumentation/aitcas/ai[" ~ n ~ "]/tas-kt");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/font", "courier-bold.txf");
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/character-size", 0.003);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/character-aspect-ratio", 1.5);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/font-resolution/width", 32);
		setprop(location ~ "text[" ~ ((86 + (n * 3)) + 2) ~ "]/font-resolution/height", 32);

		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/type", "material");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/object-name", "ai"~(n+1)~"text");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/object-name", "ai"~(n+1)~"down");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/object-name", "ai"~(n+1)~"up");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/object-name", "ai"~(n+1)~"level");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/condition/equals/property", "instrumentation/aitcas/ai["~ n ~"]/color");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/condition/equals/value", "red");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/condition/diffuse/red", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/condition/diffuse/green", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/condition/diffuse/blue", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/condition/emission/red", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/condition/emission/green", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 4) ~ "]/condition/emission/blue", 0);

		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/type", "material");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/object-name", "ai"~(n+1)~"text");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/object-name", "ai"~(n+1)~"down");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/object-name", "ai"~(n+1)~"up");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/object-name", "ai"~(n+1)~"level");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/condition/equals/property", "instrumentation/aitcas/ai["~ n ~"]/color");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/condition/equals/value", "orange");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/condition/diffuse/red", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/condition/diffuse/green", 0.5);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/condition/diffuse/blue", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/condition/emission/red", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/condition/emission/green", 0.5);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 5) ~ "]/condition/emission/blue", 0);

		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/type", "material");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/object-name", "ai"~(n+1)~"text");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/object-name", "ai"~(n+1)~"down");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/object-name", "ai"~(n+1)~"up");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/object-name", "ai"~(n+1)~"level");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/condition/equals/property", "instrumentation/aitcas/ai["~ n ~"]/color");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/condition/equals/value", "yellow");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/condition/diffuse/red", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/condition/diffuse/green", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/condition/diffuse/blue", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/condition/emission/red", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/condition/emission/green", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 6) ~ "]/condition/emission/blue", 0);

		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/type", "material");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/object-name", "ai"~(n+1)~"text");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/object-name", "ai"~(n+1)~"down");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/object-name", "ai"~(n+1)~"up");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/object-name", "ai"~(n+1)~"level");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/condition/equals/property", "instrumentation/aitcas/ai["~ n ~"]/color");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/condition/equals/value", "cyan");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/condition/diffuse/red", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/condition/diffuse/green", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/condition/diffuse/blue", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/condition/emission/red", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/condition/emission/green", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 7) ~ "]/condition/emission/blue", 1);

		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/type", "rotate");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/object-name", "ai"~(n+1)~"text");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/object-name", "ai"~(n+1)~"down");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/object-name", "ai"~(n+1)~"up");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/object-name", "ai"~(n+1)~"level");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/property", "instrumentation/aitcas/ai["~ n ~"]/bearing-defl");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/factor", 0.85);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/axis/x", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/axis/y", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/axis/z", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/center/x-m", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/center/y-m", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 8) ~ "]/center/z-m", -0.0466);

		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 9) ~ "]/type", "translate");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 9) ~ "]/object-name", "ai"~(n+1)~"text");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 9) ~ "]/object-name", "ai"~(n+1)~"down");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 9) ~ "]/object-name", "ai"~(n+1)~"up");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 9) ~ "]/object-name", "ai"~(n+1)~"level");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 9) ~ "]/property", "instrumentation/aitcas/ai["~ n ~"]/distance-nm");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 9) ~ "]/factor", 0.00366696);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 9) ~ "]/axis/x", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 9) ~ "]/axis/y", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 9) ~ "]/axis/z", 1);

		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/type", "rotate");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/object-name", "ai"~(n+1)~"text");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/object-name", "ai"~(n+1)~"down");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/object-name", "ai"~(n+1)~"up");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/object-name", "ai"~(n+1)~"level");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/property", "instrumentation/aitcas/ai["~ n ~"]/bearing-defl");
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/factor", -0.85);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/axis/x", 1);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/axis/y", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/axis/z", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/center/x-m", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/center/y-m", 0);
		setprop(location ~ "animation[" ~ ((329 + (n * 11)) + 10) ~ "]/center/z-m", -0.0466);

	}    

	io.write_properties(filename, location);

}
