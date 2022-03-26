$	INQUIRE WDBG "Debug"
$	DBG:=""
$	IF WDBG THEN DBG:="/DEBUG"
$	link'dbg'/exe=L14CI/map=L14CI -
TEKCI,TEKCMD,PICL, -
WOSPLIB/include=(LSCB,LCVG14,LSCH,LCOD14)/LIB, -
LSL$LIBRARY:cmdlib/lib, -
LSL$LIBRARY:VIOLIB/LIB
$	pl l14ci.*
$ nolnk: pl *.obj
$	set nover
