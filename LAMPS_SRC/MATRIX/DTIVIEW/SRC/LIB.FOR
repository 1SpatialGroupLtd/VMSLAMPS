	SUBROUTINE G3FT(X, Y, XX, YY)
	IMPLICIT NONE
	INTEGER*4 LPOSE,LPOSR,LPOSW,LPOSH,LPOSM,LPOSF
	INTEGER*4 IERCD,IERAD,IERNM
	INTEGER*2 IFOREL
	LOGICAL*2 WATEOF
	INTEGER*4 IRVLEV,ORVLEV
	COMMON /IFFHAN/ LPOSE,LPOSR,LPOSW,LPOSH,LPOSM,LPOSF,
     +   IERCD,IERAD,IERNM,WATEOF,IFOREL,IRVLEV,ORVLEV
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
	INTEGER*4	X, Y		! the vector
	REAL		XX, YY		! or, again, the vector
	CHARACTER*(*)	STRING		! string for GTX
	INTEGER		FILCOL		! fill-area colour index
	REAL		UNIT		! NDC:WC units ratio
	REAL		SWX,SWY
	REAL		NEX,NEY
	REAL		RX, RY		! the same
	REAL		WX,WY		! world coords
	REAL		X1,Y1,X2,Y2	! old and new origin coords
	REAL		DX,DY		! shift in world origin
	REAL		VSDX		! VSLIB X range
	REAL		XMIN,XMAX	! world X range
	REAL		YMIN,YMAX	! world Y range
	REAL		PX(4),PY(4)	! polyline points
	REAL		AX(1000),AY(1000) ! area points
	REAL		F		! odd working real
	REAL		RDUMMY		! dummy real
	INTEGER*2	IELEN
	INTEGER		ID		! workstation ID No.
	INTEGER		IDUMMY		! dummy integer argument
	INTEGER		WKID
	INTEGER		I,N
	ENTRY G3AREA(XX, YY, I, N)
	RX = XX
	RY = YY
	IF (PRIMARY.OR.SECONDARY) THEN
	  IF (I.EQ.2) THEN			! fill in first point
	    AX(1) = XCUR			! at second
	    AY(1) = YCUR
	    IF (TRANSF) THEN
	      AX(1) = WMAT(1)*AX(1)+WMAT(5)
	      AY(1) = WMAT(4)*AY(1)+WMAT(6)
	    ENDIF
	  ENDIF
	  AX(I) = RX
	  AY(I) = RY
	  IF (TRANSF) THEN
	    AX(I) = WMAT(1)*AX(I)+WMAT(5)
	    AY(I) = WMAT(4)*AY(I)+WMAT(6)
	  ENDIF
	  IF (DEBUG) CALL WRITEF('Drawing vector to: %F %F',AX(I),AY(I))
	  IF (I.EQ.N) CALL GFA(N,AX,AY)
	ENDIF
	IF (PLOT_IFF.AND.ACTIVE_IFF) THEN
	  IF (NULL_FEATURE) THEN
	    LASTX = RX
	    LASTY = RY
	    RETURN
	  ENDIF
          IF (.NOT.INFT) CALL IFNWFT(LASTX, LASTY)
	  IF (RX.EQ.LASTX .AND. RY.EQ.LASTY) RETURN
          LASTX = RX
	  LASTY = RY
	  CALL IFADPT(LASTX, LASTY)
	ENDIF
	RETURN
	ENTRY G3LNTO(XX, YY)
	RX = XX
	RY = YY
	IF (PRIMARY.OR.SECONDARY) THEN
	  PX(1) = XCUR
	  PX(2) = RX
	  PY(1) = YCUR
	  PY(2) = RY
	  XCUR = PX(2)
	  YCUR = PY(2)
	  IF (TRANSF) THEN
	    PX(1) = WMAT(1)*PX(1)+WMAT(5)
	    PX(2) = WMAT(1)*PX(2)+WMAT(5)
	    PY(1) = WMAT(4)*PY(1)+WMAT(6)
	    PY(2) = WMAT(4)*PY(2)+WMAT(6)
	  END IF
	  IF (DEBUG) CALL WRITEF('Drawing vector from: %F %F to %F %F',
     &						PX(1),PY(1),PX(2),PY(2))
	  CALL GPL(2,PX,PY)
	END IF
	IF (PLOT_IFF.AND.ACTIVE_IFF) THEN
	  IF (NULL_FEATURE) THEN
	    LASTX = RX
	    LASTY = RY
	    RETURN
	  ENDIF
          IF (.NOT.INFT) CALL IFNWFT(LASTX, LASTY)
	  IF (RX.EQ.LASTX .AND. RY.EQ.LASTY) RETURN
          LASTX = RX
	  LASTY = RY
	  CALL IFADPT(LASTX, LASTY)
	ENDIF
	RETURN
	ENTRY G3MVTO(XX, YY)
	IF (PRIMARY.OR.SECONDARY) THEN	  
          XCUR = XX
	  YCUR = YY
	  IF (DEBUG) CALL WRITEF('Invisible move to: %F %F',XX,YY)
	END IF
	IF (PLOT_IFF.AND.ACTIVE_IFF) THEN
          CALL FLUSH(.TRUE.)
	  LASTX = XX
	  LASTY = YY
	ENDIF
	RETURN
	ENTRY EOPIC
	IF (PRIMARY) CALL GUWK(1,GSUPP)
	IF (SECONDARY) CALL GUWK(2,GSUPP)
	IF (PLOT_IFF.AND.ACTIVE_IFF) THEN
	   CALL FLUSH(.TRUE.)
	   CALL IFFSEL(1)
	   CALL IFFUNO(LPOSNO)
	   CALL IFFEO
	ENDIF
	RETURN
	ENTRY ENDIFF
	IF (PLOT_IFF) THEN
	  CALL IFFTXT		! write descriptive text feature
	  CALL IFFEM
	  CALL IFFEJ
	  CALL IFFRWD
	  CALL IFFNXC('RA',IELEN)
	  RANGE(1)=VWMINX
	  RANGE(2)=VWMAXX
	  RANGE(3)=VWMINY
	  RANGE(4)=VWMAXY
	  CALL EIHWR(RANGE,4,1)
	  CALL IFFCLO(1)
	  PLOT_IFF=.FALSE.
	  ACTIVE_IFF=.FALSE.
	ENDIF
	RETURN
	ENTRY G3ORIGIN(XX,YY)
	MAT(5) = XX
	MAT(6) = YY
	RETURN
	ENTRY G3UNIT(UNIT)
	MAT(1) = UNIT
	MAT(4) = UNIT
	RETURN
	ENTRY G3FILL(SWX,SWY,NEX,NEY,FILCOL)
	IF (PRIMARY.OR.SECONDARY) THEN
	   PX(1) = SWX
	   PX(2) = NEX
	   PX(3) = NEX
	   PX(4) = SWX
	   PY(1) = SWY
	   PY(2) = SWY
	   PY(3) = NEY
	   PY(4) = NEY
	   IF (TRANSF) THEN
	     PX(1) = WMAT(1)*PX(1)+WMAT(5)
	     PX(2) = WMAT(1)*PX(2)+WMAT(5)
	     PX(3) = WMAT(1)*PX(3)+WMAT(5)
	     PX(4) = WMAT(1)*PX(4)+WMAT(5)
	     PY(1) = WMAT(4)*PY(1)+WMAT(6)
	     PY(2) = WMAT(4)*PY(2)+WMAT(6)
	     PY(3) = WMAT(4)*PY(3)+WMAT(6)
	     PY(4) = WMAT(4)*PY(4)+WMAT(6)
	   ENDIF
	   CALL GSFAIS(1)		! set fill-area style to solid
	   CALL GSFACI(FILCOL)		! set fill-area colour
	   CALL GFA(4,PX,PY)		! fill-area
	   XCUR = NEX
	   YCUR = NEY
	ENDIF
	RETURN
	ENTRY G3TX(SWX,SWY,STRING)
	IF(PRIMARY.OR.SECONDARY)THEN
	  PX(1) = SWX
	  PY(1) = SWY
	  IF(TRANSF)THEN
	    PX(1) = WMAT(1)*PX(1)+WMAT(5)
	    PY(1) = WMAT(4)*PY(1)+WMAT(6)
	  ENDIF
	  CALL GTX(PX,PY,STRING)		! text
	ENDIF
80	RETURN
	END

	SUBROUTINE IFADPT(X,Y)
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
	REAL		X,Y		! point to add
	IF (VRTPT.GE.MAXVRT)CALL FLUSH(.FALSE.)	!flush buffer
	VRTPT = VRTPT+1
	TOTVRT = TOTVRT+1
	VRTX(1,VRTPT) = X
	VRTX(2,VRTPT) = Y
	RETURN
	END

	SUBROUTINE IFNWFT(FSTX, FSTY)
	IMPLICIT NONE
	REAL		FSTX, FSTY	! coords of first point
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
	INTEGER*2	ISEQ		! for feature seq no
	INTEGER*2	ISTAT(4)	! feature status
	IF (INFT) RETURN
	INFT = .TRUE.
	FTFLSH = .FALSE.
	VRTPT = 0
	TOTVRT = 0
	ISEQ = 0
	CALL IFFSEL(1)		!select IFF file
	CALL IFFNF (FTNUM, ISEQ)
	ISTAT(1)=CURFC
	ISTAT(2)=0
	ISTAT(3)=0
	ISTAT(4)=0
	CALL IFFFS(ISTAT)
	CALL IFADPT(FSTX, FSTY)
	RETURN
	END

	SUBROUTINE FLUSH(END)
	IMPLICIT NONE
	LOGICAL*1	END		! end of feature
	INTEGER*2	IENDS
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
	IF(.NOT.INFT)RETURN
	INFT = .NOT.END
	IF (VRTPT.EQ.0) GOTO 10		!nothing
	IF(END.AND.TOTVRT.LE.1)THEN
	  CALL IFFSEL(1)
	  CALL IFFDEL
	  GOTO 999
	ENDIF
	IENDS = 0			
	IF (FTFLSH) IENDS = 1
	CALL IFFSEL(1)
	CALL IFFST(VRTX, VRTPT, IENDS)
	FTFLSH = .TRUE.
	VRTPT = 0			!now mark as empty
10	IF (END) THEN			!terminate feature
	   CALL IFFSEL(1)		!by writing
	   CALL IFFEF			!EF and
	   FTNUM=FTNUM+1		!update feature counter
	   TOTVRT=0
	ENDIF
999	RETURN
	END

	SUBROUTINE IFFTXT
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
	INTEGER*4	MAX_EXPMAX	! maximum possible buffer length
	PARAMETER	(MAX_EXPMAX = 1024)
	INTEGER*4	DEF_EXPMAX	! default buffer length
	PARAMETER	(DEF_EXPMAX = 255)
	INTEGER*2	EXPLEN		! current line length
	BYTE		EXPTYP		! type of fake string
	BYTE		EXPCLA		! class of fake string
	INTEGER*4	EXPPTR		! address of buffer
	INTEGER*2	EXPMAX		! actual buffer length
	INTEGER*4	EXPCTF		! control flags for expansion
	BYTE		EXPBUF(MAX_EXPMAX+1)	! expansion buffer
	INTEGER*4	EXPDSC(2)	! fake string descriptor
	EQUIVALENCE	(EXPDSC,EXPLEN)
	COMMON/LSL_EXPC/EXPLEN,EXPTYP,EXPCLA,EXPPTR,EXPMAX,EXPCTF,EXPBUF
	INTEGER*4 LPOSE,LPOSR,LPOSW,LPOSH,LPOSM,LPOSF
	INTEGER*4 IERCD,IERAD,IERNM
	INTEGER*2 IFOREL
	LOGICAL*2 WATEOF
	INTEGER*4 IRVLEV,ORVLEV
	COMMON /IFFHAN/ LPOSE,LPOSR,LPOSW,LPOSH,LPOSM,LPOSF,
     +   IERCD,IERAD,IERNM,WATEOF,IFOREL,IRVLEV,ORVLEV
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
	INCLUDE '($JPIDEF)'
	REAL		STBUF(2)
	INTEGER*4	IERR
	INTEGER*2	ISQ
	INTEGER*2	ISTAT(4)
	INTEGER*2	USELEN
	CHARACTER*20	USER
	CHARACTER*9	SDATE
	CHARACTER*8	STIME
	CHARACTER*5	COMPAS(4)	! 4 viewing points
	INTEGER*4	LIB$GETJPI
	DATA		ISTAT/4*0/
	DATA		COMPAS/'west','south','east','north'/
	CALL DATE(SDATE)
	CALL EXPAND(' %S',SDATE)
	CALL TIME(STIME)
	CALL APPEND(' %S',STIME(1:5))
	IERR=LIB$GETJPI(JPI$_USERNAME,,,,USER,USELEN)
	CALL APPEND(' %S',USER(1:USELEN))
	CALL APPEND(' %S',DTI_NAME(1)(1:DTI_NAME_LENGTH(1)))
	IF(PRSPVW)THEN
	  CALL APPEND(' Perspective view from the %S',COMPAS(DIRECT))
	ELSE
	  CALL APPEND(' Isometric view from the %S',COMPAS(DIRECT))
	ENDIF	  
	ISQ=0
	CALL IFFSEL(1)
	LPOSNO = LPOSE
	CALL IFFNO(3,0,0)
	CALL IFFNF(FTNUM,ISQ)
	ISTAT(1)=TEXT_FC		!text feature
	CALL IFFFS(ISTAT)
	CALL IFFTH(12)
	CALL IFFRO(0.0)
	STBUF(1)=VWMINX
	STBUF(2)=VWMINY
	CALL IFFST(STBUF,1,0)
	CALL IFFTX(EXPBUF,EXPLEN)
	CALL IFFEF
	CALL IFFUNO(LPOSNO)
	CALL IFFEO
	RETURN
	END
	SUBROUTINE DISPLBTMP(NOR_MSG,NONE_MSG,BITMPSIZ,
     &					BITMAP)
	IMPLICIT NONE
	CHARACTER*(*)	NOR_MSG		! message to be output as 
					! header
	CHARACTER*(*)	NONE_MSG	! message to be output if
					! no bits set
	INTEGER*4	BITMPSIZ	! top of bitmap (in bits)
					! ie, map is 0-bitmpsiz
	INTEGER*4	BITMAP(BITMPSIZ/32+1)
					! bitmap
	LOGICAL		STARTD		! used to flag whether output
					! has started or not
	LOGICAL		INRANGE		! used to flag whether we are
					! within a range, or not
	INTEGER*4	FIRST,SECOND	! start and end of range
	INTEGER*4	TOPBITMP	! top bit of bitmap
					! ie map goes from 0-TOPBITMP
	INTEGER*4	TOPWORD		! word of bitmap that contains
					! TOPBITMP
	INTEGER*2 OUTPTR  ! end of line pointer
	INTEGER*2 OUTTYP  ! string descriptor guff
	INTEGER*4 OUTADD  ! address part of string descriptor
	INTEGER*2 OUTLIM  ! maximum size of buffer
	BYTE OUTBUF(80)
	INTEGER OUTDSC  ! alias for OUTPTR as string descriptor
	EQUIVALENCE (OUTDSC,OUTPTR)
	COMMON/BTMAPDIS/STARTD,INRANGE,FIRST,SECOND,
     &			TOPBITMP,TOPWORD,
     &			OUTPTR,OUTTYP,OUTADD,OUTLIM,OUTBUF
					! subroutine
	INTEGER*4	EXPAND
	INTEGER*4	WORD		! counter
	OUTADD=%LOC(OUTBUF)		! set up fake descriptor
	OUTLIM=80
	STARTD=.FALSE.
	INRANGE=.FALSE.
	FIRST=-1
	SECOND=-2
	TOPBITMP=BITMPSIZ
	TOPWORD=BITMPSIZ/32+1
	DO 10, WORD=1,TOPWORD
	   IF ((INRANGE.AND.BITMAP(WORD).NE.-1).OR.
     &	       (.NOT.INRANGE.AND.BITMAP(WORD).NE.0)) THEN
	      CALL INWORD(BITMAP(WORD),WORD,NOR_MSG)
	   ENDIF
   10	CONTINUE
	IF (STARTD) THEN
	   IF (INRANGE.AND.SECOND.LT.FIRST) SECOND=TOPBITMP
	   IF (FIRST.EQ.SECOND) THEN	! output number
	      OUTPTR=OUTPTR+EXPAND('%W%^L%N',OUTBUF(OUTPTR+1),FIRST)
	   ELSE				! output range
	      OUTPTR=OUTPTR+EXPAND('%W%^L%N-%N',OUTBUF(OUTPTR+1),
     &				FIRST,SECOND)
	   ENDIF
	   CALL WRITEF('%S',OUTDSC)
	ELSE
	   CALL WRITEF(NONE_MSG)		! no output
	ENDIF
	RETURN
	END

	SUBROUTINE OTPLSTRG(MSG)
	IMPLICIT NONE
	CHARACTER*(*)	MSG		! message to use for output
	LOGICAL		STARTD		! used to flag whether output
					! has started or not
	LOGICAL		INRANGE		! used to flag whether we are
					! within a range, or not
	INTEGER*4	FIRST,SECOND	! start and end of range
	INTEGER*4	TOPBITMP	! top bit of bitmap
					! ie map goes from 0-TOPBITMP
	INTEGER*4	TOPWORD		! word of bitmap that contains
					! TOPBITMP
	INTEGER*2 OUTPTR  ! end of line pointer
	INTEGER*2 OUTTYP  ! string descriptor guff
	INTEGER*4 OUTADD  ! address part of string descriptor
	INTEGER*2 OUTLIM  ! maximum size of buffer
	BYTE OUTBUF(80)
	INTEGER OUTDSC  ! alias for OUTPTR as string descriptor
	EQUIVALENCE (OUTDSC,OUTPTR)
	COMMON/BTMAPDIS/STARTD,INRANGE,FIRST,SECOND,
     &			TOPBITMP,TOPWORD,
     &			OUTPTR,OUTTYP,OUTADD,OUTLIM,OUTBUF
					! of bitmap
	INTEGER*4	EXPAND
	IF (.NOT.STARTD) THEN		! nothing output yet
	   CALL WRITEF(MSG)		! so output header
	   STARTD=.TRUE.
	   OUTPTR=0			! and zero pointer in OUTBUF
	ELSE
	   IF (FIRST.EQ.SECOND) THEN	! single integer
	      OUTPTR=OUTPTR+EXPAND('%W%^L%N,',OUTBUF(OUTPTR+1),FIRST)
	   ELSE				! range
	      OUTPTR=OUTPTR+EXPAND('%W%^L%N-%N,',OUTBUF(OUTPTR+1),
     &					FIRST,SECOND)
	   ENDIF
	ENDIF
	IF (OUTPTR.GT.68) THEN
	   CALL WRITEF('%S',OUTDSC)
	   OUTPTR=0
	ENDIF	
	RETURN
	END
