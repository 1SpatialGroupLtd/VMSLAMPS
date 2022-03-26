$	ver:='f$verify(0)'
$	if p1 .nes. "?" then goto noqueer
$	type sys$input:
Available switches are:-

 C - re-compile, code-generate, and assemble
 T - include TITS in link
 Z - switch ignored, so you can put in a :

Second argument is EXTTSK parameter, so that one says
	@BCPL C 20000
 (for example - default is 14000)
$	goto tidy_ver
$noqueer: if f$search("rsxhdr").nes."" then goto hdr_ok
$	if f$logical("rsxhdr").eqs."" then -
		assign 'f$logical("lsl$library")'rsxhdr rsxhdr
$hdr_ok: if f$locate("C",p1) .ge. f$length(p1) then goto tbonly
$	set verify
$	MCR BPL LST
$	MCR ACG LST
$	DELETE LST.OCD;*
$	MAC/RSX LST
$	DELETE LST.MAC;*
$	xxx:='f$verify(0)'
$tbonly: XXX=F$SEARCH("LST.TKB")
$	IF XXX.EQS."" THEN GOTO NO_TKB
$	TKBEXISTS=1
$	GOTO TASK_BUILD
$NO_TKB: OPEN/WRITE TKBFILE LST.TKB
$	WRITE TKBFILE "LST.EXE,LST/-SP=LSL$LIBRARY:BCPLIB"
$	WRITE TKBFILE "''F$LOGICAL("SYS$DISK")'''F$DIR()'LST"
$	IF f$locate("T",p1) .lt. f$length(p1) THEN -
		WRITE TKBFILE "LSL$LIBRARY:TITS/DA"
$	WRITE TKBFILE "/"
$	WRITE TKBFILE "TASK=...LST"
$	WRITE TKBFILE "UNITS=7"
$	WRITE TKBFILE "EXTSCT=$$FSR1:6400"
$	if p2 .eqs. "" then p2:=14000
$	WRITE TKBFILE "EXTTSK=",p2
$	WRITE TKBFILE "ASG=SY:5:6"
$	WRITE TKBFILE "//"
$	CLOSE TKBFILE
$	TKBEXISTS=0
$TASK_BUILD: ON ERROR THEN GOTO BCPL_TIDY
$	set verify
$	TKB @LST.TKB
$BCPL_TIDY: xxx:='f$verify(0)'
$	set verify
$	PURGE/LOG LST.*
$	xxx:='f$verify(0)
$	IF TKBEXISTS THEN GOTO TIDY_VER
$	set verify
$	DELETE LST.TKB;*
$	xxx:='f$verify(0)'
$tidy_ver: if ver then set verify
