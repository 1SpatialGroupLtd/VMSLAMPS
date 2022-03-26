$	ver:='f$verify(0)'
$	forupold:='forup'.old 
$	type sys$input:
This file tests FORUP against its old version in FORUP.OLD

A successful test will produce no errors from the DIFF command
$
$	open/write tf xxx.src
$	write tf "	provram zloty"
$	write tf "c"
$	write tf "c this Program tests FORUP"
$	write tf "C splot"
$	write tf "c"
$	write tf "	here we are again"
$	write tf "	happy ! as can be"
$	write tf "	'all' good friends"
$	write tf "	'AND' jolly good"
$	write tf "	company ! COMPANY"
$	write tf "c"
$	write tf "	end"
$	close tf
$	set verify
$	copy xxx.src yyy.src
$	forup xxx
$	forupold yyy
$	diff xxx.src yyy.src
$	xxx:='f$verify(0)'
$	inquire/nop maybe "Delete testing files ? "
$	if maybe then delete/log xxx.src;*,yyy;*
$	if ver then set verify
