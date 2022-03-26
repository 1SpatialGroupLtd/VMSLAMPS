$	VER=F$VERIFY(0)
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Use IFFSHR and LSLSHR, use NEWMSG	 CCB	 2-Aug-1989
$!	Change message facility number		 RJH	29-Jul-1987
$!	Created					 TJH	21-Aug-1986
$!
$! Command file for building I2MOSS
$!
$	ON ERROR THEN GOTO I2MOSSEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$I2MOSS_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO I2MOSSEX
$	DEFINE/GROUP LSL$I2MOSS_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL I2MOSSBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO I2MOSSEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$I2MOSS_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$I2MOSS_BUILDING ""IN_PROGRESS"""
$	WC	"$	ASSIGN LSL$SOURCE_ROOT:[CONVERT.I2MOSS] LSL$CMNI2MOSS"
$	WC	"$	SET NOON"
$!
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP I2MOSS_DBG "With Debug ? "
$	IF .NOT. I2MOSS_DBG THEN GOTO A04
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
$	   INQ/NOP CLD "Compile CLD modules ? "
$	   IF .NOT.COMPILE THEN GOTO A11
$!
$	   INQ/NOP EVERYTHING "Compile all FORTRAN sources ? "
$	   IF .NOT. EVERYTHING THEN GOTO A05
$	   CLSFIL="T"
$	   CMDLIN="T"
$	   GETF="T"
$	   GET_CROSS="T"
$	   I2MOSS="T"
$	   IFFBDY="T"
$	   MOSCOD="T"
$	   OUTREC="T"
$	   GOTO A11
$!
$ A05:	   INQ/NOP CLSFIL	"Compile CLSFIL?	"
	   INQ/NOP CMDLIN	"Compile CMDLIN? 	"
$	   INQ/NOP GETF		"Compile GETF? 		"
$	   INQ/NOP GET_CROSS	"Compile GET_CROSS? 	"
$	   INQ/NOP I2MOSS	"Compile I2MOSS ? 	"
$	   INQ/NOP IFFBDY	"Compile IFFBDY? 	"
$	   INQ/NOP MOSCOD	"Compile MOSCOD? 	"
$	   INQ/NOP OUTREC	"Compile OUTREC?	"
$	   WRITE SYS$OUTPUT " "
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="I2MOSS"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="I2MOSSX"
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
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		SET VERIFY"
$ 	 IF .not.MES THEN GOTO NOMES
$		WC "$newmsg i2moss/number=1606"
$		WC "$@i2moss.temp_com"
$ NOMES: IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC I2MOSS.TMP=I2MOSS.CLD"
$		WC "$ 		SET COMMAND/OBJECT=I2MOSS_CLD I2MOSS.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV I2MOSS_CLD"
$		WC "$ 		IF OK THEN DELETE I2MOSS.TMP;*"
$		WC "$ 		IF OK THEN PURGE/NOLOG I2MOSS_CLD.OBJ"
$	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$	   IF .NOT. CLSFIL THEN GOTO A100
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC CLSFIL''KPCOM'=CLSFIL"
$	   	WC "$ 		FORT''FSW1' CLSFIL"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CLSFIL"
$		WC "$ 		PURGE/NOLOG CLSFIL.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG CLSFIL.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CLSFIL.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A100:	   IF .NOT. CMDLIN THEN GOTO A110
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC CMDLIN''KPCOM'=CMDLIN"
$	   	WC "$ 		FORT''FSW1' CMDLIN"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CMDLIN"
$		WC "$ 		PURGE/NOLOG CMDLIN.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG CMDLIN.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CMDLIN.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A110:	   IF .NOT. GETF THEN GOTO A120
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GETF''KPCOM'=GETF"
$	   	WC "$ 		FORT''FSW1' GETF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GETF"
$		WC "$ 		PURGE/NOLOG GETF.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GETF.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GETF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A120:	   IF .NOT. GET_CROSS  THEN GOTO A130
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GET_CROSS''KPCOM'=GET_CROSS"
$	   	WC "$ 		FORT''FSW1' GET_CROSS"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GET_CROSS"
$		WC "$ 		PURGE/NOLOG GET_CROSS.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GET_CROSS.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GET_CROSS.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A130:	   IF .NOT. I2MOSS  THEN GOTO A140
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC I2MOSS''KPCOM'=I2MOSS"
$	   	WC "$ 		FORT''FSW1' I2MOSS"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV I2MOSS"
$		WC "$ 		PURGE/NOLOG I2MOSS.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG I2MOSS.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG I2MOSS.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A140:	   IF .NOT. IFFBDY  THEN GOTO A150
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC IFFBDY''KPCOM'=IFFBDY"
$	   	WC "$ 		FORT''FSW1' IFFBDY"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IFFBDY"
$		WC "$ 		PURGE/NOLOG IFFBDY.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG IFFBDY.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG IFFBDY.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A150:	IF .NOT. MOSCOD  THEN GOTO A180
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC MOSCOD''KPCOM'=MOSCOD"
$	   	WC "$ 		FORT''FSW1' MOSCOD"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV MOSCOD"
$		WC "$ 		PURGE/NOLOG MOSCOD.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG MOSCOD.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG MOSCOD.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A180:	   IF .NOT. OUTREC  THEN GOTO LNKONLY
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC OUTREC''KPCOM'=OUTREC"
$	   	WC "$ 		FORT''FSW1' OUTREC"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV OUTREC"
$		WC "$ 		PURGE/NOLOG OUTREC.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG OUTREC.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG OUTREC.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$	   	WC "$ 		LINK''LINKOPTS'/EXE=''LINKVER' I2MOSS,-"
$	   	WC "		I2MOSS_CLD,CLSFIL,GETF,OUTREC, -"
$	   	WC "		IFFBDY,CMDLIN,-"
$		WC "		MOSCOD,GET_CROSS, -"
$		WC "		I2MOSS.PROMSG_OBJ, -"
$	   	WC "		LSL$LIBRARY:IFFSHR/OPT,LSLSHR/OPT"
$		WC "$ MAPID I2MOSS"
$		WC "$ PURGE/NOLOG ''LINKVER'.EXE,I2MOSS.MAP,I2MOSS.MAPID"
$!
$ NOLNK:
$		WC "$ 		I2MOSSEX:"
$		WC "$ 		DEASS/GROUP LSL$I2MOSS_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO I2MOSSEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$I2MOSS_BUILDING
$	BAT I2MOSSBAT.COM
$	GOTO I2MOSSX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO I2MOSSEX
$	DEASS/GROUP LSL$I2MOSS_BUILDING
$	@I2MOSSBAT.COM
$	GOTO I2MOSSX2
$ I2MOSSEX:
$	DEASS/GROUP LSL$I2MOSS_BUILDING
$ I2MOSSX2:
$	IF VER THEN SET VERIFY
