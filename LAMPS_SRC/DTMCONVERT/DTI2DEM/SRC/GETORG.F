	LOGICAL FUNCTION GETORG
C
CDEC$	IDENT	'25OC89'
C
C 	Copyright 			Laser-Scan Ltd., Cambridge, England
C
C 	Created			 			RWR   	24-Jan-1989
C
C	Modified					APB	19-Oct-1989
C	
C		Updated to use LSLIB, DTILIB and standard messages
C
C Description:
C 
C	Checks geometry of DTI, and gets its origin (in UTM coordinates)
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE		'LSL$CMNDTI:DTIPAR.PAR'
	INCLUDE		'LSL$DTI2DEM:DTI2DEMMSG.PAR'
	INCLUDE		'($RMSDEF)'
C
C Common blocks
C
    	INCLUDE		'LSL$DTI2DEM:DEMA.CMN'
	INCLUDE 	'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE		'LSL$CMNDTI:DTIHDR.CMN'		! DTI header 
C
C Functions
C
	INTEGER		TTRSTR
	INTEGER		RDDBLE
C
C Local variables
C
	INTEGER		DTITYP		! type of DTI file
	INTEGER		NUMCH		
	LOGICAL		STATUS
	INTEGER		SPACING
C
C-------------------------------------------------------------------------------
C
	GETORG = .FALSE.
C
C Check for correct spacing
C
	IF (.NOT.PLNMET) THEN
	   X_GRID(INLUN) = X_GRID(INLUN)*F2M
	   Y_GRID(INLUN) = Y_GRID(INLUN)*F2M
	ENDIF
	IF (X_GRID(INLUN).NE.DEMDELX.OR.Y_GRID(INLUN).NE.DEMDELY) THEN
	   CALL LSL_PUTMSG( DTI2DEM__INCGRDSPC,
     &                      X_GRID(INLUN),Y_GRID(INLUN) )
	   CALL LSL_ADDMSG( DTI2DEM__DEMGRD,DEMDELX,DEMDELY )
	   GOTO 999
	ENDIF
C
C Get origin of this DTI
C
	CALL WRITEF('Define origin of the DTI (in UTM coordinates) '//
     &	            '(default: %F0.3 %F0.3)',
     &               X_OFFSET(INLUN),Y_OFFSET(INLUN) )

   10	STATUS=TTRSTR(,NUMCH,'Eastings Northings : ',GETORG)
	IF (.NOT.STATUS) THEN			!  error
	   IF (GETORG.NE.RMS$_EOF) THEN
	      CALL LSL_PUTMSG( DTI2DEM__BADORG )
	      CALL LSL_ADDMSG(GETORG)
	   ENDIF
	   GOTO 999
	ELSEIF ( STATUS .AND. NUMCH.EQ.0 ) THEN
	   ORIGIN(1) = X_OFFSET(INLUN)
	   ORIGIN(2) = Y_OFFSET(INLUN)
	   GOTO 30	   
	ENDIF
C
C Read real number from TXTBUF
C
	CALL BSLN
	IF (RDDBLE(ORIGIN(1))) THEN
	   CALL LSL_PUTMSG( DTI2DEM__ERRDNUM )
	   GOTO 10
	ENDIF	

	SPACING = ORIGIN(1)/DEMDELX
	IF (SPACING*DEMDELX.NE.ORIGIN(1)) THEN
	   CALL LSL_PUTMSG( DTI2DEM__NOTGRID,ORIGIN(1) )
	   GOTO 10
	ENDIF
	IF (.NOT.RDDBLE(ORIGIN(2))) GOTO 25 ! check for both on one line
C
   20	STATUS=TTRSTR(,NUMCH,'Northings : ',GETORG)
	IF (NUMCH.EQ.0) GOTO 20			! blank line
	IF (.NOT.STATUS) THEN			!  error
	   IF (GETORG.NE.RMS$_EOF) THEN
	      CALL LSL_PUTMSG( DTI2DEM__BADORG )
	      CALL LSL_ADDMSG(GETORG)
	   ENDIF
	   GOTO 999
	ENDIF
C
	CALL BSLN
	IF (RDDBLE(ORIGIN(2))) THEN
	   CALL LSL_PUTMSG( DTI2DEM__ERRDNUM )
	   GOTO 20
	ENDIF	
C
   25	CONTINUE
	SPACING = ORIGIN(2)/DEMDELX
	IF (SPACING*DEMDELX.NE.ORIGIN(2)) THEN
	   CALL LSL_PUTMSG( DTI2DEM__NOTGRID,ORIGIN(2) )
	   GOTO 20
	ENDIF
C
C Work out extent of DTI
C
30	CONTINUE
	NCOL = X_EXTENT(INLUN)
	NROW = Y_EXTENT(INLUN)
	DTIUR(1)=ORIGIN(1)+(NCOL-1)*X_GRID(INLUN)
	DTIUR(2)=ORIGIN(2)+(NROW-1)*Y_GRID(INLUN)
C
	GETORG=.TRUE.
C
  999	CONTINUE
	RETURN
	END
