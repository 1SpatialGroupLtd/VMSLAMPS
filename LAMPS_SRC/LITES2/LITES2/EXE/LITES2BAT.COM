$	ASSIGN EXE:LITES2TR.MAR TR
$	set def LSL$LITES2_ROOT:[OBJ]
$	assign/tran=(c,t) DNFS1:[000000.LITES2.LITES2.V5_1.] LSL$LITES2_ROOT
$	assign LSL$LITES2_ROOT:[OBJ] OBJ
$	assign LSL$LITES2_ROOT:[EXE] EXE
$	assign LSL$LITES2_ROOT:[SRC] SRC
$	assign LSL$LITES2_ROOT:[MAR] MAR
$	assign LSL$LITES2_ROOT:[CMN] CMN
$	assign LSL$LITES2_ROOT:[COM] COM
$	assign LSL$SOURCE_ROOT:[LITES2.GEN] GEN
$	set noon
$!  ++++++++++++++++++  Init   ++++++++++++++++++
$	ADC INIT/CD:CMN:=TR:/TR,SRC:INIT,WRTVER,EXCEPTION,LITES2_SCROLL
$	ADC INIT/AP/CD:CMN:=TR:/TR,SRC:TWOEXH,TWOPUT,CTRLCAST,HADCTRLC
$	ADC INIT/AP/CD:CMN:=TR:/TR,SRC:AUXACT,SERVAUX,STRTAUX,AUXOFF,QIOUP
$	ADC INIT/AP/CD:CMN:=TR:/TR,SRC:INIZONE,ABORTAST,HADBREAK,TSTENC
$	ADC INIT/AP/CD:CMN:=TR:/TR,SRC:GTDONG,TSTCPU,TSTFAC,LICENSED,VTSTAT
$	ADC INIT/AP/CD:CMN:=TR:/TR,SRC:TRNFLN,DOOSSE,GETROUTINE,GETVERSION
$	FORTRAN/NOLIST INIT
$	DELETE INIT.FOR;*
$	PVV INIT
$	DELETE ADC.IDE;*
$	PURGE INIT.OBJ
$	LIBR/REPLACE LITES2  INIT
$	DELETE INIT.OBJ;*