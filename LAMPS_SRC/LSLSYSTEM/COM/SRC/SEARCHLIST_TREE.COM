$!
$! SEARCHLIST_TREE.COM - procedure to generate a command file containing
$! search lists pointing through all available appropriate directories
$! on the LSL public software distribution tree (LSL$PUBLIC_ROOT)
$! This can then be edited into the system startup command files.
$!
$! Created					PGH	12-Sep-1986
$! LSL$LOOKUP added				PGH	18-Mar-1986
$!
$	ws="write sys$output"
$	wc="write command"
$	create pubsearch.com	! so that it is standard text file format
$	open/append command pubsearch.com
$!
$	directory_type="COM"
$	logical_name="COM"
$	gosub search_for_directories
$	directory_type="EXE"
$	logical_name="EXE"
$	gosub search_for_directories
$	directory_type="LIB"
$	logical_name="LIBRARY"
$	gosub search_for_directories
$	directory_type="HELP"
$	logical_name="HELP"
$	gosub search_for_directories
$	directory_type="LOOKUP"
$	logical_name="LOOKUP"
$	gosub search_for_directories
$!
$	close command
$	purge pubsearch.com
$	exit
$!
$! subroutine to generate search list for a particular directory type
$!
$search_for_directories:
$	ws "$!"
$	wc "$!"
$	ws "$! Set up search list for public tree .''directory_type directories"
$	wc "$! Set up search list for public tree .''directory_type directories"
$	ws "$!"
$	wc "$!"
$	ws "$	Define/System	LSL$",logical_name,"	-"
$	wc "$	Define/System	LSL$",logical_name,"	-"
$	directory/out=pubsearch.tmp/col=1/nohead/notrail -
		lsl$public_root:[*]'directory_type'.dir
$	open/read listing pubsearch.tmp
$	previous_line="		LSL$SITE_ROOT:[LSL.''directory_type']"
$next_line:
$	read/end=no_more listing line
$	previous_line=previous_line+",-"
$	ws previous_line
$	wc previous_line
$	line=line-"]''directory_type'.DIR;1"
$	line="		"+line+".''directory_type']"
$	previous_line=line
$	goto next_line
$no_more:
$	ws previous_line
$	wc previous_line
$	close listing
$	delete pubsearch.tmp;*
$	return
