$	VER=F$VERIFY(0)
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!MOD	Changed build directory for CMS			ST  27-Jul-1993
$!	and NEWMESSAGE to NEWMSG
$!MOD	Uses shareable library images			JMB 30-Nov-1987
$!MOD	Newmessage F(ortran) option addded		ATT 14-Jan-1987
$!MOD	Option to link with experimental LSLLIB		TJH 03-Nov-1986
$!	Created						TJH 29-Jan-1986
$!
$! Command file for building ILAYFC
$!
$	ON ERROR THEN GOTO ILAYFCEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$ILAYFC_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO ILAYFCEX
$	DEFINE/GROUP LSL$ILAYFC_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL ILAYFCBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO ILAYFCEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$ILAYFC_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$ILAYFC_BUILDING ""IN_PROGRESS"""
$	WC	"$	ASSIGN LSL$SOURCE_ROOT:[IMP.ILAYFC.SRC] LSL$CMNILAYFC"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP ILAYFC_DBG "With Debug ? "
$	IF .NOT. ILAYFC_DBG THEN GOTO A04
$	   FSW1="/DEBUG"
$	   MLDBG="/DEBUG"
$	   INQUIRE/NOP ANSWER "Without optimisation ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/NOOPT"
$	   INQUIRE/NOP ANSWER "Check bounds and overflow ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/CHECK=(BOUNDS,OVERFLOW)"
$	   INQUIRE/NOP ANSWER "With listings ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/LIST"
$	   INQUIRE/NOP ANSWER "Keep FORtran sources with comments ? "
$	   IF ANSWER THEN KPCOM="/CO"
$ A04:
$	   INQ/NOP CLD "Compile CLD module ? "
$	   IF .NOT.COMPILE THEN GOTO A11
$!
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="ILAYFC"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="ILAYFCX"
$!
$	   EXPLSL="LSL$LIBRARY:LSLSHR/OPT"
$!
$	   LINKOPTS="/MAP"
$	   INQUIRE/NOP ANSWER "Link with debug ? "
$	   IF ANSWER THEN LINKOPTS=LINKOPTS+"/DEBUG"
$!
$	   INQUIRE/NOP ANSWER "Cross reference map ? "
$	   IF ANSWER THEN LINKOPTS=LINKOPTS+"/CROSS"
$	   
$ NOTKB:
$!
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		SET VERIFY"
$ 		IF .NOT. MES THEN GOTO NOMESS
$		WC "$	NEWMSG ILAYFC.MES/NUM=1213/NAME=ILAYFC/PRE=ILAYFC__/PAR=FOR"
$		WC "$	@ILAYFC.TEMP_COM"
$ NOMESS:   IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC ILAYFC.TMP=ILAYFC.CLD"
$		WC "$ 		SET COMMAND/OBJECT=ILAYFC_CLD ILAYFC.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ILAYFC_CLD"
$	      	WC "$ 		DELETE ILAYFC.TMP;*"	
$		WC "$		PURGE/NOLOG ILAYFC_CLD.OBJ"
$	      	WC "$ 		OK=$STATUS"	
$!	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$!
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC ILAYFC''KPCOM'=ILAYFC"
$	   	WC "$ 		FORT''FSW1' ILAYFC"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ILAYFC"
$		WC "$ 		PURGE/NOLOG ILAYFC.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE ILAYFC.FOR;*"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG ILAYFC.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ILAYFC.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$	   	WC "$ 		LINK''LINKOPTS'/EXE=''LINKVER' ILAYFC, -"
$	   	WC "		ILAYFC_CLD, ILAYFC.PROMSG_OBJ, -"
$	   	WC "		LSL$LIBRARY:IFFSHR/OPT,''EXPLSL'"
$!
$ NOLNK:
$		WC "$ 		ILAYFCEX:"
$		WC "$ 		DEASS/GROUP LSL$ILAYFC_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO ILAYFCEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$ILAYFC_BUILDING
$	BAT ILAYFCBAT.COM
$	GOTO ILAYFCX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO ILAYFCEX
$	DEASS/GROUP LSL$ILAYFC_BUILDING
$	@ILAYFCBAT.COM
$	GOTO ILAYFCX2
$ ILAYFCEX:
$	DEASS/GROUP LSL$ILAYFC_BUILDING
$ ILAYFCX2:
$	IF VER THEN SET VERIFY
