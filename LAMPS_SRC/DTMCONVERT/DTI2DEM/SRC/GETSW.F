	LOGICAL FUNCTION GETSW
C
CDEC$	IDENT	'25OC89'
C
C 	Copyright 			Laser-Scan Ltd., Cambridge, England.
C
C 	Created					 	RWR	24-Jan-1989
C
C 	Modified					APB	19-Oct-1989
C
C		Updated to use LSLLIB,DTILIB and standard messages
C
C Description:
C
C	Gets and checks SW corner of map sheet
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE		'LSL$DTI2DEM:DTI2DEMMSG.PAR'
C
C Common blocks
C
	INCLUDE		'LSL$DTI2DEM:DEMA.CMN'
	INCLUDE		'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE		'LSL$CMNLSL:TXTC.CMN'
C
C Functions
C
	LOGICAL		READLL
	INTEGER		TTRSTR
	LOGICAL		LSL_ADDSTR
C
C Local variables
C
	INTEGER		ISPHER,IDIR
	PARAMETER	(ISPHER=1)		! always CLARKE 1866
	PARAMETER	(IDIR=0)		! convert to UTM
	INTEGER		NUMCH			! Number of characters read
	INTEGER*2	NUMCHW			! Word equivalent of above
	EQUIVALENCE	(NUMCH,NUMCHW)
C
	INTEGER*4	BIGNEG
	PARAMETER	(BIGNEG=-2147483648)	! an unlikely angle
C
	INTEGER*4	STATUS
	INTEGER*4	ORGSEC(2)
	INTEGER		IZONE,OZONE
	INTEGER		TLONG			! temporary longitude
	REAL*8		FLONLAT(2)		! ORGSEC as REAL*8
C
C Data for projection transformation
C
	REAL*8		PARMI(15),PARMO(15)
	INTEGER*4	INTYP,IOTYP,INZONE,IOZONE
	INTEGER*4	INUNIT,IOUNIT,INSPH,IOSPH
	INTEGER*4	IPR,JPR,IFLG
C
	DATA PARMI,PARMO/30*0.0D0/
C
	EXTERNAL	GCTPEX			! exception handler
C						! for GCTPLIB
C-------------------------------------------------------------------------------
C
C Get SW corner of map
C
   10	ORGSEC(1)=BIGNEG
	ORGSEC(2)=BIGNEG
	CALL WRITEF('Enter lat and long of SW corner of map '//
     &	            '(eg 39 07 30N  77 22 30W)')
	STATUS=TTRSTR(,NUMCH,'Latitude   Longitude : ',GETSW)
	IF (NUMCH.EQ.0) GOTO 10				! blank line
	IF (NUMCH.LT.0) GOTO 999			!  error
	IF (READLL(ORGSEC,2)) THEN
	   CALL LSL_PUTMSG( DTI2DEM__BADLL )
	   STATUS = LSL_ADDSTR(,,NUMCHW)
	   GOTO 10
	ELSEIF (ORGSEC(1).EQ.BIGNEG.OR.ORGSEC(2).EQ.BIGNEG) THEN
	   CALL LSL_PUTMSG( DTI2DEM__MISSLL )
	   STATUS = LSL_ADDSTR(,,NUMCHW)
	   GOTO 10
	ENDIF
C
C Check that it is a 7.5 minute intersection
C
	IF (MOD(ORGSEC(1),450).NE.0.OR.MOD(ORGSEC(2),450).NE.0) THEN
	   CALL LSL_PUTMSG( DTI2DEM__BADMAPORG )
	   STATUS = LSL_ADDSTR(,,NUMCHW)
	   GOTO 10
	ENDIF
C
C Get UTM zone for this map (to avoid problems at zone edges)
C
	TLONG=ORGSEC(2)			! temporary longitude
	IF (MOD(TLONG,21600).EQ.0) THEN	! it is on a zone boundary
	   TLONG=TLONG+10		! so move into a zone
	ENDIF
	IZONE=TLONG/21600
	IF (TLONG.GE.0) THEN
	   DEMZONE=31+IZONE
	ELSE
	   DEMZONE=30+IZONE
	ENDIF
	IF (ORGSEC(1).LT.0) DEMZONE=-DEMZONE
C
C Set exception handeler for GCTPLIB
C
	CALL LIB$ESTABLISH(GCTPEX)
C
C Compute UTM coords of four corners of map
C
	INTYP=0				! input geographicals
	IOTYP=1				! output UTM
	INZONE=0			! input zone doesn't matter
	IOZONE=DEMZONE			! output zone
	INUNIT=4			! input degrees of arc
	IOUNIT=2			! output metres
	INSPH=0				! input on CLARKE 1866
	IOSPH=0				! output on CLARKE 1866
	IPR=1				! no error messages 
	JPR=1				! no projection parameters
	FLONLAT(2)=ORGSEC(1)/3600.0
	FLONLAT(1)=ORGSEC(2)/3600.0
	CALL GTP$0(FLONLAT,INTYP,INZONE,PARMI,INUNIT,INSPH,IPR,JPR,
     &	           DOMAIN(1,1),IOTYP,IOZONE,PARMO,IOUNIT,IOSPH,IFLG)
	IF (IFLG.NE.0) GOTO 20
C
C NW corner
C
	FLONLAT(2)=(ORGSEC(1)+450)/3600.0
	CALL GTP$0(FLONLAT,INTYP,INZONE,PARMI,INUNIT,INSPH,IPR,JPR,
     &	           DOMAIN(1,2),IOTYP,IOZONE,PARMO,IOUNIT,IOSPH,IFLG)
	IF (IFLG.NE.0) GOTO 20
C
C NE corner
C
	FLONLAT(1)=(ORGSEC(2)+450)/3600.0
	CALL GTP$0(FLONLAT,INTYP,INZONE,PARMI,INUNIT,INSPH,IPR,JPR,
     &	           DOMAIN(1,3),IOTYP,IOZONE,PARMO,IOUNIT,IOSPH,IFLG)
	IF (IFLG.NE.0) GOTO 20
C
C SE corner
C
	FLONLAT(2)=(ORGSEC(1))/3600.0
	CALL GTP$0(FLONLAT,INTYP,INZONE,PARMI,INUNIT,INSPH,IPR,JPR,
     &	           DOMAIN(1,4),IOTYP,IOZONE,PARMO,IOUNIT,IOSPH,IFLG)
C
C Check for error from GTP$0
C
   20	IF (IFLG.NE.0) THEN
	   CALL LSL_PUTMSG( DTI2DEM__BADCONV,IFLG )
	   GETSW=.FALSE.
	   GOTO 999
	ENDIF	   
C
C Now work out the limits
C
	MINXDEM=MIN(DOMAIN(1,1),DOMAIN(1,2),DOMAIN(1,3),DOMAIN(1,4))
	MAXXDEM=MAX(DOMAIN(1,1),DOMAIN(1,2),DOMAIN(1,3),DOMAIN(1,4))
	MINYDEM=MIN(DOMAIN(2,1),DOMAIN(2,2),DOMAIN(2,3),DOMAIN(2,4))
	MAXYDEM=MAX(DOMAIN(2,1),DOMAIN(2,2),DOMAIN(2,3),DOMAIN(2,4))
C
C Does this area lie within DTI?
C
	IF (( ORIGIN(1) - DEMDELX ).GT.DOMAIN(1,1) .OR.
     &	    ( ORIGIN(2) - DEMDELY ).GT.DOMAIN(2,1) .OR.
     &	    (  DTIUR(1) + DEMDELX ).LT.DOMAIN(1,3) .OR.
     &	    (  DTIUR(2) + DEMDELY ).LT.DOMAIN(2,3) ) THEN
C
	   CALL LSL_PUTMSG( DTI2DEM__BADAREA )
	   CALL WRITEF( 'DEM x-limits: %F13.3, %F13.3 ',
     &                   DOMAIN(1,1),DOMAIN(1,3) )
	   CALL WRITEF( 'DEM y-limits: %F13.3, %F13.3 ',
     &                   DOMAIN(2,1),DOMAIN(2,3) )
	   CALL WRITEF( 'DTI x-limits: %F13.3, %F13.3 ',ORIGIN(1),DTIUR(1) )
	   CALL WRITEF( 'DTI y-limits: %F13.3, %F13.3 ',ORIGIN(2),DTIUR(2) )
	   GETSW=.FALSE.
	   GOTO 999
	ENDIF  
C
	GETSW=.TRUE.
C
  999	CONTINUE
	RETURN
	END
