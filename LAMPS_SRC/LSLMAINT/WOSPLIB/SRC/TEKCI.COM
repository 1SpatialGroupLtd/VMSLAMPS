$	INQUIRE WDBG "Debug"
$	DBG:=""
$	IF WDBG THEN DBG:="/DEBUG"
$	INQUIRE TEK "Tekci"
$	INQUIRE PIC "Picl,Cspeed,Chtest"
$	INQUIRE	WLNK "Link"
$	SET VER
$	if .not. TEK then goto NOTEK
$	mac tekcmd
$	adc tekci=tekci
$	fort'dbg'/noi4 tekci
$	pvv tekci
$	del tekci.for;*,adc.ide;*
$ NOTEK: if .not. PIC then goto NOPIC
$	adc picl=picl,cspeed,chtest
$	fort'dbg'/noi4 picl
$	pvv picl
$	del picl.for;*,adc.ide;*
$ NOPIC: if .not. WLNK then goto nolnk
	link'dbg'/map -
TEKCI,TEKCMD,PICL, -
WOSPLIB/INCLUDE=(LSCH)/LIB, -
LSL$LIBRARY:cmdlib/lib, -
LSL$LIBRARY:VIOLIB/LIB
$	pl tekci.*
$ nolnk: pl *.obj
$	set nover
$!
