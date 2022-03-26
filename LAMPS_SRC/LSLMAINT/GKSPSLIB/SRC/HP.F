C
C HP-GL/2 specific routines
C
	INTEGER FUNCTION PS_OPEN(WKID,LW,HWFM)
C
CDEC$	IDENT	'23OC96'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	28-July-1992
C
C Open and initialise HP-GL/2 file
C
	IMPLICIT NONE
C
	INCLUDE		'($SSDEF)'
	INCLUDE		'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE		'LSL$CMNLSL:TXTC.CMN'
	INCLUDE		'HP.CMN'
C
C Arguments
	INTEGER		WKID	! workstation ident (only for LSG_SET_LUT)
	REAL		LW	! returned nom. line width, copy of NOMLW
	INTEGER		HWFM	! returned h/w fill max (copy of MAXPATH)
C
C Functions
	INTEGER		SIGCHS
	INTEGER		TRNALL
	INTEGER 	LIB$GET_LUN
	INTEGER		FLWOPN,FLROPN,FLRLIN
	LOGICAL		RDLONG,RDREAL,RDCHS
	INTEGER		TEST_TERM
C
C workspace
	INTEGER		OK,IERR
	CHARACTER*80	TRAN
	INTEGER		ILUN
	LOGICAL		IS_TERM
	BYTE		CH
	INTEGER		I
	LOGICAL		DEF_SIZE	! are sizes default?
	REAL		DX,DY		! size in device coords (metres)
	REAL		RX,RY		! size in raster coords (pixels)
	INTEGER		LIMIT(4)
	INTEGER		ROT
C
C call back to main code to set things in GKSDAT1.CMN
C Among other things, this calls LSG_SIZE which sets up
C DCMAXX/Y, RASTX/Y, and PSIZX/Y
C
	CALL GKS_GET_LOGICALS('HP',DEF_SIZE,DX,DY,RX,RY)
C
C Get LUN to use
	OK = LIB$GET_LUN(PSLUN)
	IF (.NOT.OK) THEN
	   CALL TTWSTR('Unable to allocate LUN for HP-GL/2 file')
	   CALL LSL_PUTMSG(OK)
	   GOTO 999
	ENDIF
C
C Create HP-GL/2 file
	IF (TRNALL('LSL$HP',TRAN).NE.SS$_NOLOGNAM) THEN
	   OK = FLWOPN(PSLUN,'LSL$HP:',IERR)
	ELSE
	   TRAN = 'PLOTFILE.HP'
	   OK = FLWOPN(PSLUN,'PLOTFILE.HP',IERR)
	ENDIF
	IF (.NOT.OK) THEN
	   CALL TTWSTR('Unable to create HP-GL/2 file')
	   CALL LSL_PUTMSG(OK)
	   IF (OK.EQ.LSL__SYSOPEN) CALL LSL_ADDMSG(IERR)
	   GOTO 999
	ENDIF
C
C If paper size has been read from a size file, and was sensible,
C then include it as a PS (Plot Size) command in the header
	HPPTR = 0
	CALL EXPAND('BP1,"%S Page 1"IN',TRAN(:SIGCHS(TRAN)))
C
C check for a rotation from LSL$HP_ROTATE 0-3 right angles a/c
C (beware don't trample stuff in the EXPAND buffer)
	ROT = 0
	IF (TRNALL('LSL$HP_ROTATE',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(ROT)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$HP_ROTATE - using default value')
	      ROT = 0
	   ELSEIF (ROT.LT.0.OR.ROT.GT.3) THEN
	      CALL TTWSTR('Value for LSL$HP_ROTATE must be in range 0-3'//
     &		' - using default value')
	      ROT = 0
	   ENDIF
	ENDIF
C
	IF (.NOT.DEF_SIZE) THEN
	   CALL APPEND('PS%N,%N',NINT(DX*40000.),NINT(DY*40000.))
C
C If plot size specifies less distance along roll than width, then
C the coordinate system is oriented with x across the paper -
C so add one to the rotation to counteract this. We are not really
C 100% sure this has happened, since the plot size is reduced to
C the size of the loaded media first - the user can achieve the
C desired effect with the LSL$HP_ROTATION logical
C
	   IF (DX.LT.DY) THEN
	      ROT = ROT+1
	      IF (ROT.GT.3) ROT = 0
	   ENDIF
	ENDIF
	IF (ROT.NE.0) CALL APPEND('RO%N',ROT*90)
C
C check for a scaling from LSL$HP_SCALE 1,10,or 100
C (allow only 10**n so that scale factor is exactly 0.1 or 0.01,
C and limit to 100 since anything bigger might overflow the allowed
C real range of 2**23 = 8.3E6)
	SCALE = 1.0
	IF (TRNALL('LSL$HP_SCALE',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDREAL(SCALE)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$HP_SCALE - using default value')
	      SCALE = 1.0
	   ELSEIF (SCALE.NE.1.AND.SCALE.NE.10.AND.SCALE.NE.100) THEN
	      CALL TTWSTR('Value for LSL$HP_SCALE must be 1, 10, or 100'//
     &		' - using default value')
	      SCALE = 1.0
	   ENDIF
	ENDIF
	IF (SCALE.NE.1) CALL APPEND('SC0,%F0.2,0,%F0.2,2',
     &					1.0/SCALE,1.0/SCALE)
C
C turn off transparency (of white), and set number of pens
	CALL APPEND('TR0NP256')
	CALL HP_BUFFER
	CALL HP_FLUSH
C
C Read back hard clip limits from online plotter
	OK = TEST_TERM('LSL$HP',IS_TERM,IERR)
	IF (.NOT.OK .OR. .NOT.IS_TERM) GOTO 50
	OK = TEST_TERM('LSL$HPINPUT',IS_TERM,IERR)
	IF (.NOT.OK .OR. .NOT.IS_TERM) GOTO 50
C
C Get LUN to use
	OK = LIB$GET_LUN(ILUN)
	IF (.NOT.OK) THEN
	   CALL TTWSTR(
     &		'Unable to allocate LUN for HP clip limits input')
	   CALL LSL_PUTMSG(OK)
	   GOTO 50
	ENDIF
	OK = FLROPN(ILUN,'LSL$HPINPUT:',IERR)
	IF (.NOT.OK) GOTO 48
	CALL HP_BUFSTR('OH;')
	CALL HP_FLUSH
	OK = FLRLIN()		! read a line from header file
	IF (OK) THEN		! false at EOF
	   CALL BSLN
	   DO 45 I=1,4
	      IF (RDCHS(CH)) GOTO 46
	      IF (CH.NE.',') CALL BSCH
	      IF (RDLONG(LIMIT(I))) GOTO 46
45	   CONTINUE
C
C OK - got our hard clip limits - adjust size to agree
	   DX = (LIMIT(3)-LIMIT(1))/40000.
	   DY = (LIMIT(4)-LIMIT(2))/40000.
C
C set them back in GKSDAT1 common block
	   CALL LSG_SIZE_SUB(DX,DY,RX,RY)
	ENDIF
46	CALL FLRCLO(ILUN)
48	CALL LIB$FREE_LUN(ILUN)
50	CONTINUE
C
C try for a nominal line width from LSL$HP_NOMLW (default 0.1)
	NOMLW = 0.1				! tenth mm
	IF (TRNALL('LSL$HP_NOMLW',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDREAL(NOMLW)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$HP_NOMLW - using default value')
	      NOMLW = 0.1			! tenth mm
	   ELSEIF (NOMLW.LE.0.0) THEN
	      CALL TTWSTR(
     &	'Value for LSL$HP_NOMLW must be >0.0 - using default value')
	      NOMLW = 0.1			! tenth mm
	   ENDIF
	ENDIF
	NOMLW = NOMLW/1000.0		! convert to metres
	LW = NOMLW			! return copy to caller
C
C check for maximum path length - LSL$HP_MAXPATH
	MAXPATH = 1000
	IF (TRNALL('LSL$HP_MAXPATH',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(MAXPATH)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$HP_MAXPATH - using default value')
	      MAXPATH = 1000
	   ENDIF
	   IF (MAXPATH.LT.100) THEN
	      CALL TTWSTR(
     &	'Value of LSL$HP_MAXPATH must be >100 - using default value')
	      MAXPATH = 1000
	   ENDIF
	ENDIF
	HWFM = MAXPATH		! return copy to caller
C
C check for plot colour 0 in images - LSL$HP_BACKGROUND
	PLOT0 = .TRUE.			! assume on
	IF (TRNALL('LSL$HP_BACKGROUND',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(I)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$HP_BACKGROUND - using default value')
	   ELSEIF (I.LT.0.OR.I.GT.1) THEN
	      CALL TTWSTR(
     &'Value of LSL$HP_BACKGROUND must be 0 or 1 - using default value')
	   ELSEIF (I.EQ.0) THEN
	      PLOT0 = .FALSE.
	   ENDIF
	ENDIF
C
	PSPAGE = 0
	PSCOL = -1
	PSWID = -1
	PSJOIN = -1
	PSCAP = -1
	PSFNT = -1
	PSTYPE = 1
	PSLIM(1) = 1E30
	PSLIM(2) = 1E30
	PSLIM(3) = -1E30
	PSLIM(4) = -1E30
C
C write the colour table
	CALL LSG_SET_LUT(WKID,'LSL$HP_COLOUR:') ! load colour table
C
100	OK = SS$_NORMAL
C
999	PS_OPEN = OK
C
	RETURN
	END
C
	SUBROUTINE PS_CLOSE
C
CDEC$	IDENT	'21JL92'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	28-July-1992
C
C Write trailers and close HP file
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
	CALL FLWCLO(PSLUN)
	CALL LIB$FREE_LUN(PSLUN)
C
	RETURN
	END
C
	SUBROUTINE PS_PAGE
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Begin new page
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C forget previous settings so that they are set in new page
	PSCOL = -1
	PSWID = -1
	PSJOIN = -1
	PSCAP = -1
	PSFNT = -1
	PSTYPE = 1
	PSPAGE = PSPAGE+1
	PSX = 0.0
	PSY = 0.0
	HPX = 0
	HPY = 0
	DOWN = .FALSE.
	PE = .FALSE.
	POLY = .FALSE.
	IF (PSPAGE.GT.1) THEN
	   CALL HP_FLUSH
	   CALL EXPAND('BP1,"Page %N"IN',PSPAGE)
	   CALL HP_BUFFER
	   CALL HP_FLUSH
	ENDIF
	RETURN
	END
C
	SUBROUTINE PS_SHOW
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Show (print) a page
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
	CALL PS_FLUSH(.FALSE.,.FALSE.)
	CALL HP_FLUSH
	CALL FLWSEL(PSLUN)
	CALL FLWSTR('PUSP0PG;')
C
	RETURN
	END
C
	SUBROUTINE PS_FLUSH(FILL,CLOSE)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Finish any PE instruction in progress
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C arguments
	LOGICAL		FILL		! fill path as area
	LOGICAL		CLOSE		! close path
C
	IF (PE) THEN
	   PE = .FALSE.
	   CALL HP_BUFSTR(';')
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_LINE(X,Y)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Draw a line to position
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C Arguments
	REAL		X,Y	! position in DC (metres)
C
	IF (X.NE.PSX.OR.Y.NE.PSY) THEN
	   PSX = X
	   PSY = Y
	   CALL PS_LIM(PSX,PSY)
C
	   IF (.NOT.PE) THEN
	      PE = .TRUE.
	      CALL HP_BUFSTR('PE')
	   ENDIF
	   CALL HP_COORD(PSX,PSY)
	   DOWN = .TRUE.
	ENDIF
C
999	RETURN
	END
C
	SUBROUTINE PS_MOVE(X,Y,BREAK)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Move to position
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C Arguments
	REAL		X,Y	! position in DC (metres)
	LOGICAL		BREAK	! break path if finite move
C
	IF (POLY.AND.IN_POLY) THEN
	   CALL PS_FLUSH(.FALSE.,.FALSE.)	! end any PE
	   CALL HP_BUFSTR('PM1')		! next sub-polygon
	   PSX = OPSX				! restore start point
	   PSY = OPSY
	   HPX = OHPX
	   HPY = OHPY
	ENDIF
C
	IF (X.NE.PSX.OR.Y.NE.PSY) THEN
	   PSX = X
	   PSY = Y
	   CALL PS_LIM(PSX,PSY)
C
	   IF (.NOT.PE) THEN
	      PE = .TRUE.
	      CALL HP_BUFSTR('PE')
	   ENDIF
	   CALL HP_BUFSTR('<')	! pen up flag
	   CALL HP_COORD(PSX,PSY)
	   DOWN = .FALSE.
	ENDIF
C
	IF (POLY) THEN
	   IF (.NOT.IN_POLY) THEN
	      IN_POLY = .TRUE.
	      CALL PS_FLUSH(.FALSE.,.FALSE.)	! end any PE
	      CALL HP_BUFSTR('PM')		! first sub-polygon
	   ENDIF
	   OPSX = PSX				! save start point
	   OPSY = PSY
	   OHPX = HPX
	   OHPY = HPY
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_TEXT(X,Y,STRING)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Output a text string
C
	IMPLICIT NONE
C
CCC	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
CCC	INCLUDE		'HP.CMN'
C
C arguments
	REAL		X,Y
	CHARACTER*(*)	STRING
	INTEGER		I
	CHARACTER*1	CH
	INTEGER		ICH
C
CCC	CALL PS_FLUSH(.FALSE.,.FALSE.)	! flush out any linework
CCC	CALL PS_MOVE(X,Y,.FALSE.)	! move to position
C
CCC	CALL EXPAND
CCC	CALL PS_UPDATE(.TRUE.)
C
CCC	CALL FLWSEL(PSLUN)
CCC	IF ( CCHHGT.NE.PSHGT.OR.
CCC     &	     CCHANG.NE.PSANG.OR.
CCC     &	     CCHFNT.NE.PSFNT) THEN
CCC	   PSHGT = CCHHGT
CCC	   PSANG = CCHANG
CCC	   PSFNT = CCHFNT
CCC	   CALL PS_APP(PSANG*RTOD)
CCC	   CALL PS_APP(PSHGT*1000.0)
CCC	   CALL APPEND('%N FN ',PSFNT)	! find the font
CCC	ENDIF
C
C n.b. LSLLIB bug - if %P0 at end of string then ignored
CCC	CALL APPEND('(%P0% ')		! use zero pad char
C
C process the string, escaping ()\, and using octal for unprintable
CCC	DO 100 I=1,LEN(STRING)
CCC	   IF (EXPLEN.GT.60) THEN
CCC	      CALL FLWAPP('\')	! continuation character
C
C n.b. LSLLIB bug - if %P0 at end of string then ignored
CCC	      CALL EXPAND('%P0% ')! use zero pad char
CCC	   ENDIF
CCC	   CH = STRING(I:I)
CCC	   ICH = ICHAR(CH)
CCC	   IF (ICH.LT.32.OR.ICH.GE.127) THEN
CCC	      CALL APPEND('\%O3',ICH)		! use octal
CCC	   ELSEIF (CH.EQ.'%') THEN
CCC	      CALL APPEND('%%')			! single %
CCC	   ELSE
CCC	      IF (CH.EQ.'('.OR.CH.EQ.')'.OR.CH.EQ.'\') CALL APPEND('\')
CCC	      CALL APPEND(CH)
CCC	   ENDIF
CCC100	CONTINUE
CCC	CALL FLWAPP(') SH')
C
	RETURN
	END
C
	LOGICAL FUNCTION PS_STRING_WIDTH(STRING,FONT,WIDTH)
C
CDEC$	IDENT	'16JL93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C Get the width of a string if plotted at unit height
C Returns .TRUE. if unable to return the information
C
	IMPLICIT NONE
C
C Arguments:
	CHARACTER*(*)	STRING
	INTEGER		FONT
	REAL		WIDTH
C
	PS_STRING_WIDTH = .TRUE.
	RETURN
	END
C
	LOGICAL FUNCTION PS_STRING_BOUNDS(STRING,FONT,BORDER,ROUTINE)
C
CDEC$	IDENT	'31AU94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	31-August-1994
C
C Call the callback ROUTINE for each character in the string, passing
C the width and bounding box of the character.
C It is used to build up a region around the string.
C Returns .TRUE. if unable to return the information
C
	IMPLICIT NONE
C
C Arguments:
	CHARACTER*(*)	STRING
	INTEGER		FONT
	REAL		BORDER
	EXTERNAL	ROUTINE
C
	PS_STRING_BOUNDS = .TRUE.
	RETURN
	END
C
	SUBROUTINE HP_COORD(X,Y)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Output an encoded coordinate
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C Arguments
	REAL		X,Y
C
C Workspace
	INTEGER	IX,IY,IDX,IDY
C
	IX = NINT(X*40000.0*SCALE)	! convert to plotter units
	IY = NINT(Y*40000.0*SCALE)
C
	IDX = IX-HPX		! delta move
	IDY = IY-HPY
	HPX = IX		! new plotter position
	HPY = IY
C
	CALL HP_ENCODE(IDX)
	CALL HP_ENCODE(IDY)
C
	RETURN
	END
C
	SUBROUTINE HP_ENCODE(I)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Output an encoded integer
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C Arguments
	INTEGER		I	! for entry below
C
C Workspace
	INTEGER		ID
	INTEGER		C
	BYTE		B
	EQUIVALENCE	(C,B)
C
	ID = I
C
C encode the sign bit
	IF (ID.GE.0) THEN
	   ID = 2*ID
	ELSE
	   ID = 2*(-ID) + 1
	ENDIF
C
10	C = (ID.AND.63) + 63	! extract 6 bits and bias it
	ID = ID/64		! shift right by 6
	IF (ID.EQ.0) C = C+128	! terminator
	HPPTR = HPPTR+1
	HPBUF(HPPTR) = B
	IF (HPPTR.GE.HPMAX) CALL HP_FLUSH
	IF (ID.NE.0) GOTO 10
C
	RETURN
	END
C
	SUBROUTINE PS_LIM(X,Y)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Update bounding box
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C Arguments
	REAL		X,Y	! position in DC (metres)
C
	IF (X.LT.PSLIM(1)) PSLIM(1) = X
	IF (X.GT.PSLIM(3)) PSLIM(3) = X
	IF (Y.LT.PSLIM(2)) PSLIM(2) = Y
	IF (Y.GT.PSLIM(4)) PSLIM(4) = Y
C
	RETURN
	END
C
	SUBROUTINE PS_DEFRGB(CI,R,G,B)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Define a colour in RGB
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C Arguments
	INTEGER		CI	! colour index
	REAL		R,G,B	! components
C
	CALL PS_FLUSH(.FALSE.,.FALSE.)	! end any PE
	IF (DOWN) THEN
	   DOWN = .FALSE.
	   CALL HP_BUFSTR('PU')
	ENDIF
	CALL EXPAND('PC%N,%N,%N,%N',CI,
     &			INT(R*255.0),INT(G*255.0),INT(B*255.0))
	CALL HP_BUFFER
C
	RETURN
	END
C
	SUBROUTINE PS_CIRCLE(X,Y,ID)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Draw circle or arc
C ID = 1	Full circle - coords centre,edge
C ID = 2/3	Cw/ACw arc  - coords start,end,centre
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C Arguments
	REAL	X(3),Y(3)		! coordinates
	INTEGER	ID			! type 1-3
C
C w/s
CCC	REAL	RAD,ANG1,ANG2
C
CCC	CALL PS_FLUSH(.FALSE.,.FALSE.)	! flush out any linework
C
CCC	CALL PS_LIM(X(1),Y(1))
CCC	CALL PS_LIM(X(2),Y(2))
CCC	CALL FLWSEL(PSLUN)
C
CCC	IF (ID.EQ.1) THEN		! full circle
CCC	   RAD = SQRT((X(1)-X(2))**2+(Y(1)-Y(2))**2)
CCC	   CALL EXPAND
CCC	   CALL PS_APP(X(1)*1000.0)
CCC	   CALL PS_APP(Y(1)*1000.0)
CCC	   CALL PS_APP(RAD*1000.0)
CCC	   CALL FLWAPP('0 360 AA')
CCC	ELSE				! arc
CCC	   CALL PS_LIM(X(3),Y(3))
CCC	   RAD = SQRT((X(1)-X(3))**2+(Y(1)-Y(3))**2)
CCC	   ANG1 = ATAN2(Y(1)-Y(3),X(1)-X(3))*RTOD
CCC	   IF (ANG1.LT.0.0) ANG1 = ANG1+360.0
CCC	   ANG2 = ATAN2(Y(2)-Y(3),X(2)-X(3))*RTOD
CCC	   IF (ANG2.LT.0.0) ANG2 = ANG2+360.0
CCC	   CALL EXPAND
CCC	   CALL PS_APP(X(3)*1000.0)
CCC	   CALL PS_APP(Y(3)*1000.0)
CCC	   CALL PS_APP(RAD*1000.0)
CCC	   CALL APPEND('%F0.4 %F0.4 ',ANG1,ANG2)
CCC	   IF (ID.EQ.2) THEN
CCC	      CALL FLWAPP('AC')
CCC	   ELSE
CCC	      CALL FLWAPP('AA')
CCC	   ENDIF
CCC	ENDIF
CCC	CALL PS_FLUSH(.FALSE.,.FALSE.)
C
	RETURN
	END
C
	SUBROUTINE PS_BEGIN_IMAGE(NCOLS,NROWS,TMAT,BIT,COL)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Begin an image
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C Arguments
	INTEGER	NCOLS,NROWS	! dimensions of image
	REAL	TMAT(6)		! image matrix
	LOGICAL	BIT		! bit image? else byte
	INTEGER	COL		! colour index if bit
C
C workspace
	REAL	D
	REAL	X0,Y0,X1,Y1,WID
C
C statement functions
	REAL	X,Y
	REAL	XC,YC
	XC(X,Y) = (IM_MAT(4)*(X-IM_MAT(5))-IM_MAT(3)*(Y-IM_MAT(6)))
	YC(X,Y) = (-IM_MAT(2)*(X-IM_MAT(5))+IM_MAT(1)*(Y-IM_MAT(6)))
C
C sort out extents
	D = TMAT(4)*TMAT(1)-TMAT(3)*TMAT(2)
	IM_MAT(1) = TMAT(1)/D
	IM_MAT(2) = TMAT(2)/D
	IM_MAT(3) = TMAT(3)/D
	IM_MAT(4) = TMAT(4)/D
	IM_MAT(5) = TMAT(5)
	IM_MAT(6) = TMAT(6)
	CALL PS_LIM(XC(0.0,0.0),YC(0.0,0.0))
	CALL PS_LIM(XC(FLOAT(NCOLS),FLOAT(NROWS)),
     &		    YC(FLOAT(NCOLS),FLOAT(NROWS)))
C
C set pen width
	X0 = XC(0.0,0.5)
	Y0 = YC(0.0,0.5)
	X1 = XC(1.0,0.5)
	Y1 = YC(1.0,0.5)
	WID = MAX( ABS(X1-X0), ABS(Y1-Y0) )
	CALL PS_SETWID(WID/NOMLW)
C
C move to starting position
	CALL PS_MOVE(XC(0.0,0.5),YC(0.0,0.5))
C
	IM_COLS = NCOLS
	IM_ROWS = NROWS
	IM_COL = COL
	IM_X = 0
	IM_Y = 0
	IMGCNT = -1			! no run length points
C
	RETURN
	END
C
	SUBROUTINE PS_IMAGE(ARRAY,NVAL)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Output some image samples
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'HP.CMN'
C
C Arguments
	BYTE	ARRAY(*)
	INTEGER	NVAL
C
C workspace
	INTEGER	I
C
C statement functions
	REAL	X,Y
	REAL	XC,YC
	XC(X,Y) = (IM_MAT(4)*(X-IM_MAT(5))-IM_MAT(3)*(Y-IM_MAT(6)))
	YC(X,Y) = (-IM_MAT(2)*(X-IM_MAT(5))+IM_MAT(1)*(Y-IM_MAT(6)))
C
C run-length encoded
	DO 10 I=1,NVAL
	   IF (IMGCNT.LT.0) THEN
	      LSTBYT = ARRAY(I)
	      IMGCNT = 0
	   ELSEIF (ARRAY(I).NE.LSTBYT) THEN
C
C draw a line to the current position, in current colour
	      IF (LSTBYT.EQ.0.AND..NOT.PLOT0) THEN
	         CALL PS_MOVE(XC(FLOAT(IM_X),IM_Y+0.5),
     &			      YC(FLOAT(IM_X),IM_Y+0.5))
	      ELSE
	         CALL HP_SETPEN(LSTBYT.AND.255)
	         CALL PS_LINE(XC(FLOAT(IM_X),IM_Y+0.5),
     &			      YC(FLOAT(IM_X),IM_Y+0.5))
	      ENDIF
	      LSTBYT = ARRAY(I)
	      IMGCNT = 0
	   ELSE
	      IMGCNT = IMGCNT+1
	   ENDIF
	   IM_X = IM_X+1
	   IF (IM_X.EQ.IM_COLS) THEN
	      IF (LSTBYT.EQ.0.AND..NOT.PLOT0) THEN
CCC don't do irrelevant move
CCC	         CALL PS_MOVE(XC(FLOAT(IM_X),IM_Y+0.5),
CCC     &			      YC(FLOAT(IM_X),IM_Y+0.5))
	      ELSE
	         CALL HP_SETPEN(LSTBYT.AND.255)
	         CALL PS_LINE(XC(FLOAT(IM_X),IM_Y+0.5),
     &			      YC(FLOAT(IM_X),IM_Y+0.5))
	      ENDIF
	      IMGCNT = -1
	      IM_X = 0
	      IM_Y = IM_Y+1
	      IF (IM_Y.LT.IM_ROWS) THEN
	         CALL PS_MOVE(XC(0.0,IM_Y+0.5),YC(0.0,IM_Y+0.5))
	      ENDIF
	   ENDIF
10	CONTINUE
C
	RETURN
	END
C
C
	SUBROUTINE PS_BIT_IMAGE(ARRAY,NVAL)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Output some image samples
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'HP.CMN'
C
C Arguments
	INTEGER*4	ARRAY(*)
	INTEGER		NVAL
C
C workspace
	INTEGER	I
	BYTE	BYT
	INTEGER	L,N,J
C
C statement functions
	REAL	X,Y
	REAL	XC,YC
	XC(X,Y) = (IM_MAT(4)*(X-IM_MAT(5))-IM_MAT(3)*(Y-IM_MAT(6)))
	YC(X,Y) = (-IM_MAT(2)*(X-IM_MAT(5))+IM_MAT(1)*(Y-IM_MAT(6)))
C
C run-length encoded
C go to some trouble reading 32 bits at a time to avoid having to
C call LIB$EXTZV
	J = 0
	N = 0
	DO 10 I=1,NVAL
	   IF (N.EQ.0) THEN
	      J = J+1
	      L = ARRAY(J)
	      N = 32
	   ENDIF
	   BYT = 0
	   IF (L) BYT = 1		! N.B. test bottom bit
	   L = ISHFT(L,-1)
	   N = N-1
	   IF (IMGCNT.LT.0) THEN
	      LSTBYT = BYT
	      IMGCNT = 0
	   ELSEIF (BYT.NE.LSTBYT) THEN
C
C draw a line to the current position, in current colour
	      IF (LSTBYT.EQ.0.AND..NOT.PLOT0) THEN
	         CALL PS_MOVE(XC(FLOAT(IM_X),IM_Y+0.5),
     &			      YC(FLOAT(IM_X),IM_Y+0.5))
	      ELSE
	         IF (LSTBYT.EQ.0) THEN
	            CALL HP_SETPEN(0)
	         ELSE
	            CALL HP_SETPEN(IM_COL)
	         ENDIF
	         CALL PS_LINE(XC(FLOAT(IM_X),IM_Y+0.5),
     &			      YC(FLOAT(IM_X),IM_Y+0.5))
	      ENDIF
	      LSTBYT = BYT
	      IMGCNT = 0
	   ELSE
	      IMGCNT = IMGCNT+1
	   ENDIF
	   IM_X = IM_X+1
	   IF (IM_X.EQ.IM_COLS) THEN
	      IF (LSTBYT.EQ.0.AND..NOT.PLOT0) THEN
CCC don't do irrelevant move
CCC	         CALL PS_MOVE(XC(FLOAT(IM_X),IM_Y+0.5),
CCC     &			      YC(FLOAT(IM_X),IM_Y+0.5))
	      ELSE
	         IF (LSTBYT.EQ.0) THEN
	            CALL HP_SETPEN(0)
	         ELSE
	            CALL HP_SETPEN(IM_COL)
	         ENDIF
	         CALL PS_LINE(XC(FLOAT(IM_X),IM_Y+0.5),
     &			      YC(FLOAT(IM_X),IM_Y+0.5))
	      ENDIF
	      IMGCNT = -1
	      IM_X = 0
	      IM_Y = IM_Y+1
	      IF (IM_Y.LT.IM_ROWS) THEN
	         CALL PS_MOVE(XC(0.0,IM_Y+0.5),YC(0.0,IM_Y+0.5))
	      ENDIF
	   ENDIF
10	CONTINUE
C
	RETURN
	END
C
	SUBROUTINE PS_END_IMAGE(BIT)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C No-op - we know the image is complete anyway
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'HP.CMN'
C
C argument
	LOGICAL		BIT	! bit image?
C
	RETURN
	END
C
	SUBROUTINE PS_BEGIN_CURVE(X,Y,LOOP)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Begin curved section
C
	IMPLICIT NONE
C
C arguments
	REAL	X,Y		! starting position
	LOGICAL	LOOP		! closed loop?
C
	RETURN
	END
C
	SUBROUTINE PS_END_CURVE
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C End curved section
C
	IMPLICIT NONE
C
	RETURN
	END
C
	SUBROUTINE PS_CURVE(X,Y)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Curve to point
C
	IMPLICIT NONE
C
C Arguments
	REAL		X,Y	! position in DC (metres)
C
	RETURN
	END
C
C The PS_SETx routines which follow are no-ops in the PostScript version,
C but for HP, they set the attributes.
C PS_FLUSH already called, so not in polyline encoded.
C
	SUBROUTINE PS_SETCOL(COLI)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C argument
	INTEGER	COLI
C
	IF (COLI.NE.PSCOL) THEN
	   PSCOL = COLI
	   IF (DOWN) THEN
	      DOWN = .FALSE.
	      CALL HP_BUFSTR('PU')
	   ENDIF
	   CALL EXPAND('SP%N',PSCOL)
	   CALL HP_BUFFER
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_SETWID(LWID)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C argument
	REAL	LWID
C
C workspace
	INTEGER	NWID
C
	NWID = NINT(LWID*NOMLW*1000.0*1000.0)	! 1000th mm
	IF (NWID.NE.PSWID) THEN
	   PSWID = NWID
	   IF (DOWN) THEN
	      DOWN = .FALSE.
	      CALL HP_BUFSTR('PU')
	   ENDIF
	   CALL EXPAND('PW%F0.3',FLOAT(NWID)/1000.0)
	   CALL HP_BUFFER
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_SETTYP(LTYPE)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
C argument
	INTEGER	LTYPE
C
CCC	IF (LTYPE.NE.PSTYPE) THEN
CCC	   PSTYPE = LTYPE
CCC	   IF (DOWN) THEN
CCC	      DOWN = .FALSE.
CCC	      CALL HP_BUFSTR('PU')
CCC	   ENDIF
CCC	   CALL HP_BUFSTR('LT')
CCC	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_SETPAT(PECKC,REP1,REP2,PECK1,PECK2,GAP)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C Called after PS_SETTYP when LTYPE=1000 to set current line pattern
C
	IMPLICIT NONE
C
C arguments
	LOGICAL	PECKC
	INTEGER	REP1,REP2
	REAL	PECK1,PECK2,GAP
C
	RETURN
	END
C
	SUBROUTINE PS_SETJC(JOIN,CAP)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'HP.CMN'
C
C arguments
	INTEGER	JOIN
	INTEGER	CAP
C
C workspace
	INTEGER	HPCAP(0:2)	! mapping to HP cap values
	DATA	HPCAP/1,4,2/
	INTEGER HPJOIN(0:2)	! mapping to HP join values
	DATA	HPJOIN/2,4,5/
	SAVE	HPCAP,HPJOIN
C
	IF (JOIN.NE.PSJOIN .OR. CAP.NE.PSCAP) THEN
	   IF (DOWN) THEN
	      DOWN = .FALSE.
	      CALL HP_BUFSTR('PU')
	   ENDIF
	   CALL EXPAND('LA')
	   IF (CAP.NE.PSCAP) THEN
	      PSCAP = CAP
	      CALL APPEND('1,%N',HPCAP(PSCAP))
	   ENDIF
	   IF (JOIN.NE.PSJOIN) THEN
	      PSJOIN = JOIN
	      IF (EXPLEN.GT.2) CALL APPEND(',')
	      CALL APPEND('2,%N',HPJOIN(PSJOIN))
	   ENDIF
	   CALL HP_BUFFER
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_SETTXT(CHHGT,CHANG,CHFNT)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
C arguments
	REAL	CHHGT
	REAL	CHANG
	INTEGER	CHFNT
C
	RETURN
	END
C
	SUBROUTINE PS_BEGIN_AREA
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C Called just before drawing the boundary of an area
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C just flag that we are beginning a polygon
	POLY = .TRUE.
	IN_POLY = .FALSE.
C
	RETURN
	END
C
	SUBROUTINE PS_END_AREA
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C Called just after drawing the boundary of an area.
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
	CALL PS_FLUSH(.FALSE.,.FALSE.)	! end any PE
	CALL HP_BUFSTR('PM2FP')		! end polygon, and fill
	PSX = OPSX				! restore start point
	PSY = OPSY
	HPX = OHPX
	HPY = OHPY
	POLY = .FALSE.
C
	RETURN
	END
C
	SUBROUTINE HP_FLUSH
C
CDEC$	IDENT	'30JL92'
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C
C Flush buffer
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
	IF (HPPTR.GT.0) THEN
	   CALL FLWSEL(PSLUN)
	   CALL FLWLIN(HPBUF,HPPTR)
	   HPPTR = 0
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE HP_BUFFER
C
CDEC$	IDENT	'30JL92'
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C
C Buffer up characters
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'HP.CMN'
C
C workspace
	INTEGER	I
C
	DO 10 I=1,EXPLEN
	   HPPTR = HPPTR+1
	   HPBUF(HPPTR) = EXPBUF(I)
	   IF (HPPTR.GE.HPMAX) CALL HP_FLUSH
10	CONTINUE
C
	RETURN
	END
C
	SUBROUTINE HP_BUFSTR(STR)
C
CDEC$	IDENT	'30JL92'
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C
C Buffer up characters
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C argument
	CHARACTER*(*)	STR
C
C workspace
	INTEGER	I
C
	DO 10 I=1,LEN(STR)
	   HPPTR = HPPTR+1
	   HPBUF(HPPTR) = ICHAR(STR(I:I))
	   IF (HPPTR.GE.HPMAX) CALL HP_FLUSH
10	CONTINUE
C
	RETURN
	END
C
	SUBROUTINE HP_SETPEN(COLI)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'HP.CMN'
C
C argument
	INTEGER	COLI
C
	IF (COLI.NE.PSCOL) THEN
	   PSCOL = COLI
	   IF (.NOT.PE) THEN
	      PE = .TRUE.
	      CALL HP_BUFSTR('PE')
	   ENDIF
	   CALL HP_BUFSTR(':')	! PE select pen flag
	   CALL HP_ENCODE(PSCOL)
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_BEGIN_FEATURE
C
CDEC$	IDENT	'04MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	RETURN
	END
C
	SUBROUTINE PS_END_FEATURE
C
CDEC$	IDENT	'04MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	RETURN
	END
