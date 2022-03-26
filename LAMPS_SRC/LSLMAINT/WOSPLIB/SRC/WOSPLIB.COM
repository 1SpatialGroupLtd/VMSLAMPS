$	INQUIRE ALL "All"
$	IF .NOT. ALL THEN GOTO W_ASK
$	DEB = ""
$	DDC = 1
$	BS  = 1
$	VG  = 1
$	OD  = 1
$	NL  = 1
$	IP  = 1
$	RF  = 1
$	LC  = 1
$	NEWL = 1
$	GOTO W_MAC
$!
$ W_ASK:
$	INQUIRE DEB "With debug"
$	if DEB then dbg = "/debug"
$	if DEB then mdbg = "/debug"
$	INQUIRE DDC "TDDC02,TSCB02 & TKDDCG,DSUBST,DREPT"
$	INQUIRE BS  TKBS
$	INQUIRE IP  TKIP
$	INQUIRE NL  TKNL
$	INQUIRE OD  TKOD
$	INQUIRE RF  TKRF
$	INQUIRE VG  TKVG
$	INQUIRE LC  LSCH
$	INQUIRE NEWL "New Library"
$!
$ W_MAC: ON CONTROL_Y THEN EXIT
$	REPM = .NOT. NEWL
$	SET NOON
$	SET VER
$	if .not. ddc then goto w_mac1
$	adc tkddcg=tkddcg,drept,substt
$	fort'dbg'/noi4 tkddcg
$	pvv tkddcg
$	if .not. DEB then delete tkddcg.for;*
$	delete adc.ide;*
$	mac'mdbg'/obj=tscb tkhd02+thkpar+tkddcp+tkws02+tkvw02+tscb02
$	mac'mdbg'/obj=tddc tkhd02+thkpar+tkddcp+tkws02+tkvw02+tddc02
$	mac'mdbg'/obj=dsubst tkhd02+tkddcp+dsubst
$	mac'mdbg'/obj=lscb tkhd02+tkws02+lscb02
$	if .not. newl then libr/repl/log wosplib tkddcg,tddc,dsubst,tscb
$	if .not. newl then libr/repl/noglobals/log wosplib lscb
$ w_mac1: if bs then mac'mdbg'/obj=tkbs tkhd02+tkws02+tkvw02+tkbs02
$	if bs .and. repm then libr/repl/log wosplib tkbs
$	if vg then mac'mdbg'/obj=tkvg tkhd02+tkvw02+tkws02+tkvg02
$	if vg then mac'mdbg'/obj=lcvg14 -
			lc1402+lchd02+tkhd02+tkvw02+tkws02+tkvg02
$	if vg then mac'mdbg'/obj=lcvg16 -
			lc1602+lchd02+tkhd02+tkvw02+tkws02+tkvg02
$	if vg .and. repm then libr/repl/log wosplib tkvg
$	if vg .and. repm then libr/repl/log/noglobals  wosplib lcvg14
$	if vg .and. repm then libr/repl/log/noglobals  wosplib lcvg16
$!
$	if od then mac'mdbg'/obj=tkod -
			tkhd02+tkiw02+tkrw02+tkvw02+tkws02+tkod02
$	if od then mac'mdbg'/obj=lcod -
			lchd02+tkhd02+tkiw02+tkrw02+tkvw02+tkws02+tkod02
$	if od then mac'mdbg'/obj=lcod14 -
		lc1402+lchd02+tkhd02+tkiw02+tkrw02+tkvw02+tkws02+tkod02
$	if od then mac'mdbg'/obj=lcod16 -
		lc1602+lchd02+tkhd02+tkiw02+tkrw02+tkvw02+tkws02+tkod02
$	if od then mac'mdbg'/obj=lvu_od -
		lvu_02+lchd02+tkhd02+tkiw02+tkrw02+tkvw02+tkws02+tkod02
$	if od .and. repm then libr/repl/log wosplib tkod
$	if od .and. repm then libr/repl/log/noglobals wosplib lcod
$	if od .and. repm then libr/repl/log/noglobals wosplib lcod14
$	if od .and. repm then libr/repl/log/noglobals wosplib lcod16
$	if od .and. repm then libr/repl/log/noglobals wosplib lvu_od
$!
$	if nl then mac'mdbg'/obj=tknl tkhd02+tknl02
$	if nl .and. repm then libr/repl/log wosplib tknl
$!
$	if ip then mac'mdbg'/obj=tkip -
		tkhd02+tkiw02+tkrw02+tkvw02+tkws02+tkip02
$	if ip then mac'mdbg'/obj=lvu_ip -
		lvu_02+tkhd02+tkiw02+tkrw02+tkvw02+tkws02+tkip02
$	if ip .and. repm then libr/repl/log wosplib tkip
$	if ip .and. repm then libr/repl/log/noglobals wosplib lvu_ip
$!
$	if rf then mac'mdbg'/obj=tkrf -
		tkhd02+tkrw02+tkiw02+tkvw02+tkws02+tkrf02
$	if rf .and. repm then libr/repl/log wosplib tkrf
$!
$	if lc then mac'mdbg'/obj=lsch -
		lchd02+tkhd02+lscw02+tkws02+lsch02
$	if lc .and. repm then libr/repl/log wosplib lsch
$!
$	if repm then goto w_lnk
$	library/create=blocks:30 wosplib tkddcg,tddc,dsubst,tscb,-
				 tkbs,tkip,tknl,tkod,tkrf,tkvg
$	libr/insert/noglobals wosplib lscb,lsch,lcod,lcod14,lcod16,lvu_od,-
				      lcvg14,lcvg16
$	pl wosplib.olb,*.obj
$!
$ w_lnk: set nover
$!
