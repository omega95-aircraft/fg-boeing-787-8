################################################################################
#
# Boeing 787-8 FMC Automatic Word Completion
#-------------------------------------------------------------------------------
#
# fmcHelp.parseWords - parses the Possible_Words.xml file and moves to Help Tree
# fmcHelp.search - searchs the Help tree for the word (the word starts with inp)
# fmcHelp.
#-------------------------------------------------------------------------------
#
# There is VERY less documentation on this new feature, and the current instrum-
# ent has been modeled based off information from Smart Cockpit. Once we get be-
# tter documentation, we'll probably make this better.
#
# To increase the computer's "Vocabulary", add in words to Possible_Words.xml
#
################################################################################

var fmcHelp = {

	parseWords : func() {
		
		var root = getprop("/sim/aircraft-dir");
		
		io.read_properties(root ~ "/FMC-DB/Vocabulary/Possible_Words.xml", "/instrumentation/fmcVocabulary/");
		
		sysinfo.log_msg("[FMC] Vocabulary Check ... OK", 0);
	
	},
	search : func(cdu, input) {
	
		var fh_tree = "/instrumentation/fmcHelp[" ~ cdu ~ "]/";
		var vocab = "/instrumentation/fmcVocabulary/words/";
		
		# Clear Result fields
		
		for (var n = 0; n < 8; n += 1) {
		
			setprop(fh_tree~ "result[" ~ n ~ "]/string", "");
		
		}
		
		var inp_size = size(input);
		
		# There're 8 available search result spaces
		
		var result = 0;
		
		for (var n = 0; getprop(vocab ~ "word[" ~ n ~ "]/string") != nil; n += 1) {
		
			if (substr(getprop(vocab~ "word[" ~ n ~ "]/string"), 0, inp_size) == input) {
			
				setprop(fh_tree~ "result[" ~ result ~ "]/string", getprop(vocab~ "word[" ~ n ~ "]/string"));				
				
				result += 1;
			
			}
		
		}
		
		setprop(fh_tree~ "first", 0);
		
		me.update(cdu);
	
	},
	select : func(cdu, index) {
		
		var fh_tree = "/instrumentation/fmcHelp[" ~ cdu ~ "]/";
		
		setprop("/controls/cdu[" ~ cdu ~ "]/input", getprop(fh_tree~ "result[" ~ index ~ "]/string"));
	
	},
	update : func(cdu) {
	
		var first = getprop("/instrumentation/fmcHelp[" ~ cdu ~ "]/first");
		
		for (var n = 0; n < 8; n += 1) {
		
			var result = getprop("/instrumentation/fmcHelp[" ~ cdu ~ "]/result[" ~ (n + first) ~ "]/string");
			
			if (result != nil)
				setprop("/instrumentation/fmcHelp[" ~ cdu ~ "]/disp[" ~ n ~ "]/string", result);
		
		}
	
	}

};
