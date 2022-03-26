	PROGRAM DTI2DEM
C
CDEC$	IDENT	'25OC89'
C
C	Copyright  		Laser-Scan Ltd., Cambridge, England.
C
C	Author 					RWR	14-Nov-1985
C
C	Modified				APB	17-Oct-1989
C	
C		New version of DTI2DEM in package DTMCONVERT
C		Updated to use LSLLIB, DTILIB and standard messages
C
C Description:
C 	
C	Program to convert Laser-Scan DTI (Digital Terrain Image) files 
C	to USGS DEM (United States Geological Survey Digital Elevation Model)
C	format on disk or tape
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE 'LSL$DTI2DEM:DTI2DEMMSG.PAR'	! DTI2DEM message definitions
C
C Local variables
C
	INTEGER		STATUS
C
C Functions
C
	LOGICAL		OBEY		! get command line
	LOGICAL		GETSW		! get SW corner of map
	LOGICAL		GETORG		! get origin of DTI
	LOGICAL		GETHDR		! get header for DEM file
	LOGICAL		DTISCAN		! Scan the DTI for heights
	LOGICAL		OUTRECA		! output record A of DEM
	LOGICAL		OUTDEM		! output rest of DEM
	LOGICAL		CLSFIL		! Close files
C
C-------------------------------------------------------------------------------
C
C Initialise LSLLIB and DTILIB
C
	CALL LSL_INIT
	CALL DTI_INIT
C
C Get command line, and check that files are sensible
C
	STATUS = OBEY()
	IF ( .NOT.STATUS ) GOTO 999
C
C Get origin of DTI
C
10	CONTINUE
	STATUS = GETORG()
	IF ( .NOT.STATUS ) GOTO 999
C
C Get SW corner of map
C
	STATUS = GETSW()
	IF ( STATUS .EQ. LSL__EOF ) GOTO 999
	IF ( .NOT.STATUS ) GOTO 10
C
C Get header for record A of DEM
C
	STATUS = GETHDR()
	IF ( .NOT.STATUS ) GOTO 999
C
C Do first scan of DTI, to get max and min of each column, and
C whole of area of DTI included in map
C
	STATUS = DTISCAN()
	IF ( .NOT.STATUS ) GOTO 999
C
C Output the first record
C
	STATUS = OUTRECA()
	IF ( .NOT.STATUS ) GOTO 999
C
C Output columns of DEM
C
	STATUS = OUTDEM()
	IF ( .NOT.STATUS ) GOTO 999
C
C Close files
C
  999	CONTINUE
	STATUS = CLSFIL()
C
	IF ( STATUS ) THEN
	   STATUS = DTI2DEM__NORMAL
	ELSE
	   STATUS = DTI2DEM__ABORT
	ENDIF
C
	CALL LSL_EXIT( STATUS )
C
	END
