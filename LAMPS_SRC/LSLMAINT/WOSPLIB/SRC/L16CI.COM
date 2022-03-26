$	INQUIRE WDBG "Debug"
$	DBG:=""
$	IF WDBG THEN DBG:="/DEBUG"
$	link'dbg'/exe=L16CI/map=L16CI -
TEKCI,TEKCMD,PICL, -
WOSPLIB/include=(LSCB,LCVG16,LSCH,LCOD16)/LIB, -
LSL$LIBRARY:cmdlib/lib, -
LSL$LIBRARY:VIOLIB/LIB
$	pl l16ci.*
$ nolnk: pl *.obj
$	set nover
