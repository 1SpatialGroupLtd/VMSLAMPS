	SUBROUTINE PLTPOS(ADVANCE,CLEAR)
	IMPLICIT NONE
	LOGICAL		ADVANCE		! advance quadrant?
	LOGICAL		CLEAR		! routine called to set up
	REAL		XSCALE		! viewing
	REAL		YSCALE		! scaling
	REAL		ZSCALE		! factors
	REAL		DOV		! positions of view
	REAL		DOVSC		! scaled ditto
	REAL		DEFZSC		! default height exaggeration
	REAL		DEFHOV		! 'default' height of view
	REAL		HOV		! height of view * exag'n.
	REAL*8		DEFPHI,DEFTHT	! default angles of view
	REAL*8		PHI, THETA	! angles
	REAL*8		SPHI, STHETA	! sines
	REAL*8		CPHI, CTHETA	! cosines
	REAL*8		A1, A2		! coefficients for perspective
	REAL*8		A11, A13	! coefficients for
	REAL*8		A21, A22, A23	! isometric views
	REAL		DIST, Z0	! projn values for perspective
	REAL		VWMINX, VWMINY	! range of
	REAL		VWMAXX, VWMAXY	! plotted view
	INTEGER*4	DIRECT		! direction of view
	INTEGER*4	INDINC		! index increment
	LOGICAL*1	PRSPVW		! view is true perspective
	COMMON /DTMBUF/ DOV,DOVSC,DEFPHI,DEFTHT,DEFZSC,DEFHOV,DIRECT,PRSPVW,
     &			PHI,THETA,SPHI,STHETA,CPHI,CTHETA,
     &			A1,A2,A11,A13,A21,A22,A23,DIST,Z0,
     &                	VWMINX,VWMINY,VWMAXX,VWMAXY,
     &		      	INDINC,HOV,XSCALE,YSCALE,ZSCALE
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
	REAL*8		F	! a scaling factor
	REAL		U	! 1 world-unit = U device- units
	REAL		DX,DY	! window limit adjustments
	REAL		OX,OY	! device origin
	REAL		WXC,WYC	! world centre
	REAL		WXR,WYR	! world X and Y ranges
	REAL		DUMMY	! dummy real
	REAL		BORDER	! size of border to leave
	REAL		SCAFAC	! picture scale factor
	INTEGER		WKID	! workstation identifier
	LOGICAL		DUNSEC	! set plot pos for TEK yet
	IF (.NOT.(PRIMARY.OR.SECONDARY))GOTO 999
	IF (AUTO) THEN
	  IF (ADVANCE.AND.VIEW_SHOWN(1,QUAD)) THEN
	    IF (SPLIT) QUAD = QUAD+1
	    IF (QUAD.GT.4) QUAD = 1
	  END IF
	ELSE
	  QUAD = 0	! always draw non-auto scaled pic in seg 1
	END IF
	DUNSEC=.FALSE.
	IF(PRIMARY)THEN
	  WKID=1
	  GOTO 20
	ENDIF
10	DUNSEC=.TRUE.
	IF(SECONDARY)THEN
	  WKID = TEK
	  GOTO 20
	ENDIF
	GOTO 80				! return
20	IF(.NOT.CLEAR)THEN
	  WXMIN = VWMINX
	  WXMAX = VWMAXX
	  WYMIN = VWMINY
	  WYMAX = VWMAXY
	ENDIF
	IF((CLEAR).OR.(WXMIN.EQ.WXMAX)) THEN	! world may still be undefined
	  WXMIN = 0
	  WXMAX = SCRNDX(WKID)
	  WYMIN = 0
	  WYMAX = SCRNDY(WKID)
	END IF
	F = ((WYMAX-WYMIN)/(WXMAX-WXMIN))*(SCRNDX(WKID)/SCRNDY(WKID))
	IF (F.GE.1) THEN
	  DX = (WXMAX-WXMIN)*(F-1)/2
	  WXMIN = WXMIN-DX
	  WXMAX = WXMAX+DX
	ELSE
	  DY = (WYMAX-WYMIN)*(1/F-1)/2
	  WYMIN = WYMIN-DY
	  WYMAX = WYMAX+DY
	END IF
	CALL GSWN(1,WXMIN,WXMAX,WYMIN,WYMAX)
	F = SCRNDY(WKID)/SCRNDX(WKID)
	CALL GSVP(1,0.0,1.0,0.0,F)
	CALL GSELNT(1)
	CALL GSWKWN(WKID,0.0,1.0,0.0,F)
	CALL GSWKVP(WKID,0.0,SCRNDX(WKID),0.0,SCRNDY(WKID))
	WXR = WXMAX-WXMIN			! world ranges
	WYR = WYMAX-WYMIN
	IF (CLEAR) THEN
	   BORDER = 0.0			! nothing for clearing
	ELSE
	   BORDER = 0.0125		! small border for models
	ENDIF
	SCAFAC = 0.5-2.0*BORDER
	DX = BORDER*WXR				! margin width
	DY = BORDER*WYR
	IF (.NOT.AUTO) THEN			! no auto-scaling?
	  CALL GEVTM(	WXMIN,WYMIN,		! fixed point
     +			MAT(5)*WXR,MAT(6)*WYR,	! shift vector
     +			0.0,			! rotation
     +			MAT(1),MAT(4))		! scale factors
	ELSE IF (SPLIT) THEN
	  WXC = WXR/2				! screen centre
	  WYC = WYR/2
	  GOTO (30,40,50,60) QUAD		! depending on quadrant
30	  CALL GEVTM(WXMIN,WYMIN,DX,WYC+DY,0.0,SCAFAC,SCAFAC)    !UL
	  GOTO 70
40	  CALL GEVTM(WXMIN,WYMIN,WXC+DX,WYC+DY,0.0,SCAFAC,SCAFAC)!UR
	  GOTO 70
50	  CALL GEVTM(WXMIN,WYMIN,WXC+DX,DY,0.0,SCAFAC,SCAFAC)    !LR
	  GOTO 70
60	  CALL GEVTM(WXMIN,WYMIN,DX,DY,0.0,SCAFAC,SCAFAC)        !LL
70	  CONTINUE
	ELSE
	  SCAFAC = SCAFAC*2.0
	  CALL GEVTM(WXMIN,WYMIN,DX,DY,0.0,SCAFAC,SCAFAC) !full screen
	ENDIF
80	IF (.NOT.DUNSEC) GOTO 10 ! repeat window setting for secondary dev
999	RETURN
	END

	SUBROUTINE MODEL
	IMPLICIT NONE
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
	REAL		XSCALE		! viewing
	REAL		YSCALE		! scaling
	REAL		ZSCALE		! factors
	REAL		DOV		! positions of view
	REAL		DOVSC		! scaled ditto
	REAL		DEFZSC		! default height exaggeration
	REAL		DEFHOV		! 'default' height of view
	REAL		HOV		! height of view * exag'n.
	REAL*8		DEFPHI,DEFTHT	! default angles of view
	REAL*8		PHI, THETA	! angles
	REAL*8		SPHI, STHETA	! sines
	REAL*8		CPHI, CTHETA	! cosines
	REAL*8		A1, A2		! coefficients for perspective
	REAL*8		A11, A13	! coefficients for
	REAL*8		A21, A22, A23	! isometric views
	REAL		DIST, Z0	! projn values for perspective
	REAL		VWMINX, VWMINY	! range of
	REAL		VWMAXX, VWMAXY	! plotted view
	INTEGER*4	DIRECT		! direction of view
	INTEGER*4	INDINC		! index increment
	LOGICAL*1	PRSPVW		! view is true perspective
	COMMON /DTMBUF/ DOV,DOVSC,DEFPHI,DEFTHT,DEFZSC,DEFHOV,DIRECT,PRSPVW,
     &			PHI,THETA,SPHI,STHETA,CPHI,CTHETA,
     &			A1,A2,A11,A13,A21,A22,A23,DIST,Z0,
     &                	VWMINX,VWMINY,VWMAXX,VWMAXY,
     &		      	INDINC,HOV,XSCALE,YSCALE,ZSCALE
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
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
	REAL		ABS_OBS_X	! absolute x coord of observer in metres
	REAL		ABS_OBS_Y	! absolute y coord of observer in metres
	REAL		ABS_OBS_Z	! absolute z coord of observer in metres
	REAL		ABS_X		! absolute x coord of DTM node in metres
	REAL		ABS_Y		! absolute y coord of DTM node in metres
	REAL		ABS_Z		! absolute z coord of DTM node in metres
	REAL		ABS_X_GRID	! x grid matrix interval in metres
	REAL		ABS_Z_GRID	! y grid matrix interval in metres
	INTEGER		FOG_COLOUR	! colour of the fog
	REAL		FOG_VISIBILITY	! visibility distance
	LOGICAL		HAD_FOG		! fog enabled
	LOGICAL		IN_FOG		! DTM node in fog
	COMMON/FOG/ 
     &		ABS_OBS_X,
     &		ABS_OBS_Y,
     &		ABS_OBS_Z,
     &		ABS_X,
     &		ABS_Y,
     &		ABS_Z,
     &		ABS_X_GRID,
     &		ABS_Z_GRID,
     &		FOG_COLOUR,
     &		FOG_VISIBILITY,
     &		HAD_FOG,
     &		IN_FOG
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
	REAL		X,Y,Z		! model coordinates
	REAL		XX,YY		! view  coordinates
	INTEGER*4	NLINE		! line number
	INTEGER*4	NPNTS
	INTEGER*4	XGRID
	INTEGER*4	YGRID
	INTEGER*4	XSTART		! line drawing
	INTEGER*4	YSTART 		! line and
	INTEGER*4	XEND		! column
	INTEGER*4	YEND		! limits, and
	INTEGER*4	XSTEP		! loop increment
	INTEGER*4	YSTEP		! values.
	INTEGER*4	INXPOS		! initial X drawing position
	INTEGER*4	XPOS		! current X drawing position
	INTEGER*4	XINC 		! X drawing position increment
	INTEGER*4	I, J		! loop variables
	INTEGER*4	RETVAL		! function return value
	INTEGER*2	THISY		! height at current point
	INTEGER*2	PREVY		! height at previous point
	LOGICAL		NOPLOT		! to plot or not to plot
	LOGICAL		STORE_VIS	! have the plot coords been
	INTEGER*4	DTI_READ_WORD_DATA
	INTEGER		ICOL
	LOGICAL		HADCTRLC
	LOGICAL		POINT_VISIBLE
	IF(PRIMARY)THEN
	  CALL LSG_PLANE_SELECT(1,PLANE_MASK)
	  CALL LSG_PLANE_OFFSET(1,0)
	  CALL LSG_PLANE_VISIBLE(1,-1)
	ENDIF
	IF(SECONDARY)THEN
	  CALL LSG_PLANE_SELECT(2,PLANE_MASK)
	  CALL LSG_PLANE_OFFSET(2,0)
	  CALL LSG_PLANE_VISIBLE(2,-1)
	ENDIF
	PHI    = DEFPHI
	THETA  = DEFTHT
	IF (DIRECT.EQ.1 .OR. DIRECT.EQ.3) THEN
	  YSCALE = DEFZSC * X_SAMPLE
	ELSE
	  YSCALE = DEFZSC * Y_SAMPLE
	ENDIF
	HOV    = DEFHOV*YSCALE	!muliply height of view by exagg. factor
	IF (DIRECT.EQ.2 .OR. DIRECT.EQ.4) THEN	!north or south
	   XSCALE = (-X_GRID(1)*X_SAMPLE)
	   ZSCALE = (-Y_GRID(1)*Y_SAMPLE)
	   NPNTS = NLINES
	   IF (HAD_FOG .AND. PRSPVW) THEN
	      ABS_X_GRID = X_GRID(1)
	      ABS_Z_GRID = Y_GRID(1)
	   ENDIF
	ELSE					!east or west
	   XSCALE = (-Y_GRID(1)*Y_SAMPLE)
	   ZSCALE = (-X_GRID(1)*X_SAMPLE)
	   NPNTS = NPTS
	   IF(HAD_FOG.AND.PRSPVW) THEN
	      ABS_X_GRID = Y_GRID(1)
	      ABS_Z_GRID = X_GRID(1)
	   ENDIF
	ENDIF
	IF (PRSPVW) THEN
	  SPHI = SIN(0.0174532925*PHI)
          CPHI = COS(0.0174532925*PHI)
          A1 = -SPHI
          A2 = CPHI
	  IF (HAD_FOG) THEN
	     ABS_OBS_X = 0.0
	     ABS_OBS_Y = HOV
	     ABS_OBS_Z = -DOV
	  ENDIF
          DOVSC = DOV * 0.5*(ABS(XSCALE) + ABS(ZSCALE))
          DIST = DOVSC + FLOAT(NPNTS-1)*(SPHI*ABS(XSCALE)+
     &	          CPHI*ABS(ZSCALE))
	  Z0   = 0.0
          IF (SPHI*XSCALE.GT.0.0) Z0 = SPHI*XSCALE*FLOAT(NPNTS-1)
        ELSE
          SPHI = SIN(0.0174532925*PHI)
          CPHI = COS(0.0174532925*PHI)
          STHETA = SIN(0.0174532925*THETA)
          CTHETA = COS(0.0174532925*THETA)
          A11 = CPHI
          A13 = -SPHI
          A21 = STHETA*SPHI
          A22 = CTHETA
          A23  = STHETA*CPHI
        ENDIF
        CALL HORINI
	NOPLOT = .TRUE.			!don't plot this time round
	STORE_VIS = .FALSE.		!don't encode visibility matrix
	VWMINX =  100 000.0
	VWMAXX = -100 000.0
	VWMINY =  100 000.0
	VWMAXY = -100 000.0
	MODMIN = MAX_WVALUE(1)
	MODMAX = MIN_WVALUE(1)
        GOTO (130,140,150,160)DIRECT 
130     XSTART = DTI_WINDOW_SWX(1)
	XEND   = DTI_WINDOW_NEX(1)
	YSTART = DTI_WINDOW_NEY(1)
	YEND   = DTI_WINDOW_SWY(1)
	XSTEP  =  X_SAMPLE
	YSTEP  = -Y_SAMPLE
	INXPOS = NPTS + X_SAMPLE
	XINC   = -X_SAMPLE
        GOTO 170
140     XSTART = DTI_WINDOW_SWY(1)
	XEND   = DTI_WINDOW_NEY(1)
	YSTART = DTI_WINDOW_SWX(1)
	YEND   = DTI_WINDOW_NEX(1)
	XSTEP  = Y_SAMPLE
	YSTEP  = X_SAMPLE
	INXPOS = NLINES + Y_SAMPLE
	XINC   = -Y_SAMPLE
        GOTO 170
150     XSTART = DTI_WINDOW_NEX(1)
	XEND   = DTI_WINDOW_SWX(1)
	YSTART = DTI_WINDOW_SWY(1)
	YEND   = DTI_WINDOW_NEY(1)
	XSTEP  = -X_SAMPLE
	YSTEP  = Y_SAMPLE
        INXPOS = NPTS + X_SAMPLE
        XINC   = -X_SAMPLE 
	GOTO 170
160     XSTART = DTI_WINDOW_NEY(1)
	XEND   = DTI_WINDOW_SWY(1)
	YSTART = DTI_WINDOW_NEX(1)
	YEND   = DTI_WINDOW_SWX(1)
	XSTEP  = -Y_SAMPLE
	YSTEP  = -X_SAMPLE
	INXPOS = NLINES + Y_SAMPLE
	XINC   = -Y_SAMPLE
170	NLINE = 0
	DO 500 I = XSTART,XEND,XSTEP
200	  IF (HADCTRLC()) GOTO 990
	  Z = FLOAT(NLINE)*ZSCALE
	  NLINE = NLINE + ABS(XSTEP)
	  XPOS = INXPOS		!set to initial x position
	  DO 400 J = YSTART,YEND,YSTEP
	    IF(HAD_FOG .AND. PRSPVW .AND. .NOT.NOPLOT) THEN
	      ABS_Z = (I-XSTART) * ABS_Z_GRID * ABS(XSTEP) * CPHI +
     &		        (J-YEND) * ABS_X_GRID * ABS(YSTEP) * SPHI
	      ABS_X = -(J-YEND) * ABS_X_GRID * ABS(YSTEP) * CPHI +
     &		     (I-XSTART) * ABS_Z_GRID * ABS(XSTEP) * SPHI
	    ENDIF
	    XPOS = XPOS+XINC
300	    IF (DIRECT.EQ.1 .OR. DIRECT.EQ.3) THEN
	      RETVAL = DTI_READ_WORD_DATA(1,THISY,I,J)	     
	      IF (.NOT.RETVAL) THEN
	        CALL LSL_PUTMSG(RETVAL)
	        GOTO 999
	      ENDIF
	    ELSE
	      RETVAL = DTI_READ_WORD_DATA(1,THISY,J,I)	     
	      IF (.NOT.RETVAL) THEN
	        CALL LSL_PUTMSG(RETVAL)
	        GOTO 999
	      ENDIF
	    ENDIF
	    IF (HAD_FOG .AND. PRSPVW .AND. .NOT.NOPLOT) THEN
	      ABS_Y = FLOAT(THISY)
	    ENDIF
	    MODMAX = MAX(MODMAX,THISY)
	    MODMIN = MIN(MODMIN,THISY)
	    IF (BATH) THEN
	      IF (THISY.GT.0) THISY=1		! treat land as flat 
	    ENDIF
	    IF (J.EQ.YSTART) THEN		! initialise the line
	      PREVY = THISY
	      PREV_INDEX = -1
	      X = FLOAT(XPOS)*XSCALE
	      IF (THISY.LE.-32766) THEN	!null height
	        Y = (ZLOWER-1.0)*YSCALE
	      ELSE
	        Y = FLOAT(THISY)*YSCALE
	      ENDIF
	      IF (HAD_FOG .AND. PRSPVW .AND. .NOT.NOPLOT) THEN
	        IN_FOG = (.NOT.POINT_VISIBLE())		
	      ENDIF
	      CALL CORDTF(X,Y,Z,XX,YY)	!transform coordinates
	      IF (.NOT.NOPLOT) CALL HORVIN(XX,YY)
	      IF ((OVERLAY .OR. FISHNET .OR. SYMBOLS) .AND. 
     &						(STORE_VIS)) THEN
	        XGRID=I
	        YGRID=J
	        IF (DIRECT.EQ.2 .OR. DIRECT.EQ.4)THEN	
	          CALL VSBLTY(XGRID,YGRID)	   
	        ELSE
	          CALL VSBLTY(YGRID,XGRID)
	        ENDIF
	      ENDIF
	      GOTO 400
	    ENDIF	   	   	        
	    X = FLOAT(XPOS)*XSCALE
	    IF (THISY.LE.-32766) THEN
	      Y = (ZLOWER-10.0)*YSCALE
	    ELSE
	      Y = FLOAT(THISY)*YSCALE
	    ENDIF
	    IF (HAD_FOG .AND. PRSPVW .AND. .NOT.NOPLOT) THEN
	      IN_FOG = (.NOT.POINT_VISIBLE())		
	    ENDIF
	    IF (.NOT.NOPLOT) THEN
	      IF (THISY.LE.-32766 .OR. PREVY.LE.-32766) THEN
	        COLOUR_INDEX = 0
	      ELSE
	        IF (HAD_FOG .AND. PRSPVW) THEN
	          IF (IN_FOG) THEN
		    COLOUR_INDEX = FOG_COLOUR
	          ELSE
	            COLOUR_INDEX = ICOL(MAX(THISY,PREVY))
	          ENDIF
	        ELSE
	          COLOUR_INDEX=ICOL(MAX(THISY,PREVY))
	        ENDIF
	      ENDIF
	      CALL SET_COLOUR(COLOUR_INDEX)
	    ENDIF
	    CALL CORDTF(X,Y,Z,XX,YY)
            IF (.NOT.NOPLOT) CALL HORVNX(XX,YY)
            IF ((OVERLAY .OR. FISHNET .OR. SYMBOLS) .AND. 
     &						(STORE_VIS)) THEN
	      XGRID=I
	      YGRID=J
	      IF (DIRECT.EQ.2 .OR. DIRECT.EQ.4)THEN
	        CALL VSBLTY(XGRID,YGRID)	   
	      ELSE
	        CALL VSBLTY(YGRID,XGRID)
	      ENDIF
	    ENDIF
	    PREVY = THISY 	    
400	  CONTINUE
	  IF ((YSTEP.LT.-1 .AND. J.GT.YEND) .OR.
     &        (YSTEP.GT.1  .AND. J.LT.YEND)) THEN
	    J = YEND
	    XPOS = XPOS+ABS(YEND-J)
	    GOTO 300		!jump back into the inner loop
	  ENDIF
500	CONTINUE
	IF ((XSTEP.LT.-1 .AND. I.GT.XEND) .OR.
     &      (XSTEP.GT.1  .AND. I.LT.XEND)) THEN
	  I = XEND
	  GOTO 400		!jump back into the outer loop
	ENDIF
	IF (.NOT.NOPLOT) GOTO 990
	IF (.NOT.STORE_VIS) STORE_VIS = .TRUE.
	NOPLOT = .FALSE.
	IF (.NOT.DTICOL) THEN
	  CALL SETCOL		! set colours based on MODMIN/MAX
	  CSTEP = INT((MODMAX-MAX(1,MODMIN))/STPINT)
	ELSE
	  CSTEP = INT( (MAX_WVALUE(1)-MAX(1,MIN_WVALUE(1))) /STPINT)
	ENDIF
	CSTEP = MAX(1,MIN(CSTEP,MAXCOL))
	CSTEP = MAXCOL/CSTEP
	CSTEP = MAX(1,CSTEP)
	IF (PRIMARY.OR.SECONDARY) THEN
	   CALL PLTPOS(.TRUE.,.FALSE.)	! now know min and max
	   CALL GSSGT		        !set segment transf
	   IF (PRIMARY)THEN
              CALL SHOTRN(1)
	      VIEW_SHOWN(1,QUAD) = .TRUE.
	   ENDIF
	   IF (SECONDARY)THEN
              CALL SHOTRN(2)
	      VIEW_SHOWN(2,QUAD) = .TRUE.
	   ENDIF
	ENDIF
	GOTO 170
990	IF (FISHNET) CALL DRAW_FISHNET
999	IF (.NOT.NOPLOT) THEN
	  CALL EOPIC
	  IF (.NOT.OVERLAY .AND. PLOT_IFF) CALL ENDIFF
	ENDIF
	RETURN
	END

	SUBROUTINE PROFILE(X1,Y1,X2,Y2)
	IMPLICIT NONE
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
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
	REAL		XSCALE		! viewing
	REAL		YSCALE		! scaling
	REAL		ZSCALE		! factors
	REAL		DOV		! positions of view
	REAL		DOVSC		! scaled ditto
	REAL		DEFZSC		! default height exaggeration
	REAL		DEFHOV		! 'default' height of view
	REAL		HOV		! height of view * exag'n.
	REAL*8		DEFPHI,DEFTHT	! default angles of view
	REAL*8		PHI, THETA	! angles
	REAL*8		SPHI, STHETA	! sines
	REAL*8		CPHI, CTHETA	! cosines
	REAL*8		A1, A2		! coefficients for perspective
	REAL*8		A11, A13	! coefficients for
	REAL*8		A21, A22, A23	! isometric views
	REAL		DIST, Z0	! projn values for perspective
	REAL		VWMINX, VWMINY	! range of
	REAL		VWMAXX, VWMAXY	! plotted view
	INTEGER*4	DIRECT		! direction of view
	INTEGER*4	INDINC		! index increment
	LOGICAL*1	PRSPVW		! view is true perspective
	COMMON /DTMBUF/ DOV,DOVSC,DEFPHI,DEFTHT,DEFZSC,DEFHOV,DIRECT,PRSPVW,
     &			PHI,THETA,SPHI,STHETA,CPHI,CTHETA,
     &			A1,A2,A11,A13,A21,A22,A23,DIST,Z0,
     &                	VWMINX,VWMINY,VWMAXX,VWMAXY,
     &		      	INDINC,HOV,XSCALE,YSCALE,ZSCALE
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
	INTEGER*4	X1		!DTI 
	INTEGER*4	Y1		!coord-
	INTEGER*4	X2		!inate
	INTEGER*4	Y2		!values
	REAL		X,Y		!plot coords
	REAL		ORIENT		!profile orientation
	REAL		PREVY		!previous value of Y
	REAL		DIFFX		!abs diff. between X2,X1
	REAL		DIFFY		!abs diff. between Y2,Y1
	REAL		XIN		!x intersection pt
	REAL		YIN		!Y intersection pt
	INTEGER*4	RETVAL		!function return value
	INTEGER*4	YPOS		!NINT(YIN)
	INTEGER*4	XPOS		!NINT(XIN)
	INTEGER*4	XPLOT		!X plot value
	INTEGER*4	STEP		!loop increment -1 or 1
	INTEGER*4	TEMPX,TEMPY	!temp variables
	INTEGER*4	THISZ		!height at current point
	INTEGER*4	SAMPLE		!loop
	INTEGER*4	LINE		!counters
	LOGICAL		NOPLOT		!to plot or not to plot?
	INTEGER*4	ICOL		!returns colour index
	INTEGER*4	DTI_READ_WORD_DATA	!return single DTI value
	IF (X1.EQ.X2.AND.Y1.EQ.Y2)GOTO 999	!return, without drawing
	NOPLOT=.TRUE.				!automatic scaling
	VWMINX= 100 000.0
	VWMINY= 100 000.0
	VWMAXY=-100 000.0
	VWMAXX=-100 000.0
	IF (X1.GT.X2) THEN
	  TEMPX=X1
	  TEMPY=Y1
	  X1=X2
	  Y1=Y2
	  X2=TEMPX
	  Y2=TEMPY
	ENDIF
 	DIFFX=ABS(X2-X1)
	DIFFY=ABS(Y2-Y1)
	YSCALE=DEFZSC			!vertical exaggeration
50	IF (DIFFY.EQ.0) THEN		!view from south
	  XSCALE = X_GRID(1)
	  XPLOT  = -1			!start at 0 at first sample
	  PREVY  = YSCALE
	  DO 100 SAMPLE=X1,X2
	     XPLOT=XPLOT+1			!update x plot position
	     RETVAL=DTI_READ_WORD_DATA(1,THISZ,SAMPLE,Y1)
	     IF(.NOT.RETVAL)THEN
	       CALL LSL_PUTMSG(RETVAL)
 	       GOTO 999
	     ENDIF
	     IF(THISZ.LE.-32767)THEN		!null height	     
	       Y=PREVY				!leave Y unchanged
	       CALL GSPLCI(0)			!draw in black
	     ELSE
	       Y=FLOAT(THISZ)*YSCALE
	       CALL GSPLCI(ICOL(THISZ))
	     ENDIF
	     X=FLOAT(XPLOT)*XSCALE		!actual plot positions
	     VWMINX=MIN(VWMINX,X)		!update plot limits
	     VWMAXX=MAX(VWMAXX,X)
	     VWMINY=MIN(VWMINY,Y)
	     VWMAXY=MAX(VWMAXY,Y)
	     PREVY=Y
	     IF(.NOT.NOPLOT)THEN
		IF(SAMPLE.EQ.X1)THEN
		  CALL G3MVTO(X,Y)
	        ELSE
	          CALL G3LNTO(X,Y)		! draw line to...
	        ENDIF
	     ENDIF
100       CONTINUE	
	  IF(.NOT.NOPLOT)CALL EOPIC		! ensure last line is drawn
	  GOTO 500
	ENDIF
150	IF (DIFFX.EQ.0) THEN		
	  XSCALE = Y_GRID(1)		! view from the west
	  XPLOT  = -1
	  PREVY  = YSCALE
	  IF(Y1.GT.Y2)THEN
	    STEP=-1
	  ELSE
	    STEP=1
	  ENDIF
	  DO 200 LINE=Y1,Y2,STEP
	    XPLOT=XPLOT+1			!update x plot position
	     RETVAL=DTI_READ_WORD_DATA(1,THISZ,X1,LINE)
	     IF(.NOT.RETVAL)THEN
	       CALL LSL_PUTMSG(RETVAL)
 	       GOTO 999
	     ENDIF
	     IF(THISZ.LE.-32767)THEN		!null height	     
	       Y=PREVY				!leave Y unchanged
	       CALL GSPLCI(0)			!draw in black
	     ELSE
	       Y=FLOAT(THISZ)*YSCALE
	       CALL GSPLCI(ICOL(THISZ))
	     ENDIF
	     X=FLOAT(XPLOT)*XSCALE		!actual plot positions
	     PREVY=Y
	     VWMINX=MIN(VWMINX,X)		!update plot limits
	     VWMAXX=MAX(VWMAXX,X)
	     VWMINY=MIN(VWMINY,Y)
	     VWMAXY=MAX(VWMAXY,Y)
	     IF(.NOT.NOPLOT)THEN
		IF(LINE.EQ.Y1)THEN
		  CALL G3MVTO(X,Y)
	        ELSE
	          CALL G3LNTO(X,Y)		! draw line to...
	        ENDIF
	     ENDIF
200       CONTINUE	
	  IF(.NOT.NOPLOT)CALL EOPIC		! ensure last line is drawn
	  GOTO 500
	ENDIF
	IF (DIFFY.GT.DIFFX) GOTO 320
	XPLOT = -1
	PREVY = YSCALE
	ORIENT = ATAN2(DIFFY,DIFFX)
	XSCALE = X_GRID(1)/COS(ORIENT)
	DO 300 SAMPLE=X1,X2
	  XPLOT=XPLOT+1
	  IF(SAMPLE.EQ.X1)THEN
	    YPOS=Y1
	    GOTO 250
	  ENDIF
	  IF(SAMPLE.EQ.X2)THEN
	    YPOS=Y2
	    GOTO 250
	  ENDIF
	  YIN=(Y1+(Y2-Y1)*(SAMPLE-X1)/(X2-X1))
	  YPOS=NINT(YIN)
250       RETVAL=DTI_READ_WORD_DATA(1,THISZ,SAMPLE,YPOS)
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
 	    GOTO 999
	  ENDIF
	  IF(THISZ.LE.-32767)THEN		!null height	     
	    Y=PREVY				!leave Y unchanged
	    CALL GSPLCI(0)			!draw in black
	  ELSE
	    Y=FLOAT(THISZ)*YSCALE
	    CALL GSPLCI(ICOL(THISZ))
	  ENDIF
	  X = FLOAT(XPLOT)*XSCALE		!actual plot positions
	  PREVY=Y
	  VWMINX=MIN(VWMINX,X)		!update plot limits
	  VWMAXX=MAX(VWMAXX,X)
	  VWMINY=MIN(VWMINY,Y)
	  VWMAXY=MAX(VWMAXY,Y)
	  IF(.NOT.NOPLOT)THEN
	    IF(SAMPLE.EQ.X1)THEN
	       CALL G3MVTO(X,Y)		!invisible move
	    ELSE
	       CALL G3LNTO(X,Y)		!move to
	    ENDIF
	  ENDIF
300	CONTINUE
        IF(.NOT.NOPLOT)CALL EOPIC		! ensure last line is drawn
	GOTO 500
320	XPLOT = -1
	PREVY = YSCALE
	ORIENT= ATAN2(DIFFY,DIFFX)
	XSCALE = Y_GRID(1)/SIN(ORIENT)
	IF(Y1.GT.Y2)THEN
	  STEP=-1
	ELSE
	  STEP=1
	ENDIF
	DO 400 LINE=Y1,Y2,STEP
	  XPLOT=XPLOT+1
	  IF(LINE.EQ.Y1)THEN
	    XPOS=X1
	    GOTO 350
	  ENDIF
	  IF(LINE.EQ.Y2)THEN
	    XPOS=X2
	    GOTO 350
	  ENDIF
	  XIN=(X1+(X2-X1)*(LINE-Y1)/(Y2-Y1))
	  XPOS=NINT(XIN)
350	  RETVAL=DTI_READ_WORD_DATA(1,THISZ,XPOS,LINE)
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
 	    GOTO 999
	  ENDIF
	  IF(THISZ.LE.-32767)THEN		!null height	     
	    Y=PREVY				!leave Y unchanged
	    CALL GSPLCI(0)			!draw in black
	  ELSE
	    Y=FLOAT(THISZ)*YSCALE
	    CALL GSPLCI(ICOL(THISZ))
	  ENDIF
	  X=FLOAT(XPLOT)*XSCALE		!actual plot positions
	  PREVY=Y
	  VWMINX=MIN(VWMINX,X)		!update plot limits
	  VWMAXX=MAX(VWMAXX,X)
	  VWMINY=MIN(VWMINY,Y)
	  VWMAXY=MAX(VWMAXY,Y)
	  IF(.NOT.NOPLOT)THEN
	    IF(LINE.EQ.Y1)THEN
	       CALL G3MVTO(X,Y)		!invisible move
	    ELSE
	       CALL G3LNTO(X,Y)		!move to
	    ENDIF
	  ENDIF
400	CONTINUE
500	IF (.NOT.NOPLOT)GOTO 999
	NOPLOT=.FALSE.
	IF (PRIMARY.OR.SECONDARY)THEN
	   CALL PLTPOS(.TRUE.,.FALSE.)	! now know min and max
	   CALL GSSGT		        !set segment transf
	   IF (PRIMARY)THEN
              CALL SHOTRN(1)
	      VIEW_SHOWN(1,QUAD) = .TRUE.
	   ENDIF
	   IF (SECONDARY)THEN
              CALL SHOTRN(2)
	      VIEW_SHOWN(2,QUAD) = .TRUE.
	   ENDIF
	ENDIF
	GOTO 50
999	IF (.NOT.NOPLOT) CALL EOPIC
	RETURN
	END

	SUBROUTINE SET_COLOUR
	IMPLICIT NONE
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
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
	IF(COLOUR_INDEX.EQ.PREV_INDEX)GOTO 999		!return
	IF(PRIMARY.OR.SECONDARY)THEN
	  CALL GSPLCI(COLOUR_INDEX)
	  IF((COLOUR_INDEX.EQ.2).AND.BATH)THEN
	     CALL GSPLCI(15)
	  ENDIF
	ENDIF
	IF(PLOT_IFF.AND.ACTIVE_IFF)THEN
	NULL_FEATURE=.FALSE.
	  IF(COLOUR_INDEX.EQ.0)THEN
	    CALL FLUSH(.TRUE.)		!terminate current IFF feature
	    NULL_FEATURE=.TRUE. 
	    GOTO 900
	  ENDIF
	  IF(COLOUR_IFF)THEN
	    CALL FLUSH(.TRUE.)
	    IF (COLOUR_INDEX.EQ.2) THEN
	       IF (BATH) THEN
		  CURFC = LAND_FC
	       ELSE
                  CURFC = SEA_FC
	       ENDIF
	    ELSEIF (COLOUR_INDEX.GT.2) THEN
	       CURFC = COLOUR_INDEX
	    ELSE			! colour_index = 1
	       CURFC = NULL_FC
	    ENDIF
	    GOTO 900
	  ENDIF
	  IF(COLOUR_INDEX.EQ.1)THEN
	    CALL FLUSH(.TRUE.)
	    CURFC=NULL_FC
	  ENDIF
	  IF(COLOUR_INDEX.EQ.2)THEN
	    CALL FLUSH(.TRUE.)
	    CURFC=SEA_FC
	    IF(BATH)CURFC=LAND_FC
	  ENDIF
	  IF(COLOUR_INDEX.GT.2)THEN
	    CALL FLUSH(.TRUE.)
	    CURFC=LAND_FC
	    IF(BATH)CURFC=SEA_FC
	  ENDIF
	ENDIF
900	PREV_INDEX = COLOUR_INDEX
999	RETURN
	END

	SUBROUTINE DRAW_FISHNET
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
	REAL		XSCALE		! viewing
	REAL		YSCALE		! scaling
	REAL		ZSCALE		! factors
	REAL		DOV		! positions of view
	REAL		DOVSC		! scaled ditto
	REAL		DEFZSC		! default height exaggeration
	REAL		DEFHOV		! 'default' height of view
	REAL		HOV		! height of view * exag'n.
	REAL*8		DEFPHI,DEFTHT	! default angles of view
	REAL*8		PHI, THETA	! angles
	REAL*8		SPHI, STHETA	! sines
	REAL*8		CPHI, CTHETA	! cosines
	REAL*8		A1, A2		! coefficients for perspective
	REAL*8		A11, A13	! coefficients for
	REAL*8		A21, A22, A23	! isometric views
	REAL		DIST, Z0	! projn values for perspective
	REAL		VWMINX, VWMINY	! range of
	REAL		VWMAXX, VWMAXY	! plotted view
	INTEGER*4	DIRECT		! direction of view
	INTEGER*4	INDINC		! index increment
	LOGICAL*1	PRSPVW		! view is true perspective
	COMMON /DTMBUF/ DOV,DOVSC,DEFPHI,DEFTHT,DEFZSC,DEFHOV,DIRECT,PRSPVW,
     &			PHI,THETA,SPHI,STHETA,CPHI,CTHETA,
     &			A1,A2,A11,A13,A21,A22,A23,DIST,Z0,
     &                	VWMINX,VWMINY,VWMAXX,VWMAXY,
     &		      	INDINC,HOV,XSCALE,YSCALE,ZSCALE
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
	INTEGER*4	LINE		!scan line counter
	INTEGER*4	STEP		!loop increment
	LOGICAL		HADCTRLC
	GOTO (50,150,250,350)DIRECT
50	STEP=-Y_SAMPLE
        DO 100 LINE=DTI_WINDOW_NEY(1),DTI_WINDOW_SWY(1),STEP
	   IF (HADCTRLC()) GOTO 999
	   STALIN=.TRUE.
	   PREV_INDEX=-1
	   CALL ENCODE_IFF(
     &          DTI_WINDOW_SWX(1),
     &          LINE,
     &          DTI_WINDOW_NEX(1),
     &          LINE,
     &          -1,
     &          2)
100	CONTINUE
	GOTO 999
150	STEP=X_SAMPLE
        DO 200 LINE=DTI_WINDOW_SWX(1),DTI_WINDOW_NEX(1),STEP
	   IF (HADCTRLC()) GOTO 999
	   STALIN=.TRUE.
	   PREV_INDEX=-1
	   CALL ENCODE_IFF(
     &          LINE,
     &          DTI_WINDOW_SWY(1),
     &          LINE,
     &          DTI_WINDOW_NEY(1),
     &          -1,
     &          1)
200	CONTINUE
	GOTO 999
250	STEP=Y_SAMPLE
        DO 300 LINE=DTI_WINDOW_SWY(1),DTI_WINDOW_NEY(1),STEP
	   IF (HADCTRLC()) GOTO 999
	   STALIN=.TRUE.
	   PREV_INDEX=-1
	   CALL ENCODE_IFF(
     &          DTI_WINDOW_NEX(1),
     &          LINE,
     &          DTI_WINDOW_SWX(1),
     &          LINE,
     &          -1,
     &          2)
300	CONTINUE
	GOTO 999
350	STEP=-X_SAMPLE
        DO 400 LINE=DTI_WINDOW_NEX(1),DTI_WINDOW_SWX(1),STEP
	   IF (HADCTRLC()) GOTO 999
	   STALIN=.TRUE.
	   PREV_INDEX=-1
	   CALL ENCODE_IFF(
     &          LINE,
     &          DTI_WINDOW_NEY(1),
     &          LINE,
     &          DTI_WINDOW_SWY(1),
     &          -1,
     &          1)
400	CONTINUE
999	RETURN
	END
	SUBROUTINE PLOT_SYMBOL(FC,XPOINT,YPOINT,IFF_COORDS,
     &		CLEAR_PLOT,SYM_NUM)
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
	REAL		XSCALE		! viewing
	REAL		YSCALE		! scaling
	REAL		ZSCALE		! factors
	REAL		DOV		! positions of view
	REAL		DOVSC		! scaled ditto
	REAL		DEFZSC		! default height exaggeration
	REAL		DEFHOV		! 'default' height of view
	REAL		HOV		! height of view * exag'n.
	REAL*8		DEFPHI,DEFTHT	! default angles of view
	REAL*8		PHI, THETA	! angles
	REAL*8		SPHI, STHETA	! sines
	REAL*8		CPHI, CTHETA	! cosines
	REAL*8		A1, A2		! coefficients for perspective
	REAL*8		A11, A13	! coefficients for
	REAL*8		A21, A22, A23	! isometric views
	REAL		DIST, Z0	! projn values for perspective
	REAL		VWMINX, VWMINY	! range of
	REAL		VWMAXX, VWMAXY	! plotted view
	INTEGER*4	DIRECT		! direction of view
	INTEGER*4	INDINC		! index increment
	LOGICAL*1	PRSPVW		! view is true perspective
	COMMON /DTMBUF/ DOV,DOVSC,DEFPHI,DEFTHT,DEFZSC,DEFHOV,DIRECT,PRSPVW,
     &			PHI,THETA,SPHI,STHETA,CPHI,CTHETA,
     &			A1,A2,A11,A13,A21,A22,A23,DIST,Z0,
     &                	VWMINX,VWMINY,VWMAXX,VWMAXY,
     &		      	INDINC,HOV,XSCALE,YSCALE,ZSCALE
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
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
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
	REAL		ABS_OBS_X	! absolute x coord of observer in metres
	REAL		ABS_OBS_Y	! absolute y coord of observer in metres
	REAL		ABS_OBS_Z	! absolute z coord of observer in metres
	REAL		ABS_X		! absolute x coord of DTM node in metres
	REAL		ABS_Y		! absolute y coord of DTM node in metres
	REAL		ABS_Z		! absolute z coord of DTM node in metres
	REAL		ABS_X_GRID	! x grid matrix interval in metres
	REAL		ABS_Z_GRID	! y grid matrix interval in metres
	INTEGER		FOG_COLOUR	! colour of the fog
	REAL		FOG_VISIBILITY	! visibility distance
	LOGICAL		HAD_FOG		! fog enabled
	LOGICAL		IN_FOG		! DTM node in fog
	COMMON/FOG/ 
     &		ABS_OBS_X,
     &		ABS_OBS_Y,
     &		ABS_OBS_Z,
     &		ABS_X,
     &		ABS_Y,
     &		ABS_Z,
     &		ABS_X_GRID,
     &		ABS_Z_GRID,
     &		FOG_COLOUR,
     &		FOG_VISIBILITY,
     &		HAD_FOG,
     &		IN_FOG
	INTEGER*4	FC		!feature code
	REAL		XPOINT		!X location in IFF units or table units
	REAL		YPOINT		!Y location in IFF units or table units
	LOGICAL		IFF_COORDS	!input is IFF coordinates
	LOGICAL		CLEAR_PLOT	!undraw plotted symbol
	INTEGER*4	SYM_NUM		!symbol number
	REAL		X,Y,Z		!untransformed coords
	REAL		XX,YY		!plot (transfromed) coords
	REAL		SYMBOL_SCALE	!symbol scale
	INTEGER*4	RETVAL		!DTILIB function return
	INTEGER*4	COL		!colour index of symbol
	INTEGER*4	X_DTI		!DTM
	INTEGER*4	Y_DTI		!coordinate
	BYTE		CELL		!visibility status
	INTEGER*2	ISEQ		!internal seq number
	INTEGER*2	ISTAT(4)	!feature status
	INTEGER*2	IENDS		!pen status
	REAL		RANGEX
	REAL		RANGEY
	CHARACTER*6	BELL
	PARAMETER	(BELL	= CHAR(7)//CHAR(7)//' ')
	INTEGER*4	DTI_READ_WORD_DATA
	INTEGER*4	DTI_READ_BYTE_DATA
	LOGICAL		SRIPLT		!get symbol coordinates
	IF (.NOT. HADSF) THEN
	  IF(PRIMARY)THEN
	    SYMSF = MAX(X_EXTENT(1)/SCRNDX(1),Y_EXTENT(1)/SCRNDX(1))
	  ENDIF
	  IF(SECONDARY)THEN
	    SYMSF = MAX(X_EXTENT(1)/SCRNDX(2),Y_EXTENT(1)/SCRNDX(2))
	  ENDIF
	ENDIF
	IF(IFF_COORDS) THEN		! in IFF units
	   SYMX=(DTI_WINDOW_SWX(1)-1) 
     &     + NINT( (XPOINT-WIND(1,1)) *IFF_DTI(1,1) )
	   SYMY=(DTI_WINDOW_SWY(1)-1)
     &     + NINT( (YPOINT-WIND(1,2)) *IFF_DTI(1,2) )
	   SYMX=MAX ( DTI_WINDOW_SWX(1), MIN(DTI_WINDOW_NEX(1),SYMX) )
	   SYMY=MAX ( DTI_WINDOW_SWY(1), MIN(DTI_WINDOW_NEY(1),SYMY) )
	ELSE
	   SYMX = NINT(XPOINT) 	! convert real matrix x values to integer
	   SYMY = NINT(YPOINT) 	! convert real matrix x values to integer
	   IF(DEBUG) CALL WRITEF('Matrix x coord: %I0 y coord %I0',
     &	   SYMX,SYMY)
	   IF(SYMX.LT.DTI_WINDOW_SWX(1).OR.SYMX.GT.DTI_WINDOW_NEX(1)
     &	   .OR.SYMY.LT.DTI_WINDOW_SWY(1).OR.SYMY.GT.DTI_WINDOW_NEY(1)
     &     .AND. (.NOT. CLEAR_PLOT))
     &	   THEN
	      CALL WRITEF('%S Position outside of '//
     &	      'active DTI window',BELL)
	      IF(DEBUG) CALL WRITEF('Window SWX : %I10  SWY : %I10',
     &	      DTI_WINDOW_SWX,DTI_WINDOW_SWY)
	      IF(DEBUG) CALL WRITEF('       NEX : %I10  NEY : %I10',
     &	      DTI_WINDOW_NEX,DTI_WINDOW_NEY)
	      SYMBOL_LDATA(8,SYM_NUM) = .FALSE.
	      GOTO 999
	   ENDIF 	
	   SYMBOL_LDATA(8,SYM_NUM) = .TRUE.
	ENDIF
	X_DTI=SYMX-DTMOFX
	Y_DTI=SYMY-DTMOFY
	IF(X_DTI.LT.1.OR.X_DTI.GT.X_EXTENT(2).OR.
     &     Y_DTI.LT.1.OR.Y_DTI.GT.Y_EXTENT(2))THEN
	   CELL=0
	ELSE
	   RETVAL=DTI_READ_BYTE_DATA(2,CELL,X_DTI,Y_DTI)
	   IF(.NOT.RETVAL)THEN
	     CALL LSL_PUTMSG(RETVAL)
	     GOTO 999
	   ENDIF
	ENDIF
	IN_FOG = .FALSE.
	IF(CELL.EQ.0)THEN
	  IF(DEBUG)CALL WRITEF('Point not visible')
	  IF(SYM_NUM.NE.-1) SYMBOL_LDATA(7,SYM_NUM) = .FALSE.
	  GOTO 999
	ELSEIF(CELL.EQ.2)THEN
	  IF(SYM_NUM.NE.-1) SYMBOL_LDATA(7,SYM_NUM) = .FALSE.
	  IN_FOG = .TRUE.
	ELSE
	  IF(SYM_NUM.NE.-1) SYMBOL_LDATA(7,SYM_NUM) = .TRUE.
	ENDIF
	RETVAL=DTI_READ_WORD_DATA(1,SYMHGT,SYMX,SYMY)
	IF(.NOT.RETVAL)THEN
	  CALL LSL_PUTMSG(RETVAL)
	  GOTO 999
	ENDIF
	IF(DIRECT.EQ.1)THEN			!west
	  Z = FLOAT((SYMX-1)-DTMOFX)  * ZSCALE
	  X = FLOAT(SYMY-DTMOFY)  * XSCALE
	ENDIF
	IF(DIRECT.EQ.3)THEN			!east (reverse of west)
	  Z = FLOAT(NLINES-(SYMX-DTMOFX))  * ZSCALE
	  X = FLOAT((NPTS+1)-(SYMY-DTMOFY))  * XSCALE
	ENDIF
	IF(DIRECT.EQ.2)THEN			!south
	  Z = FLOAT((SYMY-1)-DTMOFY)  * ZSCALE
	  X = FLOAT(NLINES-((SYMX-1)-DTMOFX))  * XSCALE
	ENDIF
	IF(DIRECT.EQ.4)THEN			!north
	  Z = FLOAT(NPTS-(SYMY-DTMOFY))  * ZSCALE
	  X = FLOAT(SYMX-DTMOFX)  * XSCALE
	ENDIF
	Y = FLOAT(SYMHGT) * DEFZSC		!and multiply by
	CALL CORDTF(X,Y,Z,XX,YY)
	IF (CLEAR_PLOT) THEN
	   IF (DEBUG)
     &	   CALL WRITEF('Clear plot position X: %F Y: %F',XX,YY)
	   CALL GSPLCI(0)		!set colour index to black
	ELSE
	   IF (DEBUG)
     &	   CALL WRITEF('Symbol plot position X: %F Y: %F',XX,YY)
	   IF(HAD_FOG.AND.PRSPVW) THEN
	      IF(IN_FOG) THEN
		 CALL SRICOL(0)		! force colour to black
	         COL = 0
	      ELSE
	         COL=MIN(FRTCOL,OVERLAY_COLOURS)	!use colour in FRT
	      ENDIF
	   ELSE 
	      COL=MIN(FRTCOL,OVERLAY_COLOURS)	!use colour in FRT
	   ENDIF
	   CALL GSPLCI(COL)		!set colour index
	ENDIF
	IF(PRIMARY.OR.SECONDARY)THEN
	  IF (PLOT_IFF)ACTIVE_IFF=.FALSE.
	  IF(CLEAR_PLOT) THEN
	     SYMBOL_SCALE = SYMBOL_RDATA(9,SYM_NUM)	! use old scale
	  ELSE 
	    SYMBOL_SCALE = SYMSF
	    IF(SYM_NUM.NE.-1)THEN
              SYMBOL_RDATA(9,SYM_NUM) = SYMBOL_SCALE	
	    ENDIF
	  ENDIF
	  IF (FRTSIZ .EQ. 0) FRTSIZ = 1.0
	  IF (SRIPLT(FRTSC,XX,YY,FRTSIZ*SYMBOL_SCALE,0.0)) GOTO 999
	  IF (PLOT_IFF.AND.IFF_COORDS) ACTIVE_IFF=.TRUE.
	  IF(HAD_FOG.AND.PRSPVW) THEN
	     IF(IN_FOG) THEN
		CALL SRICOL(-1)		! allow FRTCOL to control
	     ENDIF
	  ENDIF
	ENDIF
	IF(PLOT_IFF.AND.SYM_NUM.NE.-1)THEN
	  IF(INFT)CALL FLUSH
	  CALL IFFSEL(1)
	  ISEQ=0
	  CALL IFFNF(FTNUM,ISEQ)
	  FTNUM=FTNUM+1
	  ISTAT(1)=FC
	  ISTAT(2)=0
	  ISTAT(3)=0
	  ISTAT(4)=0
	  CALL IFFFS(ISTAT)
	  IENDS=0
	  VRTX(1,1)=XX
	  VRTX(2,1)=YY
	  CALL IFFST(VRTX,1,IENDS)
	  CALL IFFEF
	ENDIF
999	RETURN
	END

	SUBROUTINE PLOT_LINE (FC,NVERTS)
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
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	INTEGER*2	FC		!feature code
	INTEGER*4	NVERTS		!number of coordinate pts.
	INTEGER*4	X1_DTI		!DTM
	INTEGER*4	Y1_DTI		!coordinates
	INTEGER*4	X2_DTI		!
	INTEGER*4	Y2_DTI		!
	INTEGER*4	I		!counter
	STALIN=.TRUE.
	DO 100 I=2,NVERTS
	  X1_DTI=DTI_WINDOW_SWX(1)-1
     &    +NINT(0.5+(XPTS(I-1)-WIND(1,1))*IFF_DTI(1,1))
	  Y1_DTI=DTI_WINDOW_SWY(1)-1
     &    +NINT(0.5+(YPTS(I-1)-WIND(1,2))*IFF_DTI(1,2))
	  X2_DTI=DTI_WINDOW_SWX(1)-1
     &    +NINT(0.5+(XPTS(I)-WIND(1,1))*IFF_DTI(1,1))
	  Y2_DTI=DTI_WINDOW_SWY(1)-1
     &    +NINT(0.5+(YPTS(I)-WIND(1,2))*IFF_DTI(1,2))
	  IF(X2_DTI.EQ.X1_DTI.AND.Y2_DTI.EQ.Y1_DTI)GOTO 100
	  CALL ENCODE_IFF(X1_DTI,Y1_DTI,X2_DTI,Y2_DTI,
     &    FC,0)
100	CONTINUE
	RETURN
	END

	SUBROUTINE PLOT_AREA (FC,NVERTS)
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
	REAL		XSCALE		! viewing
	REAL		YSCALE		! scaling
	REAL		ZSCALE		! factors
	REAL		DOV		! positions of view
	REAL		DOVSC		! scaled ditto
	REAL		DEFZSC		! default height exaggeration
	REAL		DEFHOV		! 'default' height of view
	REAL		HOV		! height of view * exag'n.
	REAL*8		DEFPHI,DEFTHT	! default angles of view
	REAL*8		PHI, THETA	! angles
	REAL*8		SPHI, STHETA	! sines
	REAL*8		CPHI, CTHETA	! cosines
	REAL*8		A1, A2		! coefficients for perspective
	REAL*8		A11, A13	! coefficients for
	REAL*8		A21, A22, A23	! isometric views
	REAL		DIST, Z0	! projn values for perspective
	REAL		VWMINX, VWMINY	! range of
	REAL		VWMAXX, VWMAXY	! plotted view
	INTEGER*4	DIRECT		! direction of view
	INTEGER*4	INDINC		! index increment
	LOGICAL*1	PRSPVW		! view is true perspective
	COMMON /DTMBUF/ DOV,DOVSC,DEFPHI,DEFTHT,DEFZSC,DEFHOV,DIRECT,PRSPVW,
     &			PHI,THETA,SPHI,STHETA,CPHI,CTHETA,
     &			A1,A2,A11,A13,A21,A22,A23,DIST,Z0,
     &                	VWMINX,VWMINY,VWMAXX,VWMAXY,
     &		      	INDINC,HOV,XSCALE,YSCALE,ZSCALE
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	INTEGER*2	FC		!Feature code
	INTEGER*4	NVERTS		!number of coord pts passed
	REAL		RLINE		!scan line
	REAL		RCOL		!scan column
	REAL		RINT		!real intersection with
	INTEGER*4	XVERTS(8196)	!transformed
	INTEGER*4	YVERTS(8196)	!coordinates
	INTEGER*4	COUNT_VERTS	!number of verts defining
	INTEGER*4	INTER(512)	!x intersection pts
	INTEGER*4	NSECT		!number of intersections of
	INTEGER*4	LINE		!scan line counter
	INTEGER*4	COL		!scan column counter
	INTEGER*4	I		!loop counter
	INTEGER*4	X1,Y1,X2,Y2	!temporary coordinate values
	INTEGER*4	ITEMP		!temp value used in sort
	INTEGER*4	YMIN,YMAX	!scan line limits
	INTEGER*4	XMIN,XMAX	!scan column limits
	INTEGER*4	X_DTI(2)
	INTEGER*4	Y_DTI(2)
	INTEGER*4	WAY		!direction to encode
	LOGICAL		SORTED		!do intersections require sorting
	COUNT_VERTS=0
	YMIN       =99999
	XMIN       =99999
	YMAX       =0
	XMAX       =0
	DO 100 I=1,NVERTS
	   X1=DTI_WINDOW_SWX(1)-1
     &     +NINT(0.5+(XPTS(I)-WIND(1,1))*IFF_DTI(1,1))
	   Y1=DTI_WINDOW_SWY(1)-1
     &     +NINT(0.5+(YPTS(I)-WIND(1,2))*IFF_DTI(1,2))
	   COUNT_VERTS=COUNT_VERTS+1
	   XVERTS(COUNT_VERTS)=X1
	   YVERTS(COUNT_VERTS)=Y1
	   IF(DIRECT.EQ.1.OR.DIRECT.EQ.3)THEN
	     YMIN=MIN(YMIN,YVERTS(COUNT_VERTS))
	     YMAX=MAX(YMAX,YVERTS(COUNT_VERTS))	   
	   ELSE
	     XMIN=MIN(XMIN,XVERTS(COUNT_VERTS))
	     XMAX=MAX(XMAX,XVERTS(COUNT_VERTS))
	   ENDIF
100 	CONTINUE
	IF( (XVERTS(COUNT_VERTS).NE.XVERTS(1)).OR.
     &      (YVERTS(COUNT_VERTS).NE.YVERTS(1)) )THEN
	  COUNT_VERTS=COUNT_VERTS+1
	  XVERTS(COUNT_VERTS)=XVERTS(1)
	  YVERTS(COUNT_VERTS)=YVERTS(1)
	ENDIF
	IF(DIRECT.EQ.2.OR.DIRECT.EQ.4)GOTO 220
	WAY=2
        DO 200 LINE=YMIN,YMAX	
	   NSECT=0
	   RLINE=FLOAT(LINE)+0.001
	   DO 150 I=2,COUNT_VERTS
	      Y1=YVERTS(I-1)
	      Y2=YVERTS(I)
	      IF(Y1.EQ.Y2)GOTO 150
	      IF(RLINE.LT.Y1.AND.RLINE.LT.Y2)GOTO 150
	      IF(RLINE.GT.Y1.AND.RLINE.GT.Y2)GOTO 150
	      NSECT=NSECT+1
	      X1=XVERTS(I-1)
	      X2=XVERTS(I)
	      RINT=(X1+(X2-X1)*(RLINE-Y1)/(Y2-Y1))
	      INTER(NSECT)=NINT(RINT)
150	   CONTINUE
	   IF(NSECT.LE.1)GOTO 200
155	 CONTINUE
	   SORTED=.TRUE.
	   DO 160 I=2,NSECT
	      IF(INTER(I-1).LE.INTER(I))GOTO 160
	      ITEMP	=INTER(I-1)
	      INTER(I-1)=INTER(I)
	      INTER(I)  =ITEMP
	      SORTED=.FALSE.
160	   CONTINUE
	   IF(.NOT.SORTED)GOTO 155
	   DO 180 I=2,NSECT,2
	      STALIN=.TRUE.
	      CALL ENCODE_IFF(INTER(I-1),LINE,INTER(I),LINE,FC,WAY)
180	   CONTINUE
200	CONTINUE
	GOTO 490
220     DO 400 COL=XMIN,XMAX	
	   WAY=1
	   NSECT=0
	   RCOL=FLOAT(COL)+0.001
	   DO 250 I=2,COUNT_VERTS
	      X1=XVERTS(I-1)
	      X2=XVERTS(I)
	      IF(X1.EQ.X2)GOTO 250
	      IF(RCOL.LT.X1.AND.RCOL.LT.X2)GOTO 250
	      IF(RCOL.GT.X1.AND.RCOL.GT.X2)GOTO 250
	      NSECT=NSECT+1
	      Y1=YVERTS(I-1)
	      Y2=YVERTS(I)
	      RINT=(Y1+(Y2-Y1)*(RCOL-X1)/(X2-X1))
	      INTER(NSECT)=NINT(RINT)
250	   CONTINUE
	   IF(NSECT.LE.1)GOTO 400
255	 CONTINUE
	   SORTED=.TRUE.
	   DO 260 I=2,NSECT
	      IF(INTER(I-1).LE.INTER(I))GOTO 260
	      ITEMP	=INTER(I-1)
	      INTER(I-1)=INTER(I)
	      INTER(I)  =ITEMP
	      SORTED=.FALSE.
260	   CONTINUE
	   IF(.NOT.SORTED)GOTO 255
	   DO 300 I=2,NSECT,2
	      STALIN=.TRUE.
	      CALL ENCODE_IFF(COL,INTER(I-1),COL,INTER(I),FC,WAY)
300	   CONTINUE
400	CONTINUE
490	STALIN=.TRUE.
	DO 500 I=2,COUNT_VERTS
	   X_DTI(1)=XVERTS(I-1)
	   Y_DTI(1)=YVERTS(I-1)
	   X_DTI(2)=XVERTS(I)
	   Y_DTI(2)=YVERTS(I)
	   CALL ENCODE_IFF
     &	        (X_DTI(1),Y_DTI(1),X_DTI(2),Y_DTI(2),FC,WAY)
500	CONTINUE
900	RETURN
	END

	SUBROUTINE SRIGPL(NCOORD,XCOORD,YCOORD)
	IMPLICIT NONE
	INTEGER		NCOORD		! number of coords
	REAL		XCOORD(NCOORD)	! coordinate buffer
	REAL		YCOORD(NCOORD)	! ditto
	INTEGER*4	I		! loop counter
	DO 200 I=1,NCOORD
	   IF(I.EQ.1)THEN
	     CALL G3MVTO(XCOORD(I),YCOORD(I))
	   ELSE
	     CALL G3LNTO(XCOORD(I),YCOORD(I))
	   ENDIF
200	CONTINUE
	RETURN
	END

	SUBROUTINE SRIGFA(NCOORD,XCOORD,YCOORD)
	IMPLICIT NONE
	INTEGER*4	NCOORD		! number of coords
	REAL		XCOORD(NCOORD)	! coordinate buffer
	REAL		YCOORD(NCOORD)	! ditto
	INTEGER*4	I		! loop counter
	DO 200 I=1,NCOORD
	   IF (I.EQ.1) THEN
	     CALL G3MVTO(XCOORD(I),YCOORD(I))
	   ELSE
	     CALL G3AREA(XCOORD(I),YCOORD(I),I,NCOORD)
	   ENDIF
200	CONTINUE
	RETURN
	END
