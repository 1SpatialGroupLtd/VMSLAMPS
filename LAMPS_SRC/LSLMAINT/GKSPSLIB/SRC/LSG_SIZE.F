	LOGICAL FUNCTION LSG_SIZE(FILE,DEF,DX,DY,RX,RY)
C
CDEC$	IDENT	'23OC96'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author Clarke Brunt					17-Mar-1986
C
C To read a file containing size and number of pixels for a
C raster plotter.
C
C File contains one significant line containing:
C X-size (metres) Y-size (metres) X-pixels Y-pixels
C
C Comment lines are preceded by a semi-colon, and may be interspersed
C at will.
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C arguments
	CHARACTER*(*)	FILE		! the filename
	LOGICAL		DEF		! are sizes default?
	REAL		DX,DY		! size in device coords (metres)
	REAL		RX,RY		! size in raster coords (pixels)
C
C functions used
	LOGICAL		FLROPN
	LOGICAL		FLRCLO
	INTEGER*4	FLRLIN
	LOGICAL		RDCHS
	LOGICAL		RDREAL
	LOGICAL*4	LIB$GET_LUN
	LOGICAL*4	LIB$FREE_LUN
C
	LOGICAL*4	OK
	INTEGER*4	ERROR
	INTEGER		I			! count variable
	INTEGER*4	LUN
	BYTE		CH
	REAL		X(4)
C
	REAL	DEFMAXX,DEFMAXY,DEFPIXX,DEFPIXY
	PARAMETER	(DEFMAXX=1.189,DEFMAXY=0.841)
	PARAMETER	(DEFPIXX=1448.0,DEFPIXY=1024.0)
C
C set up the defaults
	DEF = .TRUE.
	DX = DEFMAXX		! x size
	DY = DEFMAXY
	RX = DEFPIXX		! x number of pixels
	RY = DEFPIXY
C
C get a LUN to read the file on
	OK = LIB$GET_LUN(LUN)
	IF (.NOT.OK) THEN		! failed
	   CALL LSL_PUTMSG(OK)
	   GOTO 10000
	ENDIF
C
C open up the file (just give up on error)
	OK = FLROPN(LUN,FILE)	! open file
	IF (.NOT.OK) GOTO 999
C
50	OK =  FLRLIN(,,,ERROR) 	! read into TXTBUF
	IF (.NOT.OK) THEN
	   IF (OK.EQ.LSL__EOF) GOTO 998		! end of file
	   CALL LSL_PUTMSG(OK)
	   CALL LSL_ADDMSG(ERROR)
	   GOTO 999
	ENDIF
C
C we have a line - what is it ?
	CALL BSLN				! start of line
	IF (RDCHS(CH)) GOTO 50			! empty line
	IF (CH.EQ.';') GOTO 50			! comment line
	CALL BSCH
C
C read x and y size (metres)
	IF (RDREAL(X(1))) GOTO 998
	IF (RDREAL(X(2))) GOTO 998
C
C and now number of pixels
	IF (RDREAL(X(3))) GOTO 998
	IF (RDREAL(X(4))) GOTO 998
C
C OK - got all 4
	IF (X(1).GT.0.0 .AND. X(2).GT.0.0) THEN
	   DEF = .FALSE.
	   DX = X(1)
	   DY = X(2)
	ENDIF
	IF (X(3).GT.0.0 .AND. X(4).GT.0.0) THEN
	   RX = X(3)
	   RY = X(4)
	ENDIF
C
998	OK = FLRCLO(LUN,ERROR)
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   CALL LSL_ADDMSG(ERROR)
	ENDIF
C
999	OK = LIB$FREE_LUN(LUN)	! free LUN
	IF (.NOT.OK) CALL LSL_PUTMSG(OK)
C
10000	CONTINUE
C
	CALL LSG_SIZE_SUB(DX,DY,RX,RY)
C
	RETURN
C
	END
C
C
C
	SUBROUTINE LSG_SIZE_SUB(DX,DY,RX,RY)
C
CDEC$	IDENT	'23OC96'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author Clarke Brunt					23-Oct-1996
C
C Set up sizes in common block
C
	IMPLICIT NONE
C
	INCLUDE 'HERE:GKSDAT1.CMN'
C
C arguments
	REAL	DX,DY			! size in device coords (metres)
	REAL	RX,RY			! size in raster coords (pixels)
C
	DCMAXX = DX
	DCMAXY = DY
	RASTX = RX
	RASTY = RY
C
C set resulting pixel size (device coords)
C
	PSIZX = DCMAXX/RASTX
	PSIZY = DCMAXY/RASTY
C
	RETURN
	END
