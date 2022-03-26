$	INQUIRE WDBG "Debug"
$	DBG:=""
$	IF WDBG THEN DBG:="/DEBUG"
$	link'dbg'/exe=ltekci/map=ltekci -
TEKCI,TEKCMD,PICL, -
WOSPLIB/include=(LSCB,LSCH,LCOD)/LIB, -
LSL$LIBRARY:cmdlib/lib, -
LSL$LIBRARY:VIOLIB/LIB
$	pl ltekci.*
$ nolnk: pl *.obj
$	set nover
