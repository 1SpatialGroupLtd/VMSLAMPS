	LOGICAL FUNCTION CLOSE_FILES
C
CDEC$	IDENT	'31OC89'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					APB	04-Oct-1989
C
C Description:
C
C	Module CLOSE_FILES called by DEM2DTI in package DTMCONVERT
C	Closes the files specified on the command line
C	
	IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$DEM2DTI:DEM2DTIMSG.PAR'	! DEM2DTI messages
	INCLUDE 'LSL$DEM2DTI:LUN.PAR'		! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE	'LSL$DEM2DTI:FILE.CMN'		! DEM2DTI filenames
	INCLUDE	'LSL$DEM2DTI:COMMANDS.CMN'	! Command line results
	INCLUDE 'LSL$CMNDTI:DTIHDR.CMN'		! DTI header
C
C Functions
C
	LOGICAL		FLRCLO		! Close a file for read
	LOGICAL		DTI_CLOSE	! Close a DTI file
C
C Local variables
C
	INTEGER		STATUS		! Return status
	INTEGER		ERROR		! System error status
	LOGICAL		FOREIGN		! True if DEM is magtape /FOREIGN
C
C-------------------------------------------------------------------------------
C
C Check to see if the specified DEM input file is magtape or disk
C
	IF ( MAGTAPE ) THEN
C
	ELSE					! Close DEM disk file
C	
C DEM must be a disk file so close it
C
	   STATUS = FLRCLO( DEMLUN,DEMFILE(1:DEMLEN) )
	   IF ( STATUS ) THEN
 	     IF ( LOG ) CALL LSL_PUTMSG( DEM2DTI__DEMCLOSED,DEMFILE(1:DEMLEN) )
	   ELSE
	     CALL LSL_PUTMSG( DEM2DTI__CLOSERR,DEMFILE(1:DEMLEN) )
	     CALL LSL_ADDMSG( STATUS )
	   ENDIF
	ENDIF
C
C  Now close the DTI file which should be ok. Don't update the header
C  or clear the common variables
C
	HAD_PROJ_RECORD(DTILUN) = .FALSE.
	STATUS = DTI_CLOSE( DTILUN,.FALSE.,.FALSE.,ERROR )
	IF ( STATUS ) THEN
	   IF ( LOG ) CALL LSL_PUTMSG( DEM2DTI__DTICLOSED,DTIFILE(1:DTILEN) )
	ELSE
	   CALL LSL_PUTMSG( DEM2DTI__CLOSERR,DTIFILE(1:DTILEN) )
	   CALL LSL_ADDMSG( STATUS )
	ENDIF
C
999	CONTINUE
	CLOSE_FILES = STATUS
C
	RETURN
	END
C
