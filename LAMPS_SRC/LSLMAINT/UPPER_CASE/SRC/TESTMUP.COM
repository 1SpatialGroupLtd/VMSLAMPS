$	ver:='f$verify(0)'
$	marupold:='marup'.old 
$	type sys$input:
This file tests MARUP against its old version in MARUP.OLD

A successful test will produce no errors from the DIFF command
$
$	open/write tf xxx.mar
$	write tf "	.title	zloty"
$	write tf ";"
$	write tf "; this Program tests marup"
$	write tf "; splot"
$	write tf "	here we are again"
$	write tf "	happy ; as can be"
$	write tf "	'all' good friends"
$	write tf "	'AND' jolly good"
$	write tf "	company ; COMPANY"
$	write tf ";"
$	write tf "	.end"
$	close tf
$	set verify
$	copy xxx.mar yyy.mar
$	marup xxx
$	marupold yyy
$	diff xxx.mar yyy.mar
$	xxx:='f$verify(0)'
$	inquire/nop maybe "Delete testing files ? "
$	if maybe then delete/log xxx.mar;*,yyy;*
$	if ver then set verify
