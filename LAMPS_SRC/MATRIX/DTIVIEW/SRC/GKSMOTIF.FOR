	LOGICAL FUNCTION TSTWK(DEV,WTYPE)
	IMPLICIT NONE
	INTEGER*4	DEV		!primary or secondary
	INTEGER*4	WTYPE		!workstation type
	TSTWK=.FALSE.
	IF(DEV.EQ.1)THEN
	  WTYPE=7000
	  TSTWK=.TRUE.
	ENDIF
	RETURN
	END

	SUBROUTINE GEVTM(XREF,YREF,DX,DY,THT,XMAG,YMAG)
	IMPLICIT NONE
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
	REAL		XREF,YREF	!Reference point
	REAL		DX,DY		!Shift
	REAL		THT		!Rotation
	REAL		XMAG,YMAG	!Scale factors
	REAL		WXR,WYR		!World x and y ranges
	REAL		C,S		!cos and sin values
	WXR = WXMAX-WXMIN
	WYR = WYMAX-WYMIN
	C = COS(THT)
	S = SIN(THT)
	MAT(1) =  C*XMAG
	MAT(2) =  S*XMAG*WXR/WYR
	MAT(3) = -S*YMAG*WYR/WXR
	MAT(4) =  C*YMAG
	MAT(5) = (C*XMAG*(WXMIN-XREF)-S*YMAG*(WYMIN-YREF)+XREF+DX-WXMIN)
     +	/WXR
	MAT(6) = (S*XMAG*(WXMIN-XREF)+C*YMAG*(WYMIN-YREF)+YREF+DY-WYMIN)
     +	/WYR
	RETURN
	END

	SUBROUTINE GSSGT
	IMPLICIT NONE
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
	REAL		WXR,WYR		!World x and y ranges
	WXR = WXMAX-WXMIN
	WYR = WYMAX-WYMIN
	WMAT(1) = MAT(1)
	WMAT(2) = MAT(2)*WYR/WXR
	WMAT(3) = MAT(3)*WXR/WYR
	WMAT(4) = MAT(4)
	WMAT(5) = -MAT(1)*WXMIN-MAT(3)*WYMIN*WXR/WYR+MAT(5)*WXR+WXMIN
	WMAT(6) = -MAT(2)*WXMIN*WYR/WXR-MAT(4)*WYMIN+MAT(6)*WYR+WYMIN
	TRANSF = .TRUE.	! segment transformations active from now on
	RETURN
	END

	SUBROUTINE INIT_DEVICE (WKID)
	IMPLICIT NONE
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
	INTEGER*4	WKID		! workstation identifier
	INTEGER*4	GASF(13)	! Aspect source flags
	INTEGER*4	ERRCOD
	DATA GASF /13*GINDIV/		! set flags individual
	IF(WKID.EQ.1.AND.INIT_PRIMARY)GOTO 500
	IF(WKID.EQ.2.AND.INIT_SECONDARY)GOTO 500
	CALL GOPWK(WKID,CONID(WKID),WTYPE(WKID)) !open workstation
	CALL GACWK(WKID)		!and activate it
	CALL GSASF(GASF)
	CALL GSDS(WTYPE(WKID),GASTI,GSUPPD)
	CALL GQMDS(WTYPE(WKID),ERRCOD,DCUNIT,
     &	         SCRNDX(WKID),SCRNDY(WKID),RASTSZ(WKID,1),RASTSZ(WKID,2))
	CALL GSDS(1,GASTI,GSUPPD)
	CALL INIGKS(WKID)
	IF(WTYPE(1).EQ.9900.AND.WKID.EQ.1)THEN
	  CALL GCLRWK(1)
	  CALL GSLN(TK_LINESTYLE)
	  CALL GUWK(1,GSUPP)
	ENDIF
	IF(WKID.EQ.1)INIT_PRIMARY=.TRUE.		!now initialised
	IF(WKID.EQ.2)INIT_SECONDARY=.TRUE.
500	IF(WKID.EQ.1.AND.WTYPE(1).EQ.9900)GOTO 999
	IF (BATH)THEN
	   CALL LSG_SET_LUT(WKID,'LSL$LOOKUP:UNDERSEA.DAT')
	   GOTO 999
	ENDIF
        IF (NOPLNS .EQ. 4)
     &     CALL LSG_SET_LUT(WKID,'LSL$LOOKUP:DTIVIEW4.DAT') 
	IF (NOPLNS .EQ. 5)
     &     CALL LSG_SET_LUT(WKID,'LSL$LOOKUP:DTIVIEW5.DAT')
	IF (NOPLNS .EQ. 6)
     &     CALL LSG_SET_LUT(WKID,'LSL$LOOKUP:DTIVIEW6.DAT')
	IF (NOPLNS .EQ. 7)
     &     CALL LSG_SET_LUT(WKID,'LSL$LOOKUP:DTIVIEW7.DAT')
	IF (NOPLNS .EQ. 8)
     &     CALL LSG_SET_LUT(WKID,'LSL$LOOKUP:DTIVIEW8.DAT')
999	RETURN
	END

	SUBROUTINE INIGKS(WKID)
	IMPLICIT NONE
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
	INTEGER		WKID		! workstation identifier
	REAL		PI
	PARAMETER(	PI = 3.1415926572)
	REAL		HGTD		! character device-height
	REAL		THT		! UP-vector orientation
	REAL		RDUMMY		! real dummy argument
	REAL		PX(2),PY(2)	! world coords for 2 points
	INTEGER		NSERIF(4)	! serif index from IFONT
	INTEGER		NITAL(4)	! italic index from IFONT
	INTEGER		IDUMMY		! integer dummy argument
	INTEGER		COLI		! colour index (can't use ICOL)
	INTEGER		I,IERR
	DATA NSERIF,NITAL/0,0,1,1, 0,1,0,1/
	DATA CONID/1,2/
	DATA TKCHHT/0.0025,0.003,0.005,0.006/
	DATA VSCHHT/0.0025,0.005,0.0075,0.01/
	IFONT = 1		! text font is serifed, non-italic
	IPREC = 1		! text representation precision = CHAR 
	VSCHD = 0		! SIGMA text direction = right
	VSCHHI = 1		! SIGMA character height index = 1
	TKCHHI = 1		! TEK character height index = 1
	TKCHH = 0.5		! TEK character height = 0.5 cm
	TKCHX = 1		! TEK spacing vector = (1,0)
	TKCHY = 0
	TKCHSP = 1.0		! TEK character wid:hgt ratio = 1.0
	CHUX = 0		! character UP-vector = (0,1)
	CHUY = 1
	UPLEN = 1		! UP-vector length = 1
	TXTCOL = 1		! colour 1 -whatever it may be
	XCUR = 0		! pen position at world origin
	YCUR = 0
	ITX = 10
	TRANSF = .FALSE.	! seg transformation not active
	DO 420 I = 0,4		! no quads drawn on yet
	VIEW_SHOWN(1,I) = .FALSE.
	VIEW_SHOWN(2,I) = .FALSE.
420	LEGEND_SHOWN(I) = .FALSE.
	END
	SUBROUTINE VSTKD2W(WKID,DCX,DCY,GKSWCX,GKSWCY)
	IMPLICIT NONE
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
	INTEGER		WKID		! workstation identifier
	REAL		DCX,DCY		! SIGMA or TEK DC coords
	REAL		GKSWCX,GKSWCY	! GKS world coords
	GKSWCX = DCX*(WXMAX-WXMIN)/SCRNDX(WKID)
	GKSWCY = DCY*(WYMAX-WYMIN)/SCRNDY(WKID)
	GKSWCX = GKSWCX+(WXMAX+WXMIN)/2
	GKSWCY = GKSWCY+(WYMAX+WYMIN)/2
	END

	SUBROUTINE SHOTRN(WKID)
	IMPLICIT NONE
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
	INTEGER		WKID		! workstation identifier
	CALL WRITEF
	IF(WKID.EQ.1)CALL WRITEF
     &	  ('PRIMARY - plot origin at ( %F8.6, %F8.6) and scale %F8.6',
     &	  MAT(5),MAT(6),MAT(1))
	IF(WKID.EQ.2)CALL WRITEF
     &	  ('SECONDARY - plot origin at ( %F8.6, %F8.6) and scale %F8.6',
     &	  MAT(5),MAT(6),MAT(1))
	CALL WRITEF
	RETURN
	END

	SUBROUTINE LUTSET(DEV)
	IMPLICIT NONE
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
	INTEGER		DEV
	INTEGER		GETFILNAM
	LOGICAL		RDCHS
	LOGICAL		LSG_SET_LUT	! in GKSLDLIB
	BYTE		CH
	CHARACTER*80	FILNAM		! LUT filename
	INTEGER		FILLEN
	INTEGER		OK
	IF (RDCHS(CH)) THEN
	  CALL WRITEF('%S Specifying command LUT',ERROR_BELL)
	  CALL WRITEF('Filename is missing')
	  CALL BSLN
	  GOTO 999	  
	ENDIF
	IF (CH.EQ.''''.OR.CH.EQ.'"') THEN
	   OK = GETFILNAM(
     &		FILNAM,FILLEN,'LSL$LOOKUP:DTIVIEW5.DAT',.TRUE.,CH)
	ELSE
	   CALL BSCH
	   OK = GETFILNAM(
     &		FILNAM,FILLEN,'LSL$LOOKUP:DTIVIEW5.DAT',.TRUE.)
	ENDIF
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   GOTO 999
	ENDIF
        IF(LSG_SET_LUT(DEV,FILNAM)) THEN
	   CALL WRITEF('%S Specifying command LUT',ERROR_BELL)
	   CALL WRITEF('Unable to read colour table %S',FILNAM(:FILLEN))
	ELSE
	   CALL WRITEF('LUT %S selected ',FILNAM(:FILLEN))
	ENDIF
999	RETURN
	END

	SUBROUTINE GKSDUM
	IMPLICIT NONE
	ENTRY	GGDP
	RETURN
	END
