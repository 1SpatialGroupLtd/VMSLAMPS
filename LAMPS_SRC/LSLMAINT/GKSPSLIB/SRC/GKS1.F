C 	CONTROL FUNCTIONS
C	=================
C
	SUBROUTINE	GOPKS(ERRFIL)
C
CDEC$	IDENT	'18NO97'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
	IMPLICIT NONE
C
	EXTERNAL GKSBLK		! ensure that block data is linked in
C
C OPEN GKS	- includes initialising of data structures and variables
C
C Arguments:
	INTEGER	ERRFIL			! error message file
C
	INCLUDE	'GKSDAT1.CMN'
C
C Set up initial indices and  default modes
	TRNCUR	= 1		! use normalisation transformation 0
	PLIND	= 1		! use polyline bundle table 1
	ENCLIP	= .TRUE.	! enable clipping
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GCLKS
C
CDEC$	IDENT	'27JL83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
C CLOSE GKS	
C
	IMPLICIT NONE
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GOPWK(WKID,CONID,WTYPE)
C
CDEC$	IDENT	'27NO84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-Jul-1983
C Add initialise fill area update		TJI	27-Nov-1984
C
C OPEN WORKSTATION   - sets up World Coordinates and Normalised Device
C			  Coordinates to be 1 metre on the film with the
C			  origin at the bottom left hand corner
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
	INTEGER	CONID			! connection-identifier
	INTEGER	WTYPE			! workstation type
C
C Functions called
	INTEGER	PS_OPEN
C
C workspace
	INTEGER	I
C
	WKIDS = WKID
	WTYPES = WTYPE
	DEFER = GASTI	! deferral mode is At Some TIme
	REGEN = GSUPPD	! implicit regeneration suppressed
	UPTRN = .TRUE.	! update transformation
	UPLIN = .TRUE.	! update polyline attributes
	UPFA  = .TRUE.	! update fill area attributes
	UPTX  = .TRUE.	! update text attributes
C
	MAXCOL = 255			! allow 0-255 (8 planes)
C
	CCOLI = -1	! ensure colour set first time round
	CACOLI = -1
	CLWID = 0.0	! and linewidth
	CLTYPE = -1
	CCAP = -1
	CJOIN = -1
	CCHFNT = -1	! and text font
C
C initialise the colour table
	RGB(0,1) = 1.0		! colour 0 is white (paper)
	RGB(0,2) = 1.0
	RGB(0,3) = 1.0
	DO 10 I=1,255
	   RGB(I,1) = 0.0	! and all the others are black
	   RGB(I,2) = 0.0
	   RGB(I,3) = 0.0
10	CONTINUE
C
	IF (.NOT.PS_OPEN(WKID,GNOMLW,HWFMAX)) GOTO 999
C
C begin first page
	CALL PS_PAGE
C
999	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GKS_GET_LOGICALS(NAME,DEF,DX,DY,RX,RY)
C
CDEC$	IDENT	'27NO84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					CCB	28-Jul-1992
C
C Set up defaults according to various logical names
C 
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
	CHARACTER*(*)	NAME
	LOGICAL		DEF		! are sizes default?
	REAL		DX,DY		! size in device coords (metres)
	REAL		RX,RY		! size in raster coords (pixels)
C
C Functions called
	INTEGER	TRNALL		! LSLLIB, translate logical name
	LOGICAL	RDREAL		! LSLLIB, read real number
	LOGICAL	RDLONG		! LSLLIB, read long integer
C
C Local variables
	INTEGER	OK
	CHARACTER*10	TRAN
C
C check for hardware fill
	HWFILL = .TRUE.			! assume yes
	IF (TRNALL('LSL$'//NAME//'_HW_FILL',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(OK)) THEN
	      CALL TTWSTR('Error translating LSL$'//NAME//
     &				'_HW_FILL - using default value')
	   ELSEIF (OK.NE.0.AND.OK.NE.1) THEN
	      CALL TTWSTR('Value of LSL$'//NAME//
     &		'_HW_FILL must be 0 or 1 - using default value')
	   ELSEIF (OK.EQ.0) THEN
	      HWFILL = .FALSE.
	   ENDIF
	ENDIF
C
C check for solid fill boundary invisible lines
	FILLIV = .FALSE.		! assume no
	IF (TRNALL('LSL$'//NAME//'_FILL_INVIS',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(OK)) THEN
	      CALL TTWSTR('Error translating LSL$'//NAME//
     &				'_FILL_INVIS - using default value')
	   ELSEIF (OK.NE.0.AND.OK.NE.1) THEN
	      CALL TTWSTR('Value of LSL$'//NAME//
     &		'_FILL_INVIS must be 0 or 1 - using default value')
	   ELSEIF (OK.EQ.1) THEN
	      FILLIV = .TRUE.
	   ENDIF
	ENDIF
C
C try for an expand factor from LSL$'//NAME//'_EXPAND (default 0.0)
	RASEXP = 0.0
	IF (TRNALL('LSL$'//NAME//'_EXPAND',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDREAL(RASEXP)) THEN
	      CALL TTWSTR('Error translating LSL$'//NAME//
     &				'_EXPAND - using default value')
	      RASEXP = 0.0
	   ELSEIF (RASEXP.LE.0.0) THEN
	      CALL TTWSTR('Value for LSL$'//NAME//
     &		'_EXPAND must be >0.0 - using default value')
	      RASEXP = 0.0
	   ENDIF
	ENDIF
C
C set size, and number of pixels
	CALL LSG_SIZE('LSL$'//NAME//'_SIZE:',DEF,DX,DY,RX,RY)
C
	BEGIN_FEATURE = .FALSE.
	FEATURE_BEGUN = .FALSE.
	LAYER_BEGUN = .FALSE.
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GCLWK(WKID)
C
CDEC$	IDENT	'27JL83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
C CLOSE WORKSTATION
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
C
	IF (FEATURE_BEGUN) CALL LSG_END_FEATURE
	IF (LAYER_BEGUN) CALL PS_END_FEATURE
	LAYER_BEGUN = .FALSE.
	CALL PS_SHOW			! print last page
	CALL PS_CLOSE			! close the file
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GACWK(WKID)
C
CDEC$	IDENT	'27JL83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
C ACTIVATE WORKSTATION
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
C
	INCLUDE	'GKSDAT1.CMN'
C
	WSACT = .TRUE.
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GDAWK(WKID)
C
CDEC$	IDENT	'27JL83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
C DEACTIVATE WORKSTATION
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
C
	INCLUDE	'GKSDAT1.CMN'
C
	WSACT = .FALSE.
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GCLRWK(WKID,COFL)
C
CDEC$	IDENT	'29FE84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					RD	14-Nov-1983
C
C CLEAR WORKSTATION
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
	INTEGER COFL			! control flag
C
	IF (FEATURE_BEGUN) CALL LSG_END_FEATURE
	IF (LAYER_BEGUN) CALL PS_END_FEATURE
	LAYER_BEGUN = .FALSE.
	CALL PS_SHOW			! print old page
	CALL PS_PAGE			! begin new page
	CCOLI = -1	! ensure colour set first time round
	CACOLI = -1
	CLWID = 0.0	! and linewidth
	CLTYPE = -1
	CCAP = -1
	CJOIN = -1
	CCHFNT = -1	! and text font
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GUWK(WKID,REGFL)
C
CDEC$	IDENT	'16MY84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					CCB	16-May-1984
C
C UPDATE WORKSTATION
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
	INTEGER	REGFL			! regeneration flag
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GSDS(WKID,DEFMOD,REGMOD)
C
CDEC$	IDENT	'27JL83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
C SET DEFERRAL STATE
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
	INTEGER	DEFMOD			! deferral mode
	INTEGER	REGMOD			! implicit regeneration mode
C
	INCLUDE	'GKSDAT1.CMN'
C
	IF (DEFMOD .GE. GASAP .AND. DEFMOD .LE. GASTI) THEN
	   DEFER = DEFMOD
C
C nasty call to GUWK (second argument ignored)
	   IF (DEFER.EQ.GASAP.AND.WSACT) CALL GUWK(WKID,0)
	ENDIF
C
	IF (REGMOD .GE. GSUPPD .AND. REGMOD .LE. GALLOW) THEN
	   REGEN= REGMOD
	ENDIF
C
	RETURN
	END
C
C***********************************************************************
C
C	OUTPUT FUNCTIONS
C	================
C
	SUBROUTINE	GPL(N,PX,PY)
C
CDEC$	IDENT	'28OC83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
C POLYLINE
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER N			! number of points
	REAL	PX(N)			! X coords of points in WC
	REAL	PY(N)			! Y coords of points in WC
C
	INCLUDE	'GKSDAT1.CMN'
C
C Functions:
	LOGICAL	GKCLIP			! clips a straight line to
					! rectangular boundaries
C
C Internal variables:
	INTEGER	I			! loop variable
	REAL	PX1,PX2,PY1,PY2		! X and Y coordinates
	REAL	CURX,CURY		! current position
C
	IF (N.LT.2) THEN
	   CALL GKSERR(100,'GPL')
	   GOTO 9999
	ENDIF
C
C Is this workstation active?
	IF (.NOT.WSACT) GOTO 100
C
C Make sure transformation is up to date
	IF (UPTRN) CALL GUPTRN
C
C Is everything clipped ?
	IF (CLPALL) GOTO 100
C
C unset current position to force move
	CURX = 1E38
	CURY = 1E38
C
C Loop for each segment of this polyline.
	DO 90 I = 1, N-1
	   PX1 = PX(I)
	   PY1 = PY(I)
	   PX2 = PX(I+1)
	   PY2 = PY(I+1)
	   IF (ENCLIP) THEN
	      IF (GKCLIP(PX1,PY1,PX2,PY2)) GOTO 90
	   ENDIF
C
C Make sure polyline attributes are up to date
	IF (UPLIN) CALL GUPLIN
C transform World Coordinates to Workstation Device Coordinates
	   PX1 = (PX1*SCALEX)+OFFX
	   PX2 = (PX2*SCALEX)+OFFX
	   PY1 = (PY1*SCALEY)+OFFY
	   PY2 = (PY2*SCALEY)+OFFY
	   IF (PX1.NE.CURX.OR.PY1.NE.CURY) THEN
	      CALL PS_MOVE(PX1,PY1,((I.EQ.1).AND.N.GT.2))	! move
	   ENDIF
	   CALL PS_LINE(PX2,PY2)	! draw line
	   CURX = PX2			! update current position
	   CURY = PY2
90	CONTINUE
100	CONTINUE
C
9999	RETURN
	END
C
C***********************************************************************
C
C	OUTPUT ATTRIBUTES (Workstation independent primitive attributes)
C	=================
C
C
	SUBROUTINE	GSPLI(INDEX)
C
CDEC$	IDENT	'29FE84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
C SET POLYLINE INDEX
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	INDEX			! polyline index
C
	INCLUDE	'GKSDAT1.CMN'
C
	IF (INDEX .LT. 1 .OR. INDEX .GT. PLMAX) THEN
	   CALL GKSERR(60,'GSPLI')	! polyline index is invalid
	ELSEIF (INDEX.NE.PLIND) THEN	! if current already, ignore
	   PLIND = INDEX		! set it to current index
	   UPLIN = .TRUE.		! attributes need updating
	ENDIF
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GSLN(LTYPE)
C
CDEC$	IDENT	'26AP84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C SET LINETYPE
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	LTYPE			! linetype
C
	INCLUDE	'GKSDAT1.CMN'
C
	IF (LTYPE.LE.0) THEN
	   CALL GKSERR(62,'GSLN')	! linetype .LE. 0
	ELSE
	   ILTYPE = LTYPE
	   UPLIN = .TRUE.		! attributes need updating
	ENDIF
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GSLWSC(LWIDTH)
C
CDEC$	IDENT	'26AP84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C SET LINEWIDTH SCALE FACTOR
C
	IMPLICIT NONE
C
C Arguments:
	REAL	LWIDTH			! linewidth scale factor
C
	INCLUDE	'GKSDAT1.CMN'
C
	IF (LWIDTH.LE.0.0) THEN
	   CALL GKSERR(90,'GSLWSC')	! linewidth scale factor .LE. 0
	ELSE
	   ILWID = LWIDTH
	   UPLIN = .TRUE.		! attributes need updating
	ENDIF
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GSPLCI(COLI)
C
CDEC$	IDENT	'26AP84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C SET POLYLINE COLOUR INDEX
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	COLI			! polyline colour index
C
	INCLUDE	'GKSDAT1.CMN'
C
	IF (COLI.LT.0) THEN
	   CALL GKSERR(85,'GSPLCI')	! colour index .LT. 0
	ELSE
	   ICOLI = COLI
	   UPLIN = .TRUE.		! attributes need updating
	ENDIF
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GSASF(LASF)
C
CDEC$	IDENT	'27NO84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C Update of fill area required, too	Tony J Ibbs	27-Nov-1984
C
C SET ASPECT SOURCE FLAGS
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
	INTEGER	LASF(ASFMAX)			! list of flags
C
	INTEGER	I				! loop counter
C
	DO 11 I=1,ASFMAX
	   GASF(I) = LASF(I)
11	CONTINUE
	UPLIN = .TRUE.		! polyline attributes need updating
	UPFA  = .TRUE.		! also fill area attributes
C
	RETURN
	END
C
C***********************************************************************
C
C	WORKSTATION ATTRIBUTES (Representations)
C	========================================
C
C
	SUBROUTINE	GSPLR(WKID,PLI,LTYPE,LWIDTH,COLI)
C
CDEC$	IDENT	'29FE84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-Jul-1983
C Colour added					PGH	29-Feb-1984
C
C SET POLYLINE REPRESENTATION
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
	INTEGER	PLI			! polyline index
	INTEGER	LTYPE			! linetype
	REAL	LWIDTH			! line width scale factor
	INTEGER	COLI			! colour index
C
	INCLUDE	'GKSDAT1.CMN'
C
	INTEGER	ERR
C
	ERR = 0
	IF (PLI .LT. 1 .OR. PLI .GT. PLMAX ) THEN
	   ERR = 60
	ELSEIF (LTYPE .LE. 0) THEN
	   ERR = 62
	ELSEIF (LWIDTH .LE. 0) THEN
	   ERR = 90
	ELSEIF (COLI .LT. 0 ) THEN
	   ERR = 86
	ELSE
	   PLTYPE(PLI) = LTYPE		! store values in bundle table
	   PLWDTH(PLI) = LWIDTH
	   PLCOL(PLI)  = COLI
	   IF (PLI .EQ. PLIND) UPLIN = .TRUE. ! apply if current index
	ENDIF
C
	IF (ERR.NE.0) CALL GKSERR(ERR,'GSPLR')
C
	RETURN
	END
C
	SUBROUTINE	GSCR(WKID,CI,RED,GREEN,BLUE)
C
CDEC$	IDENT	'26AU86'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					CCB	25-Jul-1985
C
C SET COLOUR REPRESENTATION
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
	INTEGER	CI			! colour index
	REAL	RED,GREEN,BLUE		! colour values
C
	INCLUDE	'GKSDAT1.CMN'
C
	IF (CI.LT.0.OR.CI.GT.MAXCOL)THEN
	   CALL GKSERR(93,'GSCR')		! colour index is invalid
	ELSEIF (RED.LT.0.0.OR.RED.GT.1.0.OR.
     &		GREEN.LT.0.0.OR.GREEN.GT.1.0.OR.
     &		BLUE.LT.0.0.OR.BLUE.GT.1.0) THEN
	   CALL GKSERR(96,'GSCR')		! colour out of range
	ELSE
C
C set the colour (just for solid areas here - lines set as needed)
	   RGB(CI,1) = RED
	   RGB(CI,2) = GREEN
	   RGB(CI,3) = BLUE
	   CALL PS_DEFRGB(CI,RED,GREEN,BLUE)
	ENDIF
C
	RETURN
C
	END
C
C***********************************************************************
C
C	TRANSFORMATION FUNCTIONS
C	========================
C
C
	SUBROUTINE	GSWN(TRN,XMIN,XMAX,YMIN,YMAX)
C
CDEC$	IDENT	'27JL83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
C SET WINDOW 
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	TRN			! window number
	REAL	XMIN,XMAX,YMIN,YMAX	! rectangular boundaries
C
	INCLUDE	'GKSDAT1.CMN'
C
	INTEGER TRNTMP			! temporary copy of TRN so as
C					! not to pass back new value.
C
	TRNTMP=TRN+1			! convert to Fortran index
	IF (TRNTMP .LT. 1 .OR. TRNTMP .GT. TRNMAX) THEN
	   CALL GKSERR(50,'GSWN')
	ELSEIF (XMAX .LE. XMIN .OR. YMAX .LE. YMIN) THEN
	   CALL GKSERR(51,'GSWN')
	ELSE
	   WINDOW(1,TRNTMP) = XMIN
	   WINDOW(2,TRNTMP) = XMAX
	   WINDOW(3,TRNTMP) = YMIN
	   WINDOW(4,TRNTMP) = YMAX
	   UPTRN = .TRUE.		! transformation needs updating
	ENDIF
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GSVP(TRN,XMIN,XMAX,YMIN,YMAX)
C
CDEC$	IDENT	'27JL83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
C SET VIEWPORT
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	TRN			! viewport number
	REAL	XMIN,XMAX,YMIN,YMAX	! rectangular boundaries
C
	INCLUDE	'GKSDAT1.CMN'
C
	INTEGER TRNTMP			! temporary copy of TRN so as
C					! not to pass back new value.
C
	TRNTMP = TRN+1			! convert to Fortran index
	IF (TRNTMP .LT. 1 .OR. TRNTMP .GT. TRNMAX) THEN
	   CALL GKSERR(50,'GSVP')
	ELSEIF (XMAX .LE. XMIN .OR. YMAX .LE. YMIN) THEN
	   CALL GKSERR(51,'GSVP')
	ELSEIF (XMIN .LT. 0.0 .OR. XMAX .GT. 1.0 .OR.
     &	    YMIN .LT. 0.0 .OR. YMAX .GT. 1.0) THEN
	   CALL GKSERR(53,'GSVP')
	ELSE
	   VIEWPT(1,TRNTMP) = XMIN
	   VIEWPT(2,TRNTMP) = XMAX
	   VIEWPT(3,TRNTMP) = YMIN
	   VIEWPT(4,TRNTMP) = YMAX
	   UPTRN = .TRUE.		! transformation needs updating
	ENDIF
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GSWKWN(WKID,XMIN,XMAX,YMIN,YMAX)
C
CDEC$	IDENT	'27OC83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					RD	27-Oct-1983
C
C SET WORKSTATION WINDOW
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
	REAL	XMIN,XMAX,YMIN,YMAX	! rectangular boundaries
C
	INCLUDE	'GKSDAT1.CMN'
C
	IF (XMAX .LE. XMIN .OR. YMAX .LE. YMIN) THEN
	   CALL GKSERR(51,'GSWKWN')
	ELSEIF (XMIN .LT. 0.0 .OR. XMAX .GT. 1.0 .OR.
     &	    YMIN .LT. 0.0 .OR. YMAX .GT. 1.0) THEN
	   CALL GKSERR(53,'GSWKWN')
	ELSE
	   WSWIN(1) = XMIN
	   WSWIN(2) = XMAX
	   WSWIN(3) = YMIN
	   WSWIN(4) = YMAX
	   UPTRN = .TRUE.
	ENDIF
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GSWKVP(WKID,XMIN,XMAX,YMIN,YMAX)
C
CDEC$	IDENT	'27OC83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					RD	27-Oct-1983
C
C SET WORKSTATION VIEWPORT
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
	REAL	XMIN,XMAX,YMIN,YMAX	! rectangular boundaries
C
	INCLUDE	'GKSDAT1.CMN'
C
	IF (XMAX .LE. XMIN .OR. YMAX .LE. YMIN) THEN
	   CALL GKSERR(51,'GSWKVP')
	ELSEIF (((XMAX-XMIN) .GT. DCMAXX) .OR.
     &	    ((YMAX-YMIN) .GT. DCMAXY)) THEN
	   CALL GKSERR(54,'GSWKVP')
	ELSE
	   WSVIEW(1) = XMIN
	   WSVIEW(2) = XMAX
	   WSVIEW(3) = YMIN
	   WSVIEW(4) = YMAX
	   UPTRN = .TRUE.
	ENDIF
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GSELNT(TRN)
C
CDEC$	IDENT	'27OC83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	27-July-1983
C
C SELECT NORMALISATION TRANSFORMATION
C and set clipping limits to viewport
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	TRN			! transformation number
C
	INCLUDE	'GKSDAT1.CMN'
C
	INTEGER TRNTMP		! temporary copy of TRN so as not to
C				! pass back new value
	TRNTMP=TRN+1			! convert to Fortran index
	IF (TRNTMP .LT. 1 .OR. TRNTMP .GT.TRNMAX) THEN
	   CALL GKSERR(50,'GSELNT')
	ELSE
	   TRNCUR = TRNTMP		! set currently selected
C					! normalisation transformation
	   UPTRN = .TRUE.		! transformation needs updating
	ENDIF
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE	GSCLIP(CLSW)
C
CDEC$	IDENT	'31JL84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					CCB	31-July-1984
C
C SET CLIPPING INDICATOR
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	CLSW			! clipping indicator
C
	INCLUDE	'GKSDAT1.CMN'
C
	ENCLIP = (CLSW.EQ.GCLIP)
	RETURN
C
	END
C
C***********************************************************************
C
C	INQUIRY FUNCTIONS
C	=================
C
	SUBROUTINE GQASF(ERRIND,LASF)
C
CDEC$	IDENT	'27NO84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					CCB	 1-May-1984
C Allow up to ASFMAX returns now		TJI	17-Nov-1984
C
C INQUIRE ASPECT SOURCE FLAGS
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
	INTEGER	ERRIND		! Error indicator
	INTEGER	LASF(ASFMAX)	! Aspect source flags
C
	INTEGER	I
C
	ERRIND = 0		! only give indications of them !!
C
	DO 11 I=1,ASFMAX
	   LASF(I) = GASF(I)
11	CONTINUE
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE GQMDS(WTYPE,ERRIND,COOUNI,RX,RY,LX,LY)
C
CDEC$	IDENT	'14SE83'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					SCM	14-Sept-1983
C
C INQUIRE MAXIMUM DISPLAY SURFACE SIZE
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WTYPE		! Workstation type
	INTEGER	ERRIND		! Error indicator
	INTEGER	COOUNI		! Device Coordinate Units
	REAL	RX,RY		! Max. display surface size in DC
	INTEGER	LX,LY		! no. of device units in X and Y
C
	INCLUDE	'GKSDAT1.CMN'
C
	ERRIND = 0		! only give indications of them !!
C
	COOUNI = GMETRE		! units are in metres
	RX = DCMAXX		! film size in metres
	RY = DCMAXY
	LX  = NINT(RASTX)	! and in pixels
	LY  = NINT(RASTY)
C
	RETURN
	END
C
C
C***********************************************************************
C
	SUBROUTINE GQPLF(
     &		WTYPE,N,ERRIND,NLT,LT,NLW,NOMLW,RLWMIN,RLWMAX,NPPLI)
C
CDEC$	IDENT	'16MY84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					CCB	16-May-1984
C
C INQUIRE POLYLINE FACILITIES
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WTYPE		! Workstation type
	INTEGER	N		! list element requested
	INTEGER	ERRIND		! Error indicator
	INTEGER NLT		! number of available linetypes
	INTEGER	LT		! N'th element of available linetypes
	INTEGER NLW		! number of available linewidths
	REAL	NOMLW		! nominal linewidth (DC)
	REAL	RLWMIN,RLWMAX	! range of linewidths
	INTEGER	NPPLI		! number of predefined polyline indices
C
	INCLUDE	'GKSDAT1.CMN'
C
	ERRIND = 0		! only give indications of them !!
C
	NLT = 4			! number of linetypes
	LT = N			! just return N as N'th type
	NLW = 0			! continuous range of linewidths
	NOMLW = GNOMLW		! nominal linewidth in DC
	RLWMIN = NOMLW		! also the minimum
	RLWMAX = 16.0*NOMLW	! rather arbitrary maximum
	NPPLI = PLMAX
C
	RETURN
	END
C
C
C***********************************************************************
C
	SUBROUTINE GQLN(ERRIND,LTYPE)
C
CDEC$	IDENT	'01MA84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					CCB	1-May-1984
C
C INQUIRE LINETYPE
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	ERRIND		! Error indicator
	INTEGER	LTYPE		! line type
C
	INCLUDE	'GKSDAT1.CMN'
C
	ERRIND = 0		! only give indications of them !!
C
	LTYPE = ILTYPE
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE GQLWSC(ERRIND,LWIDTH)
C
CDEC$	IDENT	'01MA84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					CCB	1-May-1984
C
C INQUIRE LINE WIDTH SCALE FACTOR
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	ERRIND		! Error indicator
	REAL	LWIDTH		! line width scale factor
C
	INCLUDE	'GKSDAT1.CMN'
C
	ERRIND = 0		! only give indications of them !!
C
	LWIDTH = ILWID
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE GQPLCI(ERRIND,COLI)
C
CDEC$	IDENT	'01MA84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					CCB	1-May-1984
C
C INQUIRE POLYLINE COLOUR INDEX
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	ERRIND		! Error indicator
	INTEGER	COLI		! polyline colour index
C
	INCLUDE	'GKSDAT1.CMN'
C
	ERRIND = 0		! only give indications of them !!
C
	COLI = ICOLI
C
	RETURN
	END
C
	SUBROUTINE	GQCR(WKID,CI,TYPE,ERRIND,RED,GREEN,BLUE)
C
CDEC$	IDENT	'26AU86'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created					CCB	25-Jul-1985
C
C INQUIRE COLOUR REPRESENTATION
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	WKID			! workstation-identifier
	INTEGER	CI			! colour index
	INTEGER	TYPE			! type of values (unused)
	INTEGER	ERRIND			! error indicator
	REAL	RED,GREEN,BLUE		! colour values
C
	INCLUDE	'GKSDAT1.CMN'
C
	ERRIND = 0
C
	IF (CI.LT.0.OR.CI.GT.MAXCOL)THEN
	   ERRIND	= 86		! colour index is invalid
	ELSE
	   RED = RGB(CI,1)
	   GREEN = RGB(CI,2)
	   BLUE = RGB(CI,3)
	ENDIF
C
	RETURN
C
	END
C
C***********************************************************************
C
C	GKSLDLIB UTILITIES
C	==================
C
	SUBROUTINE GUPTRN
C
CDEC$	IDENT	'19SE84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	19-Sep-1984
C
C Update the tranformation
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C w/s
	REAL	NDCSCX,NDCSCY	! scaling part of WC to NDC transform
	REAL	NDCOFX,NDCOFY	! offset  part of WC to NDC transform
	REAL	DCSC		! scaling part of NDC to DC transform
	REAL	DCOFX, DCOFY	! offset  part of NDC to DC transform
C
C Work out the scaling factor and offset for WC to NDC transformation.
C Effective formula for transforming a coord is:-
C	XN = XVMIN + (XW-XWMIN) * ((XVMAX-XVMIN)/(XWMAX-XWMIN))
C	YN = YVMIN + (YW-YWMIN) * ((YVMAX-YVMIN)/(YWMAX-YWMIN))
C
C This formula needs to be put into the form:-
C	XN = (XW*NDCSCX) + NDCOFX
C	YN = (YW*NDCSCY) + NDCOFY
C
	NDCSCX = (VIEWPT(2,TRNCUR)-VIEWPT(1,TRNCUR))
     &		/(WINDOW(2,TRNCUR)-WINDOW(1,TRNCUR))
	NDCSCY = (VIEWPT(4,TRNCUR)-VIEWPT(3,TRNCUR))
     &		/(WINDOW(4,TRNCUR)-WINDOW(3,TRNCUR))
	NDCOFX = VIEWPT(1,TRNCUR) - (WINDOW(1,TRNCUR)*NDCSCX)
	NDCOFY = VIEWPT(3,TRNCUR) - (WINDOW(3,TRNCUR)*NDCSCY)
C
C A similar formula has to be used to transform NDC to DC with the
C difference that the shape of the workstation window has to be
C preserved within the workstation viewport (bottom left corner
C is fixed).
	DCSC = MIN(((WSVIEW(2)-WSVIEW(1))
     &		   /(WSWIN (2)-WSWIN (1)))
     &		  ,((WSVIEW(4)-WSVIEW(3))
     &		   /(WSWIN (4)-WSWIN (3))))
	DCOFX = WSVIEW(1) - (WSWIN(1)*DCSC)
	DCOFY = WSVIEW(3) - (WSWIN(3)*DCSC)
C
C Both transformations have to be combined in the form:-
C	XD = (((XW*NDCSCX*DCSC) + (NDCOFX*DCSC)+DCOFX
C	YD = (((YW*NDCSCY*DCSC) + (NDCOFY*DCSC)+DCOFY
C
	SCALEX = NDCSCX * DCSC
	SCALEY = NDCSCY * DCSC
C
	OFFX = (NDCOFX*DCSC) + DCOFX
	OFFY = (NDCOFY*DCSC) + DCOFY
C
C Work out the clipping limits.
C These correspond to the area of overlap in NDC space between
C the viewport and the workstation window transformations.
C Logical variable CLPALL is set if there is no overlap.
	CLPALL = .FALSE.
C Is there any overlap at all?
	IF ((VIEWPT(1,TRNCUR).GT.WSWIN(2))
     &  .OR.(VIEWPT(2,TRNCUR).LE.WSWIN(1))
     &  .OR.(VIEWPT(3,TRNCUR).GT.WSWIN(4))
     &  .OR.(VIEWPT(4,TRNCUR).LE.WSWIN(3))) GOTO 5
C
C Define the clipping limits to be the overlapping rectangle.
	CLIPLO(1) = MAX(VIEWPT(1,TRNCUR),WSWIN(1))	! W
	CLIPHI(1) = MIN(VIEWPT(2,TRNCUR),WSWIN(2))	! E
	CLIPLO(2) = MAX(VIEWPT(3,TRNCUR),WSWIN(3))	! S
	CLIPHI(2) = MIN(VIEWPT(4,TRNCUR),WSWIN(4))	! N
C
C Transform the clipping limits into WC space so that clipping can
C be done before transforming coordinates. This is not GKS standard.
C To do this we use the formulas:-
C	XW = (XN-NDCOFX) / NDCSCX
C	YW = (YN-NDCOFY) / NDCSCY
C
	CLIPLO(1) = (CLIPLO(1)-NDCOFX) / NDCSCX
	CLIPHI(1) = (CLIPHI(1)-NDCOFX) / NDCSCX
	CLIPLO(2) = (CLIPLO(2)-NDCOFY) / NDCSCY
	CLIPHI(2) = (CLIPHI(2)-NDCOFY) / NDCSCY
	GOTO 20
C
C No overlap
5	CLPALL = .TRUE.
C
C the transformation is now up to date
20	UPTRN = .FALSE.
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE GUPLIN
C
CDEC$	IDENT	'27NO84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C Take account of need to set UPFA	Tony J Ibbs	27-Nov-1984
C
C Update the polyline attributes
C
	IMPLICIT NONE
C
C local variables
	INTEGER	NLTYPE,NCOLI
	REAL	NLWID
	INTEGER	NSYM,NCAP,NJOIN
	LOGICAL	FST
C
	INCLUDE	'GKSDAT1.CMN'
C
	IF (GASF(1).EQ.GBUNDL) THEN
	   NLTYPE = PLTYPE(PLIND)
	ELSE
	   NLTYPE = ILTYPE
	ENDIF
C
	IF (GASF(2).EQ.GBUNDL) THEN
	   NLWID = PLWDTH(PLIND)
	ELSE
	   NLWID = ILWID
	ENDIF
C
	IF (GASF(3).EQ.GBUNDL) THEN
	   NCOLI = PLCOL(PLIND)
	ELSE
	   NCOLI = ICOLI
	ENDIF
C
	IF (NCOLI.NE.0) THEN
	   FST = .FALSE.
10	   FST = .NOT.FST
	   IF (POFF.NE.0) NCOLI = ISHFT(NCOLI,POFF)! apply offset
	   NCOLI = NCOLI.AND.PSEL.AND.'FF'X	! apply mask
	   IF (NCOLI.GT.MAXCOL.OR.NCOLI.EQ.0) THEN
C
C First attempt, try again with colour 1, otherwise just use 1
	      NCOLI = 1
	      IF (FST) GOTO 10
	   ENDIF
	   IF (NCOLI.EQ.0) NCOLI = 1
	ENDIF
C
	NSYM = ISYM-1
	NJOIN = NSYM/10
	NCAP = NSYM - NJOIN*10
C
	IF (NJOIN.GT.2) NJOIN = 0
	IF (NCAP.GT.2) NCAP = 0
C
	IF (BEGIN_FEATURE .OR.
     &	    NLWID.NE.CLWID .OR. NCOLI.NE.CCOLI .OR.
     &	    (NLTYPE.NE.CLTYPE.OR.NLTYPE.EQ.1000) .OR.
     &	    NJOIN.NE.CJOIN .OR. NCAP.NE.CCAP) THEN
C
	   CALL PS_FLUSH(.FALSE.,.FALSE.)
C
	   IF (BEGIN_FEATURE) THEN
	      BEGIN_FEATURE = .FALSE.
	      FEATURE_BEGUN = .TRUE.
	      CALL PS_BEGIN_FEATURE
	   ENDIF
C
	   IF (NLWID.NE.CLWID) THEN
	      CLWID = NLWID
	      IF (NLWID.NE.FALWID) UPFA = .TRUE.	! check fill area
	      CALL PS_SETWID(CLWID)
	   ENDIF
C
	   IF (NCOLI.NE.CCOLI) THEN
	      CCOLI = NCOLI
	      IF (CCOLI.NE.CACOLI) CACOLI = -1
	      UPFA  = .TRUE.			! and fill area update
	      UPTX  = .TRUE.			! and text update
	      CALL PS_SETCOL(CCOLI,.FALSE.)
	   ENDIF
C
	   IF (NLTYPE.NE.CLTYPE) THEN
	      CLTYPE = NLTYPE
	      IF (CLTYPE.NE.FALTYP) UPFA = .TRUE.! check fill area
	      CALL PS_SETTYP(CLTYPE)
	   ENDIF
	   IF (NLTYPE.EQ.1000) THEN
	      CUR_PECKC = PAT_PECKC
	      CUR_REP1 = PAT_REP1
	      CUR_REP2 = PAT_REP2
	      CUR_PECK1 = PAT_PECK1
	      CUR_PECK2 = PAT_PECK2
	      CUR_GAP = PAT_GAP
	      CALL PS_SETPAT(
     &		CUR_PECKC,CUR_REP1,CUR_REP2,CUR_PECK1,CUR_PECK2,CUR_GAP)
	   ENDIF
C
	   IF (NJOIN.NE.CJOIN .OR. NCAP.NE.CCAP) THEN
	      CJOIN = NJOIN
	      CCAP = NCAP
	      CALL PS_SETJC(CJOIN,CCAP)
	   ENDIF
C
	ENDIF
C
	UPLIN = .FALSE.		! polyline now up to date
	RETURN
	END
C
C***********************************************************************
C
	LOGICAL FUNCTION GKCLIP(X1,Y1,X2,Y2)
C
CDEC$	IDENT	'23JL80'
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C Authors many and varied but mainly Paul Hardy based on algorithms
C by P. Woodsford and P.Cross, with tidies by R.Fairbairns
C
C Created July 1980
C
C to clip a straight line to rectangular boundaries.
C function value is TRUE if no visible result.
C
	IMPLICIT NONE
C
	REAL X1,Y1,X2,Y2	! coords of ends of line
C
	INCLUDE	'GKSDAT1.CMN'
C
	PARAMETER X=1,Y=2	! for clarity
C w/s
	REAL P(2,2)		! our copies of the points
	REAL D(2)		! DX,DY is line vector
	REAL R			! temp variable
	INTEGER DEP,INDEP	! X or Y depending which axis considered
	INTEGER HIGH,LOW	! 1 or 2 to indicate ends of line
C
C set everything up
	GKCLIP=.FALSE.			! assume visible result
	P(X,1)=X1			! take copy of args
	P(Y,1)=Y1
	P(X,2)=X2
	P(Y,2)=Y2
	D(X)=X2-X1			! calculate vector
	D(Y)=Y2-Y1
C
C now loop for both axes
	DO 30 DEP=X,Y
	   INDEP=3-DEP			! independent axis
	   LOW=1			! guess which end lowest
	   IF(D(INDEP).LT.0.0) LOW=2	! upside down
	   HIGH=3-LOW			! the other end
	   IF(P(INDEP,HIGH).LT.CLIPLO(INDEP)) GOTO 50 ! out bottom
	   IF(P(INDEP,LOW ).GT.CLIPHI(INDEP)) GOTO 50 ! out top
	   IF(D(INDEP).EQ.0.0) GOTO 30	! parallel to frame this axis
C
C here to consider low end
	   R=P(INDEP,LOW)-CLIPLO(INDEP) ! distance from frame
	   IF(R.GE.0.0) GOTO 20		! inside frame
C
C clip low end
	   P(DEP,LOW)=P(DEP,LOW)-R*D(DEP)/D(INDEP) ! similar triangles
	   P(INDEP,LOW)=CLIPLO(INDEP) ! push onto frame
C
C now lets consider the high end
20	   R=CLIPHI(INDEP)-P(INDEP,HIGH) ! distance from frame
	   IF(R.GE.0.0) GOTO 30		! inside frame
C
C clip high end
	   P(DEP,HIGH)=P(DEP,HIGH)+R*D(DEP)/D(INDEP) ! similar triangles
	   P(INDEP,HIGH)=CLIPHI(INDEP) ! push onto frame
C
30	   CONTINUE			! loop for both axes
C
C copy args back
	X1=P(X,1)
	Y1=P(Y,1)
	X2=P(X,2)
	Y2=P(Y,2)
40	RETURN
C
C here with all invisible
50	GKCLIP=.TRUE.
	GOTO 40
C
	END
C
C***********************************************************************
C
	SUBROUTINE GKSW2D(WKID,WX,WY,DX,DY)
C
CDEC$	IDENT	'10AU84'
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C Author: Clarke Brunt
C
C Created August 1984
C
C To convert world coordinate WX,WY to device coordinate DX,DY
C on workstation WKID
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C arguments
	INTEGER	WKID		! worstation identifier
	REAL	WX,WY		! input world coordinate
	REAL	DX,DY		! output device coordinate
C
C Make sure transformation is up to date
	IF (UPTRN) CALL GUPTRN
	DX = (WX*SCALEX)+OFFX
	DY = (WY*SCALEY)+OFFY
C
	RETURN
	END
C
C**********************************************************************
C
	SUBROUTINE GKSD2W(WKID,DX,DY,WX,WY)
C
CDEC$	IDENT	'10AU84'
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C Author: Clarke Brunt
C
C Created February 1985
C
C To convert device coordinate DX,DY to world coordinate WX,WY
C on workstation WKID
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C arguments
	INTEGER	WKID		! worstation identifier
	REAL	DX,DY		! input device coordinate
	REAL	WX,WY		! output world coordinate
C
C Make sure transformation is up to date
	IF (UPTRN) CALL GUPTRN
C
	WX = (DX-OFFX)/SCALEX
	WY = (DY-OFFY)/SCALEY
C
	RETURN
	END
C
C**********************************************************************
C
	SUBROUTINE GD2W(WKID,DX,DY,WX,WY)
C
CDEC$	IDENT	'10AU84'
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C Author: Clarke Brunt
C
C Created August 1984
C
C To scale device coordinate lengths DX,DY to world coordinate WX,WY
C on workstation WKID (only one in any case)
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C arguments
	INTEGER WKID		! for compatibility with 2 workstation
	REAL	DX,DY		! input device coordinate
	REAL	WX,WY		! output world coordinate
C
C Make sure transformation is up to date
	IF (UPTRN) CALL GUPTRN
C
	WX = DX / SCALEX
	WY = DY / SCALEY
C
	RETURN
	END
C
C**********************************************************************
C
	SUBROUTINE GW2D(WKID,WX,WY,DX,DY)
C
CDEC$	IDENT	'14MY84'
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C Author: Clarke Brunt
C
C Created May 1985
C
C To scale world coordinate lengths WX,WY to device coordinate DX,DY
C on workstation WKID (only one in any case)
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C arguments
	INTEGER WKID		! for compatibility with 2 workstation
	REAL	WX,WY		! input world coordinate
	REAL	DX,DY		! output device coordinate
C
C Make sure transformation is up to date
	IF (UPTRN) CALL GUPTRN
C
	DX = WX*SCALEX
	DY = WY*SCALEY
C
	RETURN
	END
C
C *********************************************************************
C
	SUBROUTINE	GESC(ESCID,DATA)
C
CDEC$	IDENT	'29MY86'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	9-May-1986
C
C ESCAPE
C
	IMPLICIT NONE
C
	INCLUDE	'GFADAT1.CMN'
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments
	INTEGER ESCID			! escape identifier
	INTEGER	DATA(2)			! other data
C
C Workspace
	INTEGER		IDATA
	REAL		RDATA
	LOGICAL*4	LDATA
	EQUIVALENCE	(IDATA,RDATA,LDATA)
C
	IDATA = DATA(1)	! copy into integer version
C
C Despatch on escape type
	GOTO (100,99999,300),ESCID
	GOTO (1000,99999,3000),ESCID-100
	GOTO (10001,10002),ESCID-1000
	GOTO (10010,10011),ESCID-1009
	CALL GKSERR(180,'GESC')		! function not supported
	GOTO 99999
C
C Set 'marker type' for lines (as for GSMK)
100	ISYM = IDATA
	UPLIN = .TRUE.
	UPFA = .TRUE.
	GOTO 99999
C
C Set fill area line width and spacing
300	CONTINUE
C
C Zero width will cause the nominal width to be used
C If spacing is less than width, then set a sensible value
C
	IF (RDATA.GE.0.0) GFAWID = RDATA
	IDATA = DATA(2)
	GFAGAP = RDATA
	IF (GFAGAP.LT.GFAWID) GFAGAP = 2.0*GFAWID
	GOTO 99999
C
C Inquire 'marker type' for lines (as for GSMK)
1000	IDATA = ISYM
	GOTO 9000
C
C Inquire fill area line width and spacing
3000	RDATA = GFAGAP
	DATA(2) = IDATA
	RDATA = GFAWID
	GOTO 9000
C
C Begin a new feature grouping
10001	IF (FEATURE_BEGUN) CALL LSG_END_FEATURE
	IF (LAYER_BEGUN) CALL PS_END_FEATURE
	LAYER_BEGUN = .TRUE.
	CALL PS_BEGIN_FEATURE
	GOTO 99999
C
C End a feature grouping
10002	IF (FEATURE_BEGUN) CALL LSG_END_FEATURE
	IF (LAYER_BEGUN) CALL PS_END_FEATURE
	LAYER_BEGUN = .FALSE.
	GOTO 99999
C
C Set new colour table
C (DATA is a char string descriptor for this, so check
C  zero length, and ignore)
10010	IF ((DATA(1).AND.'FFFF'X).EQ.0) GOTO 99999
	CALL PS_FLUSH(.FALSE.,.FALSE.)
	CALL LSG_SET_LUT(0,DATA)
	GOTO 99999
C
C Begin a separation
C (DATA is a char string descriptor for this, so check
C  zero length, and ignore)
10011	IF ((DATA(1).AND.'FFFF'X).EQ.0) GOTO 99999
	CALL PS_BEGIN_SEPARATION(DATA)
	GOTO 99999
C
C Replace argument for inquiries
9000	DATA(1) = IDATA
C
99999	RETURN
	END
C
C***********************************************************************
C
C	ERROR ROUTINE
C	=============
C
	SUBROUTINE GKSERR(NUMBER,ROUTINE)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C ERROR routine called from within this library
C May be replaced if required
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER		NUMBER		! Error number
	CHARACTER*(*)	ROUTINE		! Routine name
C
	CALL WRITEF('GKS error %N in routine %S',NUMBER,ROUTINE)
C
	RETURN
	END
C
C***********************************************************************
C
	INTEGER FUNCTION LSG_SET_PATTERN(LEN,MAJ,MIN,MAREP,MIREP,FLG)
C
CDEC$	IDENT	'16JL87'
C
	IMPLICIT NONE
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C Author  C C Brunt
C
C Created 					CCB	26-Feb-1990
C
C Set up a hardware pattern.
C Return non-zero index for GSLN if hardware pattern set up, 0 if not, in
C which case it will be drawn by software.
C
	INCLUDE	'GKSDAT1.CMN'
C
C args
	REAL	LEN		! overall length
	REAL	MAJ		! major dash length
	REAL	MIN		! minor dash length
	INTEGER	MAREP		! major repeat count
	INTEGER	MIREP		! minor repeat count
	INTEGER	FLG		! pattern flags
C
C workspace
	REAL	GAP
C
	LSG_SET_PATTERN = 1000		! flag value
C
	PAT_REP1 = MAREP+1
	PAT_REP2 = MIREP+1
C
C For the common case of a single peck, then miss out the other
C (zero length) component completely
	IF (MAJ.EQ.0.0.AND.PAT_REP2.EQ.1) THEN
	   PAT_REP1 = 0
	ELSEIF (MIN.EQ.0.0.AND.PAT_REP1.EQ.1) THEN
	   PAT_REP2 = 0
	ENDIF
C
	PAT_PECKC = .NOT.(FLG.AND.1)	! continue through points or not
C
C calculate gap size (length of free space/no. of gaps)
	GAP = (LEN-MAJ*PAT_REP1-MIN*PAT_REP2)/(PAT_REP1+PAT_REP2)
C
C Make sure transformation is up to date
	IF (UPTRN) CALL GUPTRN
C
C transform the sizes to AEG counts
	PAT_PECK1 = MAJ*SCALEX
	PAT_PECK2 = MIN*SCALEX
	PAT_GAP =   GAP*SCALEX
C
999	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE LSG_BEGIN_FEATURE
C
CDEC$	IDENT	'10DE93'
C
	IMPLICIT NONE
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C Author  C C Brunt
C
C Created 					CCB	10-Dec-1993
C
C Mark that a feature is to be started (when we actually draw anything)
C
	INCLUDE	'GKSDAT1.CMN'
C
	BEGIN_FEATURE = .TRUE.
	UPLIN = .TRUE.
	UPFA = .TRUE.
	UPTX = .TRUE.
C
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE LSG_END_FEATURE
C
CDEC$	IDENT	'10DE93'
C
	IMPLICIT NONE
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C Author  C C Brunt
C
C Created 					CCB	10-Dec-1993
C
C Mark that a feature is to be started (when we actually draw anything)
C
	INCLUDE	'GKSDAT1.CMN'
C
	BEGIN_FEATURE = .FALSE.		! in case nothing drawn
	IF (FEATURE_BEGUN) THEN
	   FEATURE_BEGUN = .FALSE.
	   CALL PS_END_FEATURE
	ENDIF
C
	RETURN
	END
