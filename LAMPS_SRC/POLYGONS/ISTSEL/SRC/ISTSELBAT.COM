$	set nover
$	on control_Y then goto ISTSELEX
$	ws = "write sys$output"
$!
$	set noon
$	set nover
$	set VERifY
$	set nover
$	ws ""
$	ws "------------------------LINKING................"
$	set VERifY
$	LINK/MAP/EXE=ISTSEL HERE:ISTSEL,-
		ISTSEL_CLD,STRSUB, -
		SEGSEL,ACSORT,CMDLIN,-
		COPY_STRING,POL_DEF, -
		ISTSEL.PROMSG_OBJ, -
		LSL$LIBRARY:ifFSHR/OPT,-
		LSL$LIBRARY:LSLSHR/OPT
$	ISTSELEX:
$	set NOVER
