	SUBROUTINE 	PROCESS
CDEC$	IDENT	'25AP91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Mod					09-Apr-1991	Jon Barber
C
C Description:
C
C	Process the Mobile file into format suitable for IFROMTEXT/FRT=
C	Produces a file with:
C
C	MD
C	SC 50000	! scale
C	LO 0 0		! local origin
C	NO 1
C	FS O
C	ST 3		! for 4 corner ticks for 
C	X Y		! RANGE 0 32000 0 20000
C	EF
C	EO
C
C	NO 1
C	FS 1 		! FC = 1 for symbols (MOD(FC,25) not = 0)
C	AC 3 FC		! old FC = spot height
C	ST 
C	X Y
C	EF
C
C	FS 25 		! for contours (MOD(FC,25) == 0)
C	AC 3 FC		! FC = contour height
C	ST 
C	X Y
C	X Y etc
C	EF
C
C	EO
C	EM
C	EJ
C
C	Qualifiers:
C
C		MORPHOLOGY
C		Signifies a morphology file with linear features with
C		FC 1,3,6 etc. ie. not multiples of 25.
C		No morphology signifies topography with linear contours
C		with FC's a multiple of 25, and symbol spot heights with
C		other FC'S.
C
C		TOLERANCE = real
C		All line segments longer than this are deleted, 
C		and a new feature started.
C
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
C
	INCLUDE 'CMN:FILE.CMN'
C
	INTEGER		STATUS
	LOGICAL		OK
C
	LOGICAL		FLRLIN
	LOGICAL		FLRCLO
	LOGICAL		FLWSTR
	LOGICAL		FLWCLO
C
	LOGICAL		RDCHS
	LOGICAL		RDCH
	LOGICAL		RDINT
	LOGICAL		RDLONG
	LOGICAL		RDDBLE
	LOGICAL		RDREAL
C
	REAL*8		DSQ
	REAL*8		X,Y
	REAL*8		OLD_X,OLD_Y
C
	INTEGER		I,RECNUM
	BYTE		ICH
	INTEGER*2	FC,NPTS
	INTEGER*4	IFC,REM
	LOGICAL		HAD_C
	LOGICAL		IS_SYMB
C
C Record types
C
	BYTE		LF
	DATA		LF/Z0A/		! <LF> character
C
C-------------------------------------------------------------------------------
C Select files for read and write
C
	CALL FLRSEL(MOBLUN)
	CALL FLWSEL(TXTLUN)
C
	RECNUM = 0
	DSQ = 100*100
	IF (HAD_TOL) DSQ = TOLERANCE*TOLERANCE
C
C Create MD2 with scale set to 50000
C
	CALL FLWSTR('MD')
	CALL FLWSTR('SC 50000')
	CALL FLWSTR('LO 0 0')
C
C Create layer 0 with corner ticks
C
	CALL FLWSTR('NO 0')
C
	CALL FLWSTR('NF')
	CALL FLWSTR('FS 0')
	CALL FLWSTR('ST')
	CALL FLWSTR('1600 20000')
	CALL FLWSTR('0 20000')
	CALL FLWSTR('0 19000')
	CALL FLWSTR('EF')
C
	CALL FLWSTR('NF')
	CALL FLWSTR('FS 0')
	CALL FLWSTR('ST')
	CALL FLWSTR('0 1000')
	CALL FLWSTR('0 0')
	CALL FLWSTR('1600 0')
	CALL FLWSTR('EF')
C
	CALL FLWSTR('NF')
	CALL FLWSTR('FS 0')
	CALL FLWSTR('ST')
	CALL FLWSTR('30400 0')
	CALL FLWSTR('32000 0')
	CALL FLWSTR('32000 1000')
	CALL FLWSTR('EF')
C
	CALL FLWSTR('NF')
	CALL FLWSTR('FS 0')
	CALL FLWSTR('ST')
	CALL FLWSTR('32000 19000')
	CALL FLWSTR('32000 20000')
	CALL FLWSTR('30400 20000')
	CALL FLWSTR('EF')
C
	CALL FLWSTR('EO')
C
C Layer 1 for features
C
	CALL FLWSTR('NO 1')
C
10	STATUS = FLRLIN()
	IF (.NOT.STATUS) THEN
	   IF (STATUS.EQ.LSL__EOF) GOTO 102
	   GOTO 999
	ENDIF
	RECNUM = RECNUM + 1
C
	CALL BSLN
	OK = RDCH(ICH)			! Check for linefeed
	IF (OK) THEN			! no char
	   CALL WRITEF (' Unable to read character on line %N',RECNUM)
	   GOTO 10
	ENDIF
C
	IF (ICH.NE.LF) CALL BSCH
C
C Read  first number on first line as FC
C
	HAD_C = .FALSE.
C
	OK = RDINT(FC)
	IFC = FC			! keep IFC as height for AC
C
C No symbols in morphology files
C
	IF (HAD_MOR) THEN
	   IS_SYMB = .FALSE.
	   GOTO 55
	ENDIF
C
C Topography files, set symbol flag flag according to FC
C
	REM = MOD(IFC,25)
	IF (REM.NE.0) THEN
	   FC = 1			! change symbol FC to 1
	   IS_SYMB = .TRUE.
	ELSE
	   IS_SYMB = .FALSE.
	   IF (IFC.EQ.0) IFC = 1	! change coastline AC value to 1
	ENDIF
C
55	OK = RDINT(NPTS)
C
	CALL FLWSTR('NF')
	CALL EXPAND('FS %^W%N',FC)
	CALL FLWLIN()
	CALL EXPAND('AC 3 %N',IFC)
	CALL FLWLIN()
	CALL FLWSTR('ST')
C
99	DO 101 I = 1,NPTS
100	   STATUS = FLRLIN()
	   IF (.NOT.STATUS) GOTO 999
	   RECNUM = RECNUM + 1
C
	   CALL BSLN
	   OK = RDCH(ICH)			! Check for linefeed
	   IF (OK) THEN				! no char
	      CALL WRITEF (' Unable to read character on line %N',RECNUM)
	      GOTO 100
	   ENDIF
C
	   IF (ICH.NE.LF) CALL BSCH
C
	   OK = RDDBLE(Y) 	      
	   OK = RDDBLE(X)
C
C Split multiple x,y symbol features into separate ones, and warn
C of the positions
C
	   IF (IS_SYMB) THEN
	      IF (I.EQ.1) THEN
		 CALL EXPAND ('%F %F',X,Y)
		 CALL FLWLIN()
	      ELSE
		 CALL FLWSTR('EF')
	         CALL FLWSTR('NF')
		 CALL EXPAND('FS %^W%N',FC)
		 CALL FLWLIN()
		 CALL EXPAND('AC 3 %N',IFC)
		 CALL FLWLIN()
		 CALL FLWSTR('ST')
		 CALL EXPAND ('%F %F',X,Y)
		 CALL FLWLIN()
	      ENDIF
C
	      GOTO 101
	   ENDIF
C
C Symbols dealt with, only Contours to do now
C
C Test I.GT.2 and I.LT.N-1 to avoid creating one point line features
C
C	   IF (.NOT.IS_SYMB .AND. HAD_C .AND. I.GT.2 .AND. I.LT.NPTS-1) THEN
C
C Omit test of I.GT.2 and I.LT.N-1, possibly creating one point line 
C features (which will be deleted by LITES2 after IFROMTEXT creates a
C one point line feature). A side effect of this is that symbol features
C with 2 or more points (which seem to exist) may be split up into 
C separate features correctly, (but others may not!)
C
	   IF (HAD_C) THEN
C
	      IF ( (X-OLD_X)*(X-OLD_X) + (Y-OLD_Y)*(Y-OLD_Y) .GT.
     &			DSQ) THEN
C
		 HAD_C = .FALSE.
C
		 CALL FLWSTR('EF')
		 CALL FLWSTR('NF')
		 CALL EXPAND('FS %^W%N',FC)
		 CALL FLWLIN()
		 CALL EXPAND('AC 3 %N',IFC)
		 CALL FLWLIN()
		 CALL FLWSTR('ST')
		 CALL EXPAND ('%F %F',X,Y)
		 CALL FLWLIN()
C
	 	 NPTS = NPTS - I
C
		 OLD_Y = Y
		 OLD_X = X
		 HAD_C = .TRUE.
C
		 GOTO 99
	      ENDIF
	   ENDIF
C
	   CALL EXPAND ('%F %F',X,Y)
	   CALL FLWLIN()
C
	   OLD_Y = Y
	   OLD_X = X
	   HAD_C = .TRUE.
C
101	CONTINUE
C
	CALL FLWSTR('EF')
C
	GOTO 10
C
102	CONTINUE
C
	CALL FLWSTR('EO')
	CALL FLWSTR('EM')
	CALL FLWSTR('EJ')
C
C Tidy up
C
999	CONTINUE
C
C Finish off the IFF file
C
	CALL FLRCLO(MOBLUN)
	CALL FLWCLO(TXTLUN)
C
	RETURN
	END
C
