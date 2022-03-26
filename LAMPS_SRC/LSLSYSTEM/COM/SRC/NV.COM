$	V='f$verify(0)'
$! Copyright Laser-Scan Laboratories Ltd, Cambridge, England
$! Author					RF	1979
$! Rehashed for explicit version numbers	PGH/JMB	16-Dec-1988
$!
$! Procedure for edit, then set date, then purge
$! Example is   $ NV FRED.SRC
$! 		$ NV FRED.SRC R		! Recover edits
$!
$	if P1.eqs."" then inquire P1 "File"
$	if P1.eqs."" then goto tidy_ver
$	initial_file=f$search(p1)
$	if initial_file.nes."" then goto A10
$	  write sys$output p1," does not exist"
$	  goto tidy_ver
$A10:	no_version=f$element(0,";",initial_file)
$	highest_version=f$search(no_version)
$	if highest_version.eqs."" then write sys$output "NV internal errror"
$	initial_vn=f$parse(highest_version,,,"VERSION")
$	RECSW=""
$	if P2 .eqs. "R" then RECSW="/REC"
$	define/user	sys$input	sys$command:
$	ced'recsw' 'p1'
$	final_file=f$search(no_version)
$	if initial_vn.eqs.f$parse(final_file,,,"version") then goto tidy_ver
$	if P2 .nes. "" .and. P2 .nes. "R" then PURGE/KEEP='P2' ''no_version'
$	if P2 .eqs. "" then PURGE 'no_version'
$	extn=f$parse(p1,,,"TYPE")
$	if extn.eqs.".MAC" .or. extn.eqs.".MAR" .or. -
	   extn.eqs.".SRC" .or. extn.eqs.".PAS" .or. -
	   extn.eqs.".C"   .or. extn.eqs.".CLD" .or. -
	   extn.eqs.".FOR" .or. extn.eqs.".F"   then pid 'no_version'
$tidy_ver: if v then set verify
