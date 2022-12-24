C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1999-11-08 18:33:42.000000000 +0000
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	LOGICAL FUNCTION PROCESS_SYMBOLS(SYM_NUM,X_COORD,Y_COORD,
     &	CONVERT_TO_DTI)
	IMPLICIT NONE
	INTEGER		MAX_SYMBOLS
	PARAMETER	(MAX_SYMBOLS = 15)
	LOGICAL		SYMBOLS		! TRUE if enabled symbols
	LOGICAL		MOVE_SYMBOLS	! TRUE if currently moving symbols
	INTEGER		SYMBOLS_DEFINED	! number of symbols defined
	INTEGER		SYMBOLS_USED	! number of symbols used
	INTEGER*4	SYMBOL_IDATA(9,MAX_SYMBOLS)	!integer form 
	LOGICAL*4	SYMBOL_LDATA(9,MAX_SYMBOLS)	!logical form 
	REAL*4		SYMBOL_RDATA(9,MAX_SYMBOLS)	!real form 
	EQUIVALENCE 	(SYMBOL_IDATA,SYMBOL_LDATA,SYMBOL_RDATA)
	COMMON/USER_SYMBOLS/ 
     &		SYMBOLS,
     &		MOVE_SYMBOLS,
     &		SYMBOLS_DEFINED,
     &		SYMBOLS_USED,
     &		SYMBOL_IDATA
	PARAMETER FRTMAX_DEF=1000	! def number of FCs
	PARAMETER LINTYP = 1		! line string
	PARAMETER CLOTYP = 2		! clockwise circle arc
	PARAMETER ANTTYP = 3		! anti-clockwise circle arc
	PARAMETER CIRTYP = 4		! circum-circle arc
	PARAMETER FULTYP = 5		! full circumcircle
	PARAMETER CURTYP = 6		! interpolated curve
	PARAMETER UNOTYP = 7		! unoriented symbol
	PARAMETER ORITYP = 8		! oriented symbol
	PARAMETER SCATYP = 9		! scaled symbol
	PARAMETER TEXTYP = 10		! text
	PARAMETER STRTYP = 11		! symbol string
	PARAMETER ARETYP = 12		! fill area
	INTEGER		FRTMAX		! number of FCs
	INTEGER*4	FRTCNT		! count of defined FCs
	INTEGER*4	FRTIND		! index of selected FC
	INTEGER*4	FRTFC		! the selected FC
	INTEGER*4	FRTGT		! its Graphical Type
	INTEGER*4	FRTCOL		! its colour
	REAL		FRTWID		! its width
	REAL		FRTSIZ		! its size
	INTEGER*4	FRTSC		! its Secondary Code
	INTEGER*4	FRTFLG		! flags word
	INTEGER*4	FRTHW		! symbol for hardware line
	INTEGER*4	FRTHWL		! hardware line style
	INTEGER*4	FRTAST		! fill area internal style
	INTEGER*4	FRTAIX		! fill area style index
	LOGICAL*4	FRTHWS		! true if to use hardware symbol
	LOGICAL*4	FRTLIN		! true if linear
	LOGICAL*4	FRTSYM		! true if symbol
	LOGICAL*4	FRTARC		! true if circle arc
	LOGICAL*4	FRTCUR		! true if curve
	LOGICAL*4	FRTTEX		! true if text
	LOGICAL*4	FRTARE		! true if fill area
	INTEGER*4	FRTINT_LOC	! ptr to integers
	INTEGER*4	FRTFLT_LOC	! ptr to floats (reals)
	LOGICAL*4	FRTHKS		! true if thick lines supressed
	LOGICAL*4	FRTCLP		! true if to clip symbols in
					! patterened fill areas
	COMMON/FRTCOM/FRTMAX,FRTCNT,FRTIND,FRTFC,FRTGT,FRTCOL,
     &                FRTWID,FRTSIZ,FRTSC,FRTFLG,FRTHW,FRTHWL,
     &		      FRTAST,FRTAIX,FRTHWS,
     &                FRTLIN,FRTARC,FRTCUR,FRTSYM,FRTTEX,FRTARE,
     &	              FRTHKS,FRTCLP,
     &		      FRTINT_LOC,FRTFLT_LOC
	BYTE		BUTTON		! puck button number
	INTEGER		IERR		! error number
	LOGICAL*1	ERR		! error?
	LOGICAL*1	HAD_VDU		! had keyboard input?	
	LOGICAL*1	TABLE		! got a table?
	INTEGER		EF_POINT	! EF for puck-button input
	INTEGER		EF_STREAM	! EF for stream-button input
	INTEGER		EF_ERROR	! EF for table monitor error
	INTEGER		EF_VDU		! event flag for input from kybd
	INTEGER		EF_LAST		! not used here -dummy
	COMMON/TAB/	EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST,
     +			IERR,BUTTON,ERR,HAD_VDU,TABLE
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	REAL		LABX,LABY	! label position in cms.
	REAL		LEGX,LEGY	! legend position in cms.
	REAL		LEGSIZ		! legend scaling factor
	REAL		EX(2,0:4)		!outside limits of each
	REAL		EY(2,0:4)		!quadrant
	REAL		SX(2,0:4)
	REAL		SY(2,0:4)
	INTEGER*4	QUAD		! quadrant to draw in
	INTEGER*4	LABSIZ		! label size 1-4
	INTEGER*4	LABCOL		! label colour
	INTEGER*2	TK_LINESTYLE	! TEK 4000 linestyle
	LOGICAL		PRIMARY_DEVICE	! supports primary device
	LOGICAL		SECONDARY_DEVICE ! Supports secondary device
	LOGICAL		PRIMARY		! primary device enabled
	LOGICAL		SECONDARY	! secondary device enabled
	LOGICAL		INIT_PRIMARY	! primary device initialised
	LOGICAL		INIT_SECONDARY	! secondary device initialised
	LOGICAL		PLOT_IFF	! output to IFF file
	LOGICAL*1	AUTO		! auto scaling of view on/off
	LOGICAL*1	SPLIT		! split screen selected?
	LOGICAL*1	ACTIVE_IFF
	LOGICAL		PICTURE(2)
	COMMON /DEVICE/ LABX,LABY,LEGX,LEGY,LEGSIZ,LABSIZ,LABCOL,
     &			AUTO,SPLIT,QUAD,
     &			TK_LINESTYLE,ACTIVE_IFF,
     &                  PRIMARY_DEVICE,SECONDARY_DEVICE,
     & 			PRIMARY,SECONDARY,INIT_PRIMARY,INIT_SECONDARY,
     &			PLOT_IFF,
     &                  SX,EX,SY,EY,PICTURE
	INTEGER		SIGMA,TEK
	PARAMETER(	SIGMA = 1,	TEK = 2)
	INTEGER	NDEVS
	PARAMETER(	NDEVS = 2)
	INTEGER		WTYPE(2)	! workstation type
	INTEGER		CONID(2)	! workstation conection ID
	INTEGER		DCUNIT		! device units -always = 0
	INTEGER		RASTSZ(2,2)	! unused arg for GQMDS
	INTEGER		VSCHHI		! SIGMA char hgt index
	INTEGER		VSCHD		! SIGMA text direction index	
	INTEGER		TKCHHI		! TEK char hgt index
	INTEGER		IFONT		! character font index
	INTEGER		IPREC		! character precision index
	INTEGER		TXTCOL		! text colour index
	INTEGER		ITX		! text segment index
	INTEGER		PLANE_MASK	! plane mask derived from NOPLNS
	INTEGER		NOPLNS		! no. of planes for terrain view
	INTEGER		OVERLAY_COLOURS	! number of overlay colours
	REAL		WMAT(6)		! segment WC transf matrix
	REAL		SCRNDX(2)	! device screen X-ranges
	REAL		SCRNDY(2)	! device screen Y-ranges
	REAL		WXMIN,WXMAX	! world window X limits
	REAL		WYMIN,WYMAX	! world window Y limits
	REAL		XCUR,YCUR	! current pen world-position
	REAL		CHUX,CHUY	! char UP-vector
	REAL		UPLEN		! length of UP-vector
	REAL		TKCHX,TKCHY	! TEK char spacing vector
	REAL		TKCHH		! TEK char height
	REAL		TKCHSP		! TEK spacing ratio
	REAL		TKCHHT(4)	! set char hgts for TEK
	REAL		VSCHHT(4)	! set char hgts for SIGMA
	REAL		MAT(6)		! segment NDC transf matrix
	REAL		NDCX,NDCY	! extent in NDC
	LOGICAL*1	VIEW_SHOWN(2,0:4)   ! had view in quad ?
	LOGICAL*1	LEGEND_SHOWN(0:4) ! had legend in quad ?
	LOGICAL*1	TEXT_SHOWN(0:4)	  ! had text in quad
	LOGICAL*1	TRANSF		! seg transformation active?
	COMMON/GKSCMN/	WTYPE,CONID,DCUNIT,RASTSZ,
     &			VSCHHI,VSCHD,TKCHHI,
     &			IFONT,IPREC,TXTCOL,ITX,
     &			WMAT,SCRNDX,SCRNDY,
     &			WXMIN,WXMAX,WYMIN,WYMAX,
     &			XCUR,YCUR,CHUX,CHUY,UPLEN,
     &			TKCHX,TKCHY,TKCHH,TKCHSP,TKCHHT,VSCHHT,
     &			VIEW_SHOWN,LEGEND_SHOWN,TRANSF,MAT,TEXT_SHOWN,
     &			PLANE_MASK,NOPLNS,NDCX,NDCY,OVERLAY_COLOURS
	INTEGER	GASTI,GSUPPD,GBUNDL,GINDIV,GMETRE,GSUPP,GALWAY
	INTEGER	GNONE,GOK,GNPICK,GNORML,GHILIT,GINVIS,GVISI
	INTEGER	GNCLIP,GCLIP,GSOLID
	PARAMETER (GASTI=3)		! deferral At Some TIme
	PARAMETER (GSUPPD=0)		! regeneration suppressed
	PARAMETER (GBUNDL=0)		! GKS ASF bundled
	PARAMETER (GINDIV=1)		! GKS ASF individual
	PARAMETER (GMETRE=0)		! device coords metres
	PARAMETER (GSUPP=0)		! suppress update regeneration
	PARAMETER (GALWAY=1)		! clear always
	PARAMETER (GNONE=0)		! no input
	PARAMETER (GOK=1)		! input OK
	PARAMETER (GNPICK=2)		! no segment picked
	PARAMETER (GINVIS=0)		! invisible
	PARAMETER (GVISI=1)		! visible
	PARAMETER (GNORML=0)		! normal
	PARAMETER (GHILIT=1)		! highlighted
	PARAMETER (GNCLIP=0)		! no clipping
	PARAMETER (GCLIP=1)		! clipping
	PARAMETER (GSOLID=1)		! solid 
	INTEGER		SYM_NUM		!Symbol number
	INTEGER		X_COORD		!X input coordinate
	INTEGER		Y_COORD		!Y input coordinate
	LOGICAL		CONVERT_TO_DTI	!TRUE if input coords are table units
	INTEGER		I		!loop counter
	REAL 		X_RDTI		!X (real) DTI matrix coordinate
	REAL 		Y_RDTI		!Y (real) DTI matrix coordinate
	LOGICAL		OK		!return code
	LOGICAL		FRTFND
	PROCESS_SYMBOLS = .TRUE.
	IF(.NOT.SYMBOLS) THEN
	   PROCESS_SYMBOLS = .FALSE.
	   GOTO 999
	ENDIF
	IF(.NOT.(PRIMARY.OR.SECONDARY)) THEN
	   PROCESS_SYMBOLS = .FALSE.
	   GOTO 999
	ENDIF
	IF(PRIMARY.AND.WTYPE(1).EQ.9900) THEN
	   CALL GDAWK(1)
	ENDIF
	IF((SYM_NUM.LT.0).OR.(SYM_NUM.GT.MAX_SYMBOLS)) THEN
	   CALL WRITEF('%S symbol %I0 is invalid',
     &	   ERROR_BELL,SYM_NUM) 
	   CALL WRITEF
     &	   ('Symbol number less than 1 or greater than %I0',
     &     MAX_SYMBOLS)
	   PROCESS_SYMBOLS = .FALSE.
	   GOTO 999
	ENDIF
	IF(SYM_NUM.GE.1.AND.
     &	.NOT.SYMBOL_LDATA(5,SYM_NUM)) THEN !.FALSE. if undefined
	   CALL WRITEF('%S Symbol %I0 selected but no symbol '//
     &	   'defined',ERROR_BELL,SYM_NUM) 
	   CALL WRITEF('Use SYMBOL FC %I0 <fc> command to '//
     &	   'activate symbol',SYM_NUM)
	   PROCESS_SYMBOLS = .FALSE.
	   GOTO 999
	ENDIF
	IF(.NOT.MOVE_SYMBOLS) THEN
	   MOVE_SYMBOLS = .TRUE.
	   CALL PLTPOS(.FALSE.,.FALSE.)
	   CALL GSSGT
	   IF(PRIMARY)THEN
	      IF(NOPLNS.EQ.4)THEN
	         CALL LSG_PLANE_SELECT(1,PLANE_MASK)
	         CALL LSG_PLANE_OFFSET(1,0)
	         CALL LSG_PLANE_VISIBLE(1,-1)
	      ELSE
	         CALL LSG_PLANE_SELECT(1,.NOT.PLANE_MASK)
	         CALL LSG_PLANE_OFFSET(1,NOPLNS)
	         CALL LSG_PLANE_VISIBLE(1,-1)
	      ENDIF
	   ENDIF
	   IF(SECONDARY)THEN
              IF(NOPLNS.EQ.4)THEN
	         CALL LSG_PLANE_SELECT(2,PLANE_MASK)
	         CALL LSG_PLANE_OFFSET(2,0)
	         CALL LSG_PLANE_VISIBLE(2,-1)
	      ELSE
		 CALL LSG_PLANE_SELECT(2,.NOT.PLANE_MASK)
		 CALL LSG_PLANE_OFFSET(2,NOPLNS)
		 CALL LSG_PLANE_VISIBLE(2,-1)
	      ENDIF
	   ENDIF
	ENDIF
	IF(SYM_NUM.EQ.0) THEN
	   DO 100 I = 1,MAX_SYMBOLS
	      IF(SYMBOL_LDATA(7,I)) THEN
	         OK = FRTFND(SYMBOL_IDATA(4,I))		! lookup FC in FRT
		 CALL PLOT_SYMBOL(SYMBOL_IDATA(4,I),	! Feat Code
     &	   			SYMBOL_RDATA(2,I),	! old matrix x coord
     &	   			SYMBOL_RDATA(3,I),	! old matrix y coord
     &				.FALSE.,		! not IFF data
     &				.FALSE.,		! no clear
     &				I)			! button pressed
	      ENDIF
100	   CONTINUE
	ELSE
	   IF(SYMBOL_LDATA(7,SYM_NUM)) THEN
	      OK = FRTFND(SYMBOL_IDATA(4,SYM_NUM))	
	      CALL SRICOL(0)		! force colour of black
	      CALL PLOT_SYMBOL(	SYMBOL_IDATA(4,SYM_NUM),! Feat Code
     &	   			SYMBOL_RDATA(2,SYM_NUM),! old matrix x coord
     &	   			SYMBOL_RDATA(3,SYM_NUM),! old matrix y coord
     &				.FALSE.,		! not IFF data
     &				.TRUE.,			! clear mode (undraw)
     &				SYM_NUM)		! button pressed
	      CALL SRICOL(-1)		! get set to FRTCOL
	   ENDIF
	   IF(CONVERT_TO_DTI) THEN
	      IF(.NOT.MAP_SET) THEN
		 CALL WRITEF('%S Map area not registered',ERROR_BELL)
		 CALL WRITEF('Use the SETUP MAP command')
		 PROCESS_SYMBOLS = .FALSE.
		 GOTO 999
	      ENDIF
	      X_RDTI=FLOAT(NINT(TAB_DTI(1,1)*X_COORD 
     &	      + TAB_DTI(1,2)*Y_COORD + TAB_DTI(1,3)))
	      Y_RDTI=FLOAT(NINT(TAB_DTI(2,1)*X_COORD 
     &	      + TAB_DTI(2,2)*Y_COORD + TAB_DTI(2,3)))
	   ELSE
	      X_RDTI = X_COORD
	      Y_RDTI = Y_COORD
	   ENDIF
	   OK = FRTFND(SYMBOL_IDATA(4,SYM_NUM))	
	   CALL PLOT_SYMBOL(	SYMBOL_IDATA(4,SYM_NUM),! Feat Code
     &	   			X_RDTI, 		! new matrix x coord
     &	   			Y_RDTI, 		! new matrix y coord
     &				.FALSE.,		! not IFF data
     &				.FALSE.,		! no clear
     &				SYM_NUM)		! button pressed
	   IF(.NOT.SYMBOL_LDATA(8,SYM_NUM)) THEN
	      CALL PLOT_SYMBOL(	SYMBOL_IDATA(4,SYM_NUM),! Feat Code
     &	   			SYMBOL_RDATA(2,SYM_NUM),! old matrix x coord
     &	   			SYMBOL_RDATA(3,SYM_NUM),! old matrix y coord
     &				.FALSE.,		! not IFF data
     &				.FALSE.,		! no clear
     &				SYM_NUM)		! button pressed
	   ELSE
	      SYMBOL_RDATA(2,SYM_NUM) = X_RDTI
	      SYMBOL_RDATA(3,SYM_NUM) = Y_RDTI
	      IF(.NOT.SYMBOL_LDATA(6,SYM_NUM)) THEN
	         SYMBOL_LDATA(6,SYM_NUM) = .TRUE.
	      	 SYMBOLS_USED = SYMBOLS_USED + 1
	      ENDIF
	   ENDIF
	ENDIF
	IF(PRIMARY.AND.WTYPE(1).EQ.9900) THEN
	   CALL GACWK(1)
	ENDIF
	IF(PRIMARY)CALL GUWK(1,GSUPP)
	IF(SECONDARY)CALL GUWK(2,GSUPP)
999	CONTINUE
	RETURN
	END

	LOGICAL FUNCTION SYMBOL_CMD()
	IMPLICIT NONE
	INTEGER*4	INTARG(8)
	REAL		REALAR(8)
	INTEGER*2	CMDNLE,SECNLE,STARLE
	INTEGER*4	CMDNST(2),SECNST(2),STARST(2)
	INTEGER*4	CMDFST(2)	! copy of 'descriptor' for
	INTEGER*4	CMSFST(2)	! ditto for secondary command
	INTEGER*4	CMDAST(2)	! copy of same for subject
	INTEGER*4	CMDNUM
	INTEGER*4	TABFLG,CMDFLG
	INTEGER*4	SECMDN		! secondary command number
	INTEGER*4	SECTAB		! table secondary command is to
	INTEGER*4	CMDACT,CMDICT,CMDRCT
	INTEGER*4	DEFBASE
	LOGICAL*1	ARGMSG,CMDNEG,HADDOT,NOMESS
	BYTE		INEQUAL
	LOGICAL*1	NOUFLG		! TRUE => no user flags with
	LOGICAL*1	NSUFLG		! ditto for 2ndary table
	BYTE		UNXCHR		! 'unexpected character' that
	INTEGER*4	UFLAG		! user flag found, if any
	INTEGER*4	SUFLAG		! secondary table user flag
	COMMON /LSL_CMDCOM/	INTARG,REALAR,
     &				CMDNST,SECNST,STARST,
     &				CMDFST,CMSFST,CMDAST,
     &				CMDNUM,TABFLG,CMDFLG,
     &				SECMDN,SECTAB,
     &				CMDACT,CMDICT,CMDRCT,
     &				DEFBASE,
     &				ARGMSG,CMDNEG,HADDOT,NOMESS,
     &				INEQUAL,
     &				NOUFLG,NSUFLG,UNXCHR,UFLAG,SUFLAG
	EQUIVALENCE (CMDNLE,CMDNST)
	EQUIVALENCE (SECNLE,SECNST)
	EQUIVALENCE (STARLE,STARST)
	INTEGER*4	MAX_TXTLIM	! maximum possible buffer length
	PARAMETER	(MAX_TXTLIM = 1024)
	INTEGER*4	DEF_TXTLIM	! default buffer length
	PARAMETER	(DEF_TXTLIM = 255)
	INTEGER*2 	DCPTR   	! decode pointer
	INTEGER*2 	TXTPTR  	! end of line pointer
	BYTE		TXTTYP  	! type of fake string
	BYTE		TXTCLA  	! class of fake string
	INTEGER*4 	TXTADD  	! address of buffer
	INTEGER*2 	TXTLIM  	! actual buffer length
	BYTE 		TXTBUF(MAX_TXTLIM)  	! text buffer
	INTEGER*4	TXTDSC(2)	! fake string descriptor
	EQUIVALENCE	(TXTDSC,TXTPTR)
	COMMON/LSL_TXTC/DCPTR,TXTPTR,TXTTYP,TXTCLA,TXTADD,TXTLIM,TXTBUF
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER		MAX_SYMBOLS
	PARAMETER	(MAX_SYMBOLS = 15)
	LOGICAL		SYMBOLS		! TRUE if enabled symbols
	LOGICAL		MOVE_SYMBOLS	! TRUE if currently moving symbols
	INTEGER		SYMBOLS_DEFINED	! number of symbols defined
	INTEGER		SYMBOLS_USED	! number of symbols used
	INTEGER*4	SYMBOL_IDATA(9,MAX_SYMBOLS)	!integer form 
	LOGICAL*4	SYMBOL_LDATA(9,MAX_SYMBOLS)	!logical form 
	REAL*4		SYMBOL_RDATA(9,MAX_SYMBOLS)	!real form 
	EQUIVALENCE 	(SYMBOL_IDATA,SYMBOL_LDATA,SYMBOL_RDATA)
	COMMON/USER_SYMBOLS/ 
     &		SYMBOLS,
     &		MOVE_SYMBOLS,
     &		SYMBOLS_DEFINED,
     &		SYMBOLS_USED,
     &		SYMBOL_IDATA
	REAL		XPTS(8196)	!x coords (IFF feature)
	REAL		YPTS(8196)	!y coords (IFF feature)
	REAL		RANGE_VALUES(4)	!Map range
	REAL		WIND(2,2)	!Map window (SW,NE)
	REAL		SYMSF		!symbol scaling factor
	REAL		ORIGIN_OFFSET(2)
	INTEGER*2	PTS
	INTEGER*4	SYMX		!symbol x position (DTM units)
	INTEGER*4	SYMY		!symbol y position (DTM units)
	INTEGER*2	SYMHGT		!height at symbol position
	LOGICAL		SYMVIS		!is symbol base visible or not?
	LOGICAL		OVERLAY		!culture overlay selected?
	LOGICAL		HADIFF		!had an input IFF file
	LOGICAL		HADWIN		!true if IFF window has been
	LOGICAL		HADTMP		!temp vis grid opened on chan 2
	LOGICAL		DEBUG		!internal debug messages 
	LOGICAL		HADFRT		!we've read an FRT
	LOGICAL		HADSRI		!we've read an SRI
	LOGICAL		STFEAT
	CHARACTER*72	FRTTIT		!FRT filename
	CHARACTER*72	SRITIT		!SRI filename
	CHARACTER*255	INPUT_IFF_NAME
	INTEGER*4	INPUT_IFF_LENGTH	
	LOGICAL		MASK
	LOGICAL		HADSF		!user specified symbol scaling fac
	LOGICAL	        STALIN		!true if invisible mover required
	INTEGER*2	LAND_FC		!feature code for land profiles
	INTEGER*2	SEA_FC		!feature code for sea profiles
	INTEGER*2	LAYER		!layer for profiles
	INTEGER*2	NULL_FC		!feature code for null profiles
	INTEGER*2	TEXT_FC		!feature code for text
	COMMON/CULTRE/PTS,HADIFF,RANGE_VALUES,
     &		      WIND,HADWIN,HADTMP,DEBUG,
     &		      FRTTIT,SRITIT,HADFRT,HADSRI,STFEAT,XPTS,YPTS,
     &		      SYMHGT,SYMX,SYMY,MASK,SYMSF,HADSF,STALIN,
     &                LAND_FC,SEA_FC,LAYER,OVERLAY,NULL_FC,
     &		      TEXT_FC,INPUT_IFF_NAME,INPUT_IFF_LENGTH,
     &		      ORIGIN_OFFSET
	INTEGER		SIGMA,TEK
	PARAMETER(	SIGMA = 1,	TEK = 2)
	INTEGER	NDEVS
	PARAMETER(	NDEVS = 2)
	INTEGER		WTYPE(2)	! workstation type
	INTEGER		CONID(2)	! workstation conection ID
	INTEGER		DCUNIT		! device units -always = 0
	INTEGER		RASTSZ(2,2)	! unused arg for GQMDS
	INTEGER		VSCHHI		! SIGMA char hgt index
	INTEGER		VSCHD		! SIGMA text direction index	
	INTEGER		TKCHHI		! TEK char hgt index
	INTEGER		IFONT		! character font index
	INTEGER		IPREC		! character precision index
	INTEGER		TXTCOL		! text colour index
	INTEGER		ITX		! text segment index
	INTEGER		PLANE_MASK	! plane mask derived from NOPLNS
	INTEGER		NOPLNS		! no. of planes for terrain view
	INTEGER		OVERLAY_COLOURS	! number of overlay colours
	REAL		WMAT(6)		! segment WC transf matrix
	REAL		SCRNDX(2)	! device screen X-ranges
	REAL		SCRNDY(2)	! device screen Y-ranges
	REAL		WXMIN,WXMAX	! world window X limits
	REAL		WYMIN,WYMAX	! world window Y limits
	REAL		XCUR,YCUR	! current pen world-position
	REAL		CHUX,CHUY	! char UP-vector
	REAL		UPLEN		! length of UP-vector
	REAL		TKCHX,TKCHY	! TEK char spacing vector
	REAL		TKCHH		! TEK char height
	REAL		TKCHSP		! TEK spacing ratio
	REAL		TKCHHT(4)	! set char hgts for TEK
	REAL		VSCHHT(4)	! set char hgts for SIGMA
	REAL		MAT(6)		! segment NDC transf matrix
	REAL		NDCX,NDCY	! extent in NDC
	LOGICAL*1	VIEW_SHOWN(2,0:4)   ! had view in quad ?
	LOGICAL*1	LEGEND_SHOWN(0:4) ! had legend in quad ?
	LOGICAL*1	TEXT_SHOWN(0:4)	  ! had text in quad
	LOGICAL*1	TRANSF		! seg transformation active?
	COMMON/GKSCMN/	WTYPE,CONID,DCUNIT,RASTSZ,
     &			VSCHHI,VSCHD,TKCHHI,
     &			IFONT,IPREC,TXTCOL,ITX,
     &			WMAT,SCRNDX,SCRNDY,
     &			WXMIN,WXMAX,WYMIN,WYMAX,
     &			XCUR,YCUR,CHUX,CHUY,UPLEN,
     &			TKCHX,TKCHY,TKCHH,TKCHSP,TKCHHT,VSCHHT,
     &			VIEW_SHOWN,LEGEND_SHOWN,TRANSF,MAT,TEXT_SHOWN,
     &			PLANE_MASK,NOPLNS,NDCX,NDCY,OVERLAY_COLOURS
	LOGICAL 	OK		! return code
	INTEGER		CMD		! command number
	INTEGER 	I		! loop controls.
	EXTERNAL 	SYMBOL_CMD_TABLE
	INTEGER 	SYMBOL_CMD_TABLE
	INTEGER		RDCOMM
	LOGICAL 	SYMBOL_CLEAR_CMD
	LOGICAL 	SYMBOL_FC_CMD
	LOGICAL 	SYMBOL_POSITION_CMD
	SYMBOL_CMD=.TRUE.		! assume success
	IF(.NOT.SYMBOLS)THEN
	   CALL WRITEF('%S Specifying command SYMBOL',ERROR_BELL)
	   CALL WRITEF('Symbol options are not enabled')
	   CALL WRITEF('Ue ENABLE SYMBOLS command')
	   SYMBOL_CMD=.FALSE.
	   GOTO 999
	ENDIF
	IF(NOPLNS.EQ.8)THEN
	   CALL WRITEF('%S Specifying command SYMBOL',ERROR_BELL)
	   CALL WRITEF('Symbol plotting not possible with a '//
     &	   'planes setting of 8')
	   SYMBOL_CMD=.FALSE.
	   GOTO 999
	ENDIF
	IF(.NOT.HADFRT)THEN
	   CALL WRITEF('%S Specifying command SYMBOL',ERROR_BELL)
	   CALL WRITEF('No FRT file has been specified')
	   CALL WRITEF('Use FRT command')
	   SYMBOL_CMD=.FALSE.
	   GOTO 999
	ENDIF
	IF(.NOT.HADSRI)THEN
	   CALL WRITEF('%S Specifying command SYMBOL',ERROR_BELL)
	   CALL WRITEF('No SRI file has been specified')
	   CALL WRITEF('Use SRI command')
	   SYMBOL_CMD=.FALSE.
	   GOTO 999
	ENDIF
	CMD=RDCOMM(SYMBOL_CMD_TABLE)	
	GOTO (		100,		! unrecognised command
     &			200,		! clear symbol
     &			300,		! define fc for symbol
     &			400),CMD+1	! position symbol
100	CONTINUE
	CALL WRITEF('%S Specifying command SYMBOL',ERROR_BELL)
	CALL WRITEF('Command qualifier are CLEAR, FC or POSITION')
	SYMBOL_CMD=.FALSE.
	GOTO 999
200	CONTINUE
	OK = SYMBOL_CLEAR_CMD()
	IF(.NOT.OK) THEN
	   SYMBOL_CMD = .FALSE.
	   GOTO 999
	ENDIF
	GOTO 1000
300	CONTINUE
	OK = SYMBOL_FC_CMD()
	IF(.NOT.OK) THEN
	   SYMBOL_CMD = .FALSE.
	   GOTO 999
	ENDIF
	GOTO 1000
400	CONTINUE
	OK = SYMBOL_POSITION_CMD()
	IF(.NOT.OK) THEN
	   SYMBOL_CMD = .FALSE.
	   GOTO 999
	ENDIF
	GOTO 1000
999	CONTINUE
1000	CONTINUE
	RETURN
	END

	SUBROUTINE SHOW_SYMBOLS
	IMPLICIT NONE
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	INTEGER*4	DTIPROJ_IDENT1
	PARAMETER	(DTIPROJ_IDENT1='*DTI')
	INTEGER*4	DTIPROJ_IDENT2
	PARAMETER	(DTIPROJ_IDENT2='PROJ')
	INTEGER*4	NUM_DTI
	PARAMETER	(NUM_DTI=9)
	INTEGER*4	DTIPROJ_RECORD_LENGTH	
	PARAMETER	(DTIPROJ_RECORD_LENGTH=1600)
	INTEGER*4	DTIPROJ_RECORD_OFFSET(NUM_DTI)
	REAL*8		DTIPROJ_ORIGIN(2,NUM_DTI)
	REAL*4 		DTIPROJ_SAMPLE(2,NUM_DTI)
	INTEGER*4	DTIPROJ_UNITS(NUM_DTI)
	INTEGER*4	DTIPROJ_SPHEROID(NUM_DTI)
	INTEGER*4	DTIPROJ_PROJECTION(NUM_DTI)
	REAL*8		DTIPROJ_USER_SPHEROID(2,NUM_DTI)
	REAL*8		DTIPROJ_PROJ_PARAMS(15,NUM_DTI)
	COMMON/DTIPROJ/	
     &			DTIPROJ_RECORD_OFFSET,
     &			DTIPROJ_ORIGIN,DTIPROJ_SAMPLE,
     &			DTIPROJ_UNITS,DTIPROJ_SPHEROID,
     &			DTIPROJ_PROJECTION,
     &			DTIPROJ_USER_SPHEROID,
     &			DTIPROJ_PROJ_PARAMS
	INTEGER		MAX_SYMBOLS
	PARAMETER	(MAX_SYMBOLS = 15)
	LOGICAL		SYMBOLS		! TRUE if enabled symbols
	LOGICAL		MOVE_SYMBOLS	! TRUE if currently moving symbols
	INTEGER		SYMBOLS_DEFINED	! number of symbols defined
	INTEGER		SYMBOLS_USED	! number of symbols used
	INTEGER*4	SYMBOL_IDATA(9,MAX_SYMBOLS)	!integer form 
	LOGICAL*4	SYMBOL_LDATA(9,MAX_SYMBOLS)	!logical form 
	REAL*4		SYMBOL_RDATA(9,MAX_SYMBOLS)	!real form 
	EQUIVALENCE 	(SYMBOL_IDATA,SYMBOL_LDATA,SYMBOL_RDATA)
	COMMON/USER_SYMBOLS/ 
     &		SYMBOLS,
     &		MOVE_SYMBOLS,
     &		SYMBOLS_DEFINED,
     &		SYMBOLS_USED,
     &		SYMBOL_IDATA
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	REAL*4		XPOS,YPOS
	INTEGER*4	LLDEGS(2)
	INTEGER*4	I
	INTEGER*4	DEGR,MINU,SECO
	LOGICAL		NEGA
	CALL WRITEF
	IF(.NOT.SYMBOLS) THEN
	   CALL WRITEF('Symbols not enabled ')
	   GOTO 10
	ENDIF
	CALL WRITEF('Number of symbols currently defined : %I0',
     &	SYMBOLS_DEFINED)
	CALL WRITEF('Number of symbols currently used : %I0',
     &	SYMBOLS_USED)
	CALL WRITEF
     &	('-----------------------------'
     &  //'---------------------------------|')
	CALL WRITEF
     &	('| Symbol no |   FC  |   X position  '
     &  //'|   Y position  | Visible |')
	CALL WRITEF
     &	('-----------------------------'
     &  //'---------------------------------|')
	DO 100 I = 1,MAX_SYMBOLS
	   IF(.NOT.(SYMBOL_LDATA(5,I).AND.SYMBOL_LDATA(6,I)))GOTO 100
	   CALL EXPAND('|    %I3    |%I5  |',I,SYMBOL_IDATA(4,I))
	   GOTO(10,20,30,40,50)UNITS
10	   CALL APPEND('     %I5     |     %I5     |',
     &	   NINT(SYMBOL_RDATA(2,I)),NINT(SYMBOL_RDATA(3,I))) 
	   GOTO 70
20	   IF(HAD_ABSOLUTE)THEN
	     XPOS=X_OFFSET(1)+(SYMBOL_RDATA(2,I)-1)*X_GRID(1)
	     YPOS=Y_OFFSET(1)+(SYMBOL_RDATA(3,I)-1)*Y_GRID(1)
	   ELSE
	     XPOS = (SYMBOL_RDATA(2,I)-1)*X_GRID(1)
	     YPOS = (SYMBOL_RDATA(3,I)-1)*Y_GRID(1)
	   ENDIF
	   CALL APPEND('  %F10.2   |  %F10.2   |',XPOS,YPOS)
	   GOTO 70
30	   LLDEGS(1)=LONREC(1,1)+((NINT(SYMBOL_RDATA(2,I))-1)*LONINT(1))
	   LLDEGS(2)=LATREC(1,1)+((NINT(SYMBOL_RDATA(3,I))-1)*LATINT(1))
	   CALL APPEND('  %I10   |  %I10   |',LLDEGS(1),LLDEGS(2))
	   GOTO 70
40	   LLDEGS(1)=LONREC(1,1)+((NINT(SYMBOL_RDATA(2,I))-1)*LONINT(1))
	   LLDEGS(2)=LATREC(1,1)+((NINT(SYMBOL_RDATA(3,I))-1)*LATINT(1))
	   CALL DTI_CVTANG(LLDEGS(1),NEGA,DEGR,MINU,SECO)
	   CALL APPEND('%P   %I3 %P0%I2 %P0%I2',DEGR,MINU,SECO)
	   IF(NEGA)THEN
	      CALL APPEND('W   |')
	   ELSE
	      CALL APPEND('E   |')
	   ENDIF
	   CALL DTI_CVTANG(LLDEGS(2),NEGA,DEGR,MINU,SECO)
	   CALL APPEND('%P   %I3 %P0%I2 %P0%I2',DEGR,MINU,SECO)
	   IF(NEGA)THEN
	      CALL APPEND('S   |')
	   ELSE
	      CALL APPEND('N   |')
	   ENDIF
	   GOTO 70
50	   IF(HAD_ABSOLUTE)THEN
	     XPOS=DTIPROJ_ORIGIN(1,1)+
     &       (SYMBOL_RDATA(2,I)-1)*DTIPROJ_SAMPLE(1,1)
	     YPOS=DTIPROJ_ORIGIN(2,1)+
     &       (SYMBOL_RDATA(3,I)-1)*DTIPROJ_SAMPLE(2,1)
	   ELSE
	     XPOS = (SYMBOL_RDATA(2,I)-1)*DTIPROJ_SAMPLE(1,1)
	     YPOS = (SYMBOL_RDATA(3,I)-1)*DTIPROJ_SAMPLE(2,1)
	   ENDIF
	   CALL APPEND('  %F10.2   |  %F10.2   |',XPOS,YPOS)
	   GOTO 70
70	   IF(SYMBOL_LDATA(7,I)) THEN
	      CALL APPEND('   YES   |')
	   ELSE
	      CALL APPEND('   NO    |')
	   ENDIF
	   CALL TTWLIN
100	CONTINUE
	CALL WRITEF
     &	('-----------------------------'
     &  //'---------------------------------|')
	CALL WRITEF
999	RETURN
	END
	LOGICAL FUNCTION SYMBOL_CLEAR_CMD()
	IMPLICIT NONE
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER		MAX_SYMBOLS
	PARAMETER	(MAX_SYMBOLS = 15)
	LOGICAL		SYMBOLS		! TRUE if enabled symbols
	LOGICAL		MOVE_SYMBOLS	! TRUE if currently moving symbols
	INTEGER		SYMBOLS_DEFINED	! number of symbols defined
	INTEGER		SYMBOLS_USED	! number of symbols used
	INTEGER*4	SYMBOL_IDATA(9,MAX_SYMBOLS)	!integer form 
	LOGICAL*4	SYMBOL_LDATA(9,MAX_SYMBOLS)	!logical form 
	REAL*4		SYMBOL_RDATA(9,MAX_SYMBOLS)	!real form 
	EQUIVALENCE 	(SYMBOL_IDATA,SYMBOL_LDATA,SYMBOL_RDATA)
	COMMON/USER_SYMBOLS/ 
     &		SYMBOLS,
     &		MOVE_SYMBOLS,
     &		SYMBOLS_DEFINED,
     &		SYMBOLS_USED,
     &		SYMBOL_IDATA
	LOGICAL OK		! return code
	LOGICAL EOL		! end of line
	INTEGER	CMD		! command number
	INTEGER I		! loop controls.
	INTEGER SYM_NUM		! symbol number
	INTEGER*2 BUFF_PTR	! to remember buffer pointer
	BYTE CH			! for use with RDCH & RDCHS
	EXTERNAL 	CLEARSYM_CMD_TABLE
	INTEGER 	CLEARSYM_CMD_TABLE
	INTEGER 	RDCOMM
	LOGICAL*1	RDLONG
	LOGICAL*1 	RDCHS
	LOGICAL		FRTFND
	SYMBOL_CLEAR_CMD=.TRUE.		! assume success
	CALL DCPSAV(BUFF_PTR)			! save the buffer pointer
	CMD = RDCOMM(CLEARSYM_CMD_TABLE)
	GOTO (
     &		5,		! probably check number or range supplied
     &		300		! ALL found
     &			) CMD+1
5	CONTINUE
	CALL DCPSET(BUFF_PTR)			! reset buffer pointer
10	CONTINUE
	EOL = RDCHS(CH)
	IF(.NOT.EOL) THEN				! more feature codes
	   IF ((CH.GE.48).AND.(CH.LE.57)) THEN		! 0 - 9
	      GOTO 200
	   ELSE						! unexpected char
	      CALL WRITEF('%S Specifying command CLEAR SYMBOL',ERROR_BELL)
	      CALL WRITEF('Unexpected character "%^B%C" '//
     &		'at this point.',CH)
	      SYMBOL_CLEAR_CMD = .FALSE.
	      GOTO 999
	   ENDIF
	ELSE						! no more FC's
	   CALL WRITEF('%S Specifying command CLEAR SYMBOL',ERROR_BELL)
	   CALL WRITEF('Command require symbol number ')
	   SYMBOL_CLEAR_CMD = .FALSE.
	   GOTO 999
	ENDIF
200	CONTINUE
	CALL BSCH
	IF(RDLONG(SYM_NUM)) THEN
	   CALL WRITEF('%S Specifying command CLEAR SYMBOL',ERROR_BELL)
	   CALL WRITEF('Error reading integer number')
	   SYMBOL_CLEAR_CMD = .FALSE.
	   GOTO 999
	ENDIF
	IF(SYMBOL_LDATA(7,SYM_NUM)) THEN 	! only visible symbols
	   OK = FRTFND(SYMBOL_IDATA(4,SYM_NUM))	
	   CALL SRICOL(0)			! set colour to black
	   CALL PLOT_SYMBOL(	SYMBOL_IDATA(4,SYM_NUM),! feat code
     &				SYMBOL_RDATA(2,SYM_NUM),! DTI x coord
     &				SYMBOL_RDATA(3,SYM_NUM),! DTI y coord
     &				.FALSE.,		! not IFF data
     &				.TRUE.,			! clear mode
     &				SYM_NUM)		! button or symbol num
	   SYMBOL_LDATA(6,SYM_NUM) = .FALSE.
	   SYMBOLS_USED = SYMBOLS_USED - 1
	   CALL SRICOL(-1)			! set colour to FRTCOL
	ENDIF
	GOTO 1000
300	CONTINUE
	CALL SRICOL(0)			! set colour to black
	DO 310 I=1,MAX_SYMBOLS
	   IF(SYMBOL_LDATA(7,I)) THEN 	! only visible symbols
	      OK = FRTFND(SYMBOL_IDATA(4,I))	
	      CALL PLOT_SYMBOL(	SYMBOL_IDATA(4,I),	! feat code
     &				SYMBOL_RDATA(2,I),	! DTI x coord
     &				SYMBOL_RDATA(3,I),	! DTI y coord
     &				.FALSE.,		! not IFF data
     &				.TRUE.,			! clear mode
     &				I)			! button or symbol num
	      SYMBOL_LDATA(6,I) = .FALSE.
	      SYMBOLS_USED = SYMBOLS_USED - 1
	   ENDIF
310	CONTINUE
	CALL SRICOL(-1)			! set colour to FRTCOL
999	CONTINUE	
1000	CONTINUE
	RETURN
	END

	LOGICAL FUNCTION SYMBOL_FC_CMD()
	IMPLICIT NONE
	INTEGER*4	INTARG(8)
	REAL		REALAR(8)
	INTEGER*2	CMDNLE,SECNLE,STARLE
	INTEGER*4	CMDNST(2),SECNST(2),STARST(2)
	INTEGER*4	CMDFST(2)	! copy of 'descriptor' for
	INTEGER*4	CMSFST(2)	! ditto for secondary command
	INTEGER*4	CMDAST(2)	! copy of same for subject
	INTEGER*4	CMDNUM
	INTEGER*4	TABFLG,CMDFLG
	INTEGER*4	SECMDN		! secondary command number
	INTEGER*4	SECTAB		! table secondary command is to
	INTEGER*4	CMDACT,CMDICT,CMDRCT
	INTEGER*4	DEFBASE
	LOGICAL*1	ARGMSG,CMDNEG,HADDOT,NOMESS
	BYTE		INEQUAL
	LOGICAL*1	NOUFLG		! TRUE => no user flags with
	LOGICAL*1	NSUFLG		! ditto for 2ndary table
	BYTE		UNXCHR		! 'unexpected character' that
	INTEGER*4	UFLAG		! user flag found, if any
	INTEGER*4	SUFLAG		! secondary table user flag
	COMMON /LSL_CMDCOM/	INTARG,REALAR,
     &				CMDNST,SECNST,STARST,
     &				CMDFST,CMSFST,CMDAST,
     &				CMDNUM,TABFLG,CMDFLG,
     &				SECMDN,SECTAB,
     &				CMDACT,CMDICT,CMDRCT,
     &				DEFBASE,
     &				ARGMSG,CMDNEG,HADDOT,NOMESS,
     &				INEQUAL,
     &				NOUFLG,NSUFLG,UNXCHR,UFLAG,SUFLAG
	EQUIVALENCE (CMDNLE,CMDNST)
	EQUIVALENCE (SECNLE,SECNST)
	EQUIVALENCE (STARLE,STARST)
	PARAMETER FRTMAX_DEF=1000	! def number of FCs
	PARAMETER LINTYP = 1		! line string
	PARAMETER CLOTYP = 2		! clockwise circle arc
	PARAMETER ANTTYP = 3		! anti-clockwise circle arc
	PARAMETER CIRTYP = 4		! circum-circle arc
	PARAMETER FULTYP = 5		! full circumcircle
	PARAMETER CURTYP = 6		! interpolated curve
	PARAMETER UNOTYP = 7		! unoriented symbol
	PARAMETER ORITYP = 8		! oriented symbol
	PARAMETER SCATYP = 9		! scaled symbol
	PARAMETER TEXTYP = 10		! text
	PARAMETER STRTYP = 11		! symbol string
	PARAMETER ARETYP = 12		! fill area
	INTEGER		FRTMAX		! number of FCs
	INTEGER*4	FRTCNT		! count of defined FCs
	INTEGER*4	FRTIND		! index of selected FC
	INTEGER*4	FRTFC		! the selected FC
	INTEGER*4	FRTGT		! its Graphical Type
	INTEGER*4	FRTCOL		! its colour
	REAL		FRTWID		! its width
	REAL		FRTSIZ		! its size
	INTEGER*4	FRTSC		! its Secondary Code
	INTEGER*4	FRTFLG		! flags word
	INTEGER*4	FRTHW		! symbol for hardware line
	INTEGER*4	FRTHWL		! hardware line style
	INTEGER*4	FRTAST		! fill area internal style
	INTEGER*4	FRTAIX		! fill area style index
	LOGICAL*4	FRTHWS		! true if to use hardware symbol
	LOGICAL*4	FRTLIN		! true if linear
	LOGICAL*4	FRTSYM		! true if symbol
	LOGICAL*4	FRTARC		! true if circle arc
	LOGICAL*4	FRTCUR		! true if curve
	LOGICAL*4	FRTTEX		! true if text
	LOGICAL*4	FRTARE		! true if fill area
	INTEGER*4	FRTINT_LOC	! ptr to integers
	INTEGER*4	FRTFLT_LOC	! ptr to floats (reals)
	LOGICAL*4	FRTHKS		! true if thick lines supressed
	LOGICAL*4	FRTCLP		! true if to clip symbols in
					! patterened fill areas
	COMMON/FRTCOM/FRTMAX,FRTCNT,FRTIND,FRTFC,FRTGT,FRTCOL,
     &                FRTWID,FRTSIZ,FRTSC,FRTFLG,FRTHW,FRTHWL,
     &		      FRTAST,FRTAIX,FRTHWS,
     &                FRTLIN,FRTARC,FRTCUR,FRTSYM,FRTTEX,FRTARE,
     &	              FRTHKS,FRTCLP,
     &		      FRTINT_LOC,FRTFLT_LOC
	INTEGER*4	MAX_TXTLIM	! maximum possible buffer length
	PARAMETER	(MAX_TXTLIM = 1024)
	INTEGER*4	DEF_TXTLIM	! default buffer length
	PARAMETER	(DEF_TXTLIM = 255)
	INTEGER*2 	DCPTR   	! decode pointer
	INTEGER*2 	TXTPTR  	! end of line pointer
	BYTE		TXTTYP  	! type of fake string
	BYTE		TXTCLA  	! class of fake string
	INTEGER*4 	TXTADD  	! address of buffer
	INTEGER*2 	TXTLIM  	! actual buffer length
	BYTE 		TXTBUF(MAX_TXTLIM)  	! text buffer
	INTEGER*4	TXTDSC(2)	! fake string descriptor
	EQUIVALENCE	(TXTDSC,TXTPTR)
	COMMON/LSL_TXTC/DCPTR,TXTPTR,TXTTYP,TXTCLA,TXTADD,TXTLIM,TXTBUF
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER		MAX_SYMBOLS
	PARAMETER	(MAX_SYMBOLS = 15)
	LOGICAL		SYMBOLS		! TRUE if enabled symbols
	LOGICAL		MOVE_SYMBOLS	! TRUE if currently moving symbols
	INTEGER		SYMBOLS_DEFINED	! number of symbols defined
	INTEGER		SYMBOLS_USED	! number of symbols used
	INTEGER*4	SYMBOL_IDATA(9,MAX_SYMBOLS)	!integer form 
	LOGICAL*4	SYMBOL_LDATA(9,MAX_SYMBOLS)	!logical form 
	REAL*4		SYMBOL_RDATA(9,MAX_SYMBOLS)	!real form 
	EQUIVALENCE 	(SYMBOL_IDATA,SYMBOL_LDATA,SYMBOL_RDATA)
	COMMON/USER_SYMBOLS/ 
     &		SYMBOLS,
     &		MOVE_SYMBOLS,
     &		SYMBOLS_DEFINED,
     &		SYMBOLS_USED,
     &		SYMBOL_IDATA
	LOGICAL 	OK		! return code
	INTEGER 	I		! loop controls.
	INTEGER		SYMBOL_NUM	! temp variable to hold symbol number
	INTEGER		SYMBOL_FC	! temp variable to hold symbol fc	
	LOGICAL 	FRTFND
	SYMBOL_FC_CMD = .TRUE.		! assume success
	IF(CMDICT.NE.2)THEN
	   CALL WRITEF('%S Specifying command SYMBOL FC',
     &	   ERROR_BELL)
	   CALL WRITEF('Command requires 2 integer arguments')
	   CALL WRITEF('eg SYMBOL FC <symbol number> <feature code>')
	   SYMBOL_FC_CMD=.FALSE.
	   GOTO 999
	ENDIF
	SYMBOL_NUM = INTARG(1) 
	SYMBOL_FC = INTARG(2) 
	OK = FRTFND(SYMBOL_FC)	
	IF(.NOT.FRTSYM) THEN
	   CALL WRITEF('%S Specifying command SYMBOL FC',
     &	   ERROR_BELL)
	   CALL WRITEF('Feature code %I0 is not a point symbol ',
     &	   SYMBOL_FC)
	   SYMBOL_FC_CMD=.FALSE.
	   GOTO 999
	ENDIF
	IF(SYMBOL_LDATA(5,SYMBOL_NUM)) THEN
	   CALL WRITEF('%S Symbol %I0 is being redefined',
     &	   WARN_BELL,SYMBOL_NUM)
	   SYMBOLS_DEFINED = SYMBOLS_DEFINED - 1
	ENDIF
	SYMBOL_IDATA(1,SYMBOL_NUM) = SYMBOL_NUM
	SYMBOL_IDATA(4,SYMBOL_NUM) = SYMBOL_FC
	SYMBOL_LDATA(5,SYMBOL_NUM) = .TRUE.
	SYMBOLS_DEFINED = SYMBOLS_DEFINED + 1
	GOTO 1000
999	CONTINUE
1000	CONTINUE
	RETURN
	END

	LOGICAL FUNCTION SYMBOL_POSITION_CMD()
	IMPLICIT NONE
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	INTEGER*4	DTIPROJ_IDENT1
	PARAMETER	(DTIPROJ_IDENT1='*DTI')
	INTEGER*4	DTIPROJ_IDENT2
	PARAMETER	(DTIPROJ_IDENT2='PROJ')
	INTEGER*4	NUM_DTI
	PARAMETER	(NUM_DTI=9)
	INTEGER*4	DTIPROJ_RECORD_LENGTH	
	PARAMETER	(DTIPROJ_RECORD_LENGTH=1600)
	INTEGER*4	DTIPROJ_RECORD_OFFSET(NUM_DTI)
	REAL*8		DTIPROJ_ORIGIN(2,NUM_DTI)
	REAL*4 		DTIPROJ_SAMPLE(2,NUM_DTI)
	INTEGER*4	DTIPROJ_UNITS(NUM_DTI)
	INTEGER*4	DTIPROJ_SPHEROID(NUM_DTI)
	INTEGER*4	DTIPROJ_PROJECTION(NUM_DTI)
	REAL*8		DTIPROJ_USER_SPHEROID(2,NUM_DTI)
	REAL*8		DTIPROJ_PROJ_PARAMS(15,NUM_DTI)
	COMMON/DTIPROJ/	
     &			DTIPROJ_RECORD_OFFSET,
     &			DTIPROJ_ORIGIN,DTIPROJ_SAMPLE,
     &			DTIPROJ_UNITS,DTIPROJ_SPHEROID,
     &			DTIPROJ_PROJECTION,
     &			DTIPROJ_USER_SPHEROID,
     &			DTIPROJ_PROJ_PARAMS
	INTEGER*4	INTARG(8)
	REAL		REALAR(8)
	INTEGER*2	CMDNLE,SECNLE,STARLE
	INTEGER*4	CMDNST(2),SECNST(2),STARST(2)
	INTEGER*4	CMDFST(2)	! copy of 'descriptor' for
	INTEGER*4	CMSFST(2)	! ditto for secondary command
	INTEGER*4	CMDAST(2)	! copy of same for subject
	INTEGER*4	CMDNUM
	INTEGER*4	TABFLG,CMDFLG
	INTEGER*4	SECMDN		! secondary command number
	INTEGER*4	SECTAB		! table secondary command is to
	INTEGER*4	CMDACT,CMDICT,CMDRCT
	INTEGER*4	DEFBASE
	LOGICAL*1	ARGMSG,CMDNEG,HADDOT,NOMESS
	BYTE		INEQUAL
	LOGICAL*1	NOUFLG		! TRUE => no user flags with
	LOGICAL*1	NSUFLG		! ditto for 2ndary table
	BYTE		UNXCHR		! 'unexpected character' that
	INTEGER*4	UFLAG		! user flag found, if any
	INTEGER*4	SUFLAG		! secondary table user flag
	COMMON /LSL_CMDCOM/	INTARG,REALAR,
     &				CMDNST,SECNST,STARST,
     &				CMDFST,CMSFST,CMDAST,
     &				CMDNUM,TABFLG,CMDFLG,
     &				SECMDN,SECTAB,
     &				CMDACT,CMDICT,CMDRCT,
     &				DEFBASE,
     &				ARGMSG,CMDNEG,HADDOT,NOMESS,
     &				INEQUAL,
     &				NOUFLG,NSUFLG,UNXCHR,UFLAG,SUFLAG
	EQUIVALENCE (CMDNLE,CMDNST)
	EQUIVALENCE (SECNLE,SECNST)
	EQUIVALENCE (STARLE,STARST)
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	COMMON/	DTEQIO/ISB,IN_CHAN,OUT_CHAN,TERM,TTOPRO,TTIDON,TTODON,
     &			HADQIO,TTOBEL,HAD_INDIRECT_FILE
	INTEGER*2 ISB(4)	! input status block
	INTEGER*2 ISB_STATUS	! status
	INTEGER*2 ISB_TOFF	! offset to terminator
	INTEGER*2 ISB_TSIZ	! terminator size
	INTEGER*2 ISB_TRM	! the terminator itself
	EQUIVALENCE(ISB(1),ISB_STATUS)
	EQUIVALENCE(ISB(2),ISB_TOFF)
	EQUIVALENCE(ISB(3),ISB_TRM)
	EQUIVALENCE(ISB(4),ISB_TSIZ)
	INTEGER		IN_CHAN	! input channel number
	INTEGER		OUT_CHAN! output channel number
	LOGICAL*1	TERM	! output is a terminal
	LOGICAL*1	TTOPRO	! next output is a prompt
	LOGICAL*1	TTOBEL	! output with no carriage controls
	LOGICAL*1	TTIDON	! had input since last prompt
	LOGICAL*1	TTODON	! had output since last prompt
	LOGICAL*1	HADQIO	! QIO outstanding
	LOGICAL*1	HAD_INDIRECT_FILE	! input from indirect file
	BYTE		BUTTON		! puck button number
	INTEGER		IERR		! error number
	LOGICAL*1	ERR		! error?
	LOGICAL*1	HAD_VDU		! had keyboard input?	
	LOGICAL*1	TABLE		! got a table?
	INTEGER		EF_POINT	! EF for puck-button input
	INTEGER		EF_STREAM	! EF for stream-button input
	INTEGER		EF_ERROR	! EF for table monitor error
	INTEGER		EF_VDU		! event flag for input from kybd
	INTEGER		EF_LAST		! not used here -dummy
	COMMON/TAB/	EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST,
     +			IERR,BUTTON,ERR,HAD_VDU,TABLE
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	INTEGER		MAX_SYMBOLS
	PARAMETER	(MAX_SYMBOLS = 15)
	LOGICAL		SYMBOLS		! TRUE if enabled symbols
	LOGICAL		MOVE_SYMBOLS	! TRUE if currently moving symbols
	INTEGER		SYMBOLS_DEFINED	! number of symbols defined
	INTEGER		SYMBOLS_USED	! number of symbols used
	INTEGER*4	SYMBOL_IDATA(9,MAX_SYMBOLS)	!integer form 
	LOGICAL*4	SYMBOL_LDATA(9,MAX_SYMBOLS)	!logical form 
	REAL*4		SYMBOL_RDATA(9,MAX_SYMBOLS)	!real form 
	EQUIVALENCE 	(SYMBOL_IDATA,SYMBOL_LDATA,SYMBOL_RDATA)
	COMMON/USER_SYMBOLS/ 
     &		SYMBOLS,
     &		MOVE_SYMBOLS,
     &		SYMBOLS_DEFINED,
     &		SYMBOLS_USED,
     &		SYMBOL_IDATA
	INTEGER*4	X1,Y1,X2,Y2	! window values in matrix units
	INTEGER*4	LLDEGS(4)	! window values in seconds
	INTEGER		SYM_NUM		! symbol number
	LOGICAL		OK		! return code
	LOGICAL		READLL		! reads lat/long
	LOGICAL		PROCESS_SYMBOLS	! process to plot symbols
	SYMBOL_POSITION_CMD=.TRUE.		! assume success
	IF (CMDRCT.NE.3.AND.UNITS.NE.4) THEN
	   IF(CMDRCT.GT.0.AND.REALAR(1).EQ.0) THEN
	      SYM_NUM = NINT(REALAR(1))	!  symbol number
	      GOTO 50
	   ENDIF
	   CALL WRITEF('%S Specifying command SYMBOL POSITION ',
     &	   ERROR_BELL)
	   CALL WRITEF
     &	  ('Command requires symbol number and x,y coordinate pair')
	   SYMBOL_POSITION_CMD =.FALSE.
	   GOTO 999
	ENDIF
	SYM_NUM = NINT(REALAR(1))	!  symbol number
	IF((SYM_NUM.LT.1).OR.(SYM_NUM.GT.MAX_SYMBOLS)) THEN
	   CALL WRITEF('%S Specifying command SYMBOL POSITION ',
     &	   ERROR_BELL)
	   CALL WRITEF
     &	   ('Symbol number less than 1 or greater than %I0',
     &     MAX_SYMBOLS)
	   SYMBOL_POSITION_CMD =.FALSE.
	   GOTO 999
	ENDIF
	GOTO (10,20,30,40,45) UNITS
10	CONTINUE
	X1=NINT(REALAR(2))
	Y1=NINT(REALAR(3))
	GOTO 50
20	CONTINUE
	IF (HAD_ABSOLUTE)THEN
	   X1=NINT((REALAR(2)-X_OFFSET(1))/X_GRID(1))+1
	   Y1=NINT((REALAR(3)-Y_OFFSET(1))/Y_GRID(1))+1
	ELSE
	   X1=NINT((REALAR(2))/X_GRID(1))+1
	   Y1=NINT((REALAR(3))/Y_GRID(1))+1
	ENDIF
	GOTO 50
30	CONTINUE
	Y1=NINT(REALAR(2)*10)
	X1=NINT(REALAR(3)*10)
	X1=((X1-LONREC(1,1))/LONINT(1))+1
	Y1=((Y1-LATREC(1,1))/LATINT(1))+1
	GOTO 50
40	CONTINUE
	IF (READLL(LLDEGS,2,.TRUE.)) THEN
	   CALL WRITEF('%S Specifying symbol position ',ERROR_BELL)
	   CALL WRITEF('Unable to use supplied LATLONG values')
	   SYMBOL_POSITION_CMD =.FALSE.
	   GOTO 999
	ELSE
	   Y1=LLDEGS(1)*10
	   X1=LLDEGS(2)*10
	   X1=((X1-LONREC(1,1))/LONINT(1))+1
	   Y1=((Y1-LATREC(1,1))/LATINT(1))+1
	ENDIF
	GOTO 50
45	CONTINUE
	IF (HAD_ABSOLUTE) THEN 
	   X1=NINT((REALAR(2)-DTIPROJ_ORIGIN(1,1))
     &             /DTIPROJ_SAMPLE(1,1))+1
	   Y1=NINT((REALAR(3)-DTIPROJ_ORIGIN(2,1))
     &             /DTIPROJ_SAMPLE(2,1))+1
	ELSE
	   X1=NINT(REALAR(2)/DTIPROJ_SAMPLE(1,1))+1
	   Y1=NINT(REALAR(3)/DTIPROJ_SAMPLE(2,1))+1
	ENDIF
	GOTO 50
50	CONTINUE
	OK = PROCESS_SYMBOLS(SYM_NUM,X1,Y1,.FALSE.)
	IF(.NOT.OK) THEN
	   SYMBOL_POSITION_CMD = .FALSE.
	   GOTO 999
	ENDIF
	GOTO 1000
999	CONTINUE
1000	CONTINUE
	RETURN
	END
