$	ws = "write sys$output"
$	SET noverify
$	on control_Y then goto srinormEX
$	if "''F$LOGICAL("LSL$srinorm_BUILDING")'" -
		 .nes. "IN_PROGRESS" then goto A0
$	ws "Someone else is building"
$	exit
$!
$A0:	DEFINE/GROUP LSL$srinorm_BUILDING "IN_PROGRESS"
$	ASSIGN LSL$SOURCE_ROOT:[MAPPING.FRTLIB.srinorm] LSL$CMNsrinorm
$	SET NOon
$	SET verify
$	NEWMSG srinorm/number=1186
$	@srinorm.TEMP_COM
$	ADC srinorm.TMP=srinorm.CLD
$	SET COMMAND/OBJECT=srinorm_cld srinorm.TMP
$	OK=$STATUS
$	if OK then PVV srinorm_cld
$	DELETE srinorm.TMP;*
$	PURGE/NOLOG srinorm_cld.OBJ
$	OK=$STATUS
$	SET noverify
$	ws "-----------------COMPILE--------"
$	SET verify
$	ADC srinorm=srinorm
$	FORT srinorm
$	OK=$STATUS
$	if OK then PVV srinorm
$	PURGE/NOLOG srinorm.OBJ
$	DELETE srinorm.FOR;*
$	DELETE ADC.IDE;*
$	SET noverify
$	ws "---------------LINK........."
$	SET verify
$	link/MAP/CROSS/exe=srinorm srinorm,-
 srinorm_cld,srinorm.PROMSG_OBJ, -
 LSL$LIBRARY:IFFSHR/OPT,LSLSHR/OPT
$	srinormEX:
$	DEASS/GROUP LSL$srinorm_BUILDING
$	SET NOVER
