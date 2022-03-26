 	PROGRAM	DEM2DTI
C
CDEC$	IDENT	'09OC89'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					APB	03-Oct-1989
C
C Description:
C
C	Module DEM2DTI in package DTMCONVERT
C	Conversion utility to read in a USGS (United States Geological
C	Survey) DEM (Digital Elevation Model) file and write a LSL
C	(Laser Scan Ltd) DTI (Digital Terrain Image) file.
C
        IMPLICIT NONE
C
C Messages
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE	'LSL$DEM2DTI:DEM2DTIMSG.PAR'
C
C Functions
C
	LOGICAL		OBEY       		! Command line interpreter
	LOGICAL		OPEN_FILES		! Open DEM and DTI files
	LOGICAL		WRITE_DTI		! Write data to DTI file
	LOGICAL		CLOSE_FILES		! Close DEM and DTI files
C
C Local Variables
C
	INTEGER		STATUS			! Return error status
C
C-------------------------------------------------------------------------------
C
C Initialise LSLLIB and DTILIB
C
	CALL LSL_INIT
	CALL DTI_INIT
C
C Decode the command line
C
	STATUS = OBEY()
	IF ( .NOT.STATUS ) GOTO 999
C
C Open the input DEM file (magtape or disk) and the output DTI file
C
	STATUS = OPEN_FILES()
	IF ( .NOT.STATUS ) GOTO 999
C
C Write the DEM elevation data to the DTI file
C
	STATUS = WRITE_DTI()
	IF ( .NOT.STATUS ) GOTO 999
C
C Close the DEM and DTI files
C
	STATUS = CLOSE_FILES()
	IF ( .NOT.STATUS ) GOTO 999
C
C And exit with the success/error status from earlier
C
999	CONTINUE
C
C If STATUS is .TRUE. or .FALSE., change it to a proper message code
C
	IF ( STATUS ) THEN
	   STATUS = DEM2DTI__NORMAL
	ELSEIF ( .NOT.STATUS ) THEN
	   STATUS = DEM2DTI__ABORT
	ENDIF
C
	CALL LSL_EXIT( STATUS )
C
	END
C
