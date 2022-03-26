$	WS="WRITE SYS$OUTPUT"
$ 	SET NOVERIFY
$	ON CONTROL_Y THEN GOTO IRECODEEX
$	IF "''F$LOGICAL("LSL$IRECODE_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WS "Someone else is building"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$IRECODE_BUILDING "IN_PROGRESS"
$	ASSIGN LSL$SOURCE_ROOT:[IMP.IRECODE.SRC] LSL$CMNIRECODE
$	SD:=$LSL$SYS:SD
$	SET NOON
$	SET VERIFY
$	SET NOVER
$	WS " "
$	WS ".----------------------------------------------."
$	WS "|        GENERATING MESSAGE DEFINITIONS        |"
$	WS "`----------------------------------------------'"
$	WS " "
$	SET VER
$	NEWMSG IRECODE/number = 1206
$	@IRECODE.temp_com
$	WS " "
$	WS ".----------------------------------------------."
$	WS "|        COMPILING COMMAND LINE MODULE         |"
$	WS "`----------------------------------------------'"
$	WS " "
$	ADC IRECODE.TMP=IRECODE_CLD.CLD
$	SET COMMAND/OBJECT=IRECODE_CLD IRECODE.TMP
$	OK=$STATUS
$	IF OK THEN PVV IRECODE_CLD
$	OK=$STATUS
$ SET NOVERIFY
$ WS " "
$ WS ".---------------------------------.
$ WS "|                                 |"
$ WS "| .-- .--. .-. .-. +-. +  .   .-- |"
$ WS "| |   |  | |  V  | |-' |  |   +-  |"
$ WS "| `-- `--' '     ` '   +  `-- `-- |"
$ WS "|                                 |"
$ WS "| ~-_-~~-_-~~-_-~~-_-~~-_-~~-_-~~ |"
$ WS "`---------------------------------'
$ WS " "
$	set ver
$	ADC OBEY'KPCOM'=OBEY
$	FORT OBEY
$	OK = $STATUS
$	set nover
$	IF .NOT. OK THEN goto COMP_ERR
$	PVV OBEY
$	PURGE/NOLOG OBEY.OBJ
$	DELETE/NOLOG OBEY.FOR;*
$	DELETE ADC.IDE;*
$ WS " "
$ WS ".---------------------------------.
$ WS "|       compilation finished      |"
$ WS "`---------------------------------'
$ WS " "
$ SET NOVERIFY
$ WS " "
$ WS ".---------------------------------.
$ WS "|                                 |"
$ WS "| .-- .--. .-. .-. +-. +  .   .-- |"
$ WS "| |   |  | |  V  | |-' |  |   +-  |"
$ WS "| `-- `--' '     ` '   +  `-- `-- |"
$ WS "|                                 |"
$ WS "| ~-_-~~-_-~~-_-~~-_-~~-_-~~-_-~~ |"
$ WS "`---------------------------------'
$ WS " "
$	set ver
$	ADC PROMPT'KPCOM'=PROMPT
$	FORT PROMPT
$	OK = $STATUS
$	set nover
$	IF .NOT. OK THEN goto COMP_ERR
$	PVV PROMPT
$	PURGE/NOLOG PROMPT.OBJ
$	DELETE/NOLOG PROMPT.FOR;*
$	DELETE ADC.IDE;*
$ WS " "
$ WS ".---------------------------------.
$ WS "|       compilation finished      |"
$ WS "`---------------------------------'
$ WS " "
$ SET NOVERIFY
$ WS " "
$ WS ".---------------------------------.
$ WS "|                                 |"
$ WS "| .-- .--. .-. .-. +-. +  .   .-- |"
$ WS "| |   |  | |  V  | |-' |  |   +-  |"
$ WS "| `-- `--' '     ` '   +  `-- `-- |"
$ WS "|                                 |"
$ WS "| ~-_-~~-_-~~-_-~~-_-~~-_-~~-_-~~ |"
$ WS "`---------------------------------'
$ WS " "
$	set ver
$	ADC DECODE'KPCOM'=DECODE
$	FORT DECODE
$	OK = $STATUS
$	set nover
$	IF .NOT. OK THEN goto COMP_ERR
$	PVV DECODE
$	PURGE/NOLOG DECODE.OBJ
$	DELETE/NOLOG DECODE.FOR;*
$	DELETE ADC.IDE;*
$ WS " "
$ WS ".---------------------------------.
$ WS "|       compilation finished      |"
$ WS "`---------------------------------'
$ WS " "
$ SET NOVERIFY
$ WS " "
$ WS ".---------------------------------.
$ WS "|                                 |"
$ WS "| .-- .--. .-. .-. +-. +  .   .-- |"
$ WS "| |   |  | |  V  | |-' |  |   +-  |"
$ WS "| `-- `--' '     ` '   +  `-- `-- |"
$ WS "|                                 |"
$ WS "| ~-_-~~-_-~~-_-~~-_-~~-_-~~-_-~~ |"
$ WS "`---------------------------------'
$ WS " "
$	set ver
$	ADC IRECODE'KPCOM'=IRECODE
$	FORT IRECODE
$	OK = $STATUS
$	set nover
$	IF .NOT. OK THEN goto COMP_ERR
$	PVV IRECODE
$	PURGE/NOLOG IRECODE.OBJ
$	DELETE/NOLOG IRECODE.FOR;*
$	DELETE ADC.IDE;*
$ WS " "
$ WS ".---------------------------------.
$ WS "|       compilation finished      |"
$ WS "`---------------------------------'
$ WS " "
$ SET NOVERIFY
$ WS " "
$ WS ".---------------------------------.
$ WS "|                                 |"
$ WS "| .-- .--. .-. .-. +-. +  .   .-- |"
$ WS "| |   |  | |  V  | |-' |  |   +-  |"
$ WS "| `-- `--' '     ` '   +  `-- `-- |"
$ WS "|                                 |"
$ WS "| ~-_-~~-_-~~-_-~~-_-~~-_-~~-_-~~ |"
$ WS "`---------------------------------'
$ WS " "
$	set ver
$	ADC READ_ALPAIRS'KPCOM'=READ_ALPAIRS
$	FORT READ_ALPAIRS
$	OK = $STATUS
$	set nover
$	IF .NOT. OK THEN goto COMP_ERR
$	PVV READ_ALPAIRS
$	PURGE/NOLOG READ_ALPAIRS.OBJ
$	DELETE/NOLOG READ_ALPAIRS.FOR;*
$	DELETE ADC.IDE;*
$ WS " "
$ WS ".---------------------------------.
$ WS "|       compilation finished      |"
$ WS "`---------------------------------'
$ WS " "
$ SET NOVERIFY
$ WS " "
$ WS ".---------------------------------.
$ WS "|                                 |"
$ WS "| .-- .--. .-. .-. +-. +  .   .-- |"
$ WS "| |   |  | |  V  | |-' |  |   +-  |"
$ WS "| `-- `--' '     ` '   +  `-- `-- |"
$ WS "|                                 |"
$ WS "| ~-_-~~-_-~~-_-~~-_-~~-_-~~-_-~~ |"
$ WS "`---------------------------------'
$ WS " "
$	set ver
$	ADC LOOKUP'KPCOM'=LOOKUP
$	FORT LOOKUP
$	OK = $STATUS
$	set nover
$	IF .NOT. OK THEN goto COMP_ERR
$	PVV LOOKUP
$	PURGE/NOLOG LOOKUP.OBJ
$	DELETE/NOLOG LOOKUP.FOR;*
$	DELETE ADC.IDE;*
$ WS " "
$ WS ".---------------------------------.
$ WS "|       compilation finished      |"
$ WS "`---------------------------------'
$ WS " "
$ SET NOVERIFY
$ WS " "
$ WS ".------------------------------."
$ WS "|                              |"
$ WS "| .   + .-. . . / + .-. . .--. |"
$ WS "| |   | |  \| |<  | |  \| |  | |"
$ WS "| `-- + '   ` ' ` + '   ` `--; |"
$ WS "|                      `----~  |"
$ WS "| ~-_-~~-_-~~-_-~~-_-~~-_-~~-_ |"
$ WS "`------------------------------'"
$ WS " "
$	set ver
$	LINK/MAP/EXE=IRECODE IRECODE, -
	IRECODE_CLD, OBEY, PROMPT, DECODE , READ_ALPAIRS, LOOKUP, -
	IRECODE.PROMSG_OBJ, -
	lsl$library:iffSHR/OPT, -
	LSL$LIBRARY:LSLSHR/OPT, -
	LSL$LIBRARY:LSLLIB/include=DCL_ERRET, -
	SYS$INPUT:/opt
	psect_attr=LSL_REPORT,noshr
$IF OK THEN goto IRECODEEX
$COMP_ERR:
$	SET NOVER
$ WS "  "
$ WS ".-------------------------."
$ WS "| .-- .--. .--. .--. .--. |"
$ WS "| |   |  | |  | |  | |  | |"
$ WS "| +-  |_.' |  | |_.' |_.' |"
$ WS "| |   | \  |  | | \  | \  |"
$ WS "| `-- '  ` `--' '  ` '  ` |"
$ WS "`-------------------------'"
$ WS "  "
$!
$IRECODEEX:
$	DEASS/GROUP LSL$IRECODE_BUILDING
$	SET NOVER
$ WS "  "
$ WS ".------------------------------."
$ WS "|           all done           |"
$ WS "`------------------------------'"
$ WS "  "
