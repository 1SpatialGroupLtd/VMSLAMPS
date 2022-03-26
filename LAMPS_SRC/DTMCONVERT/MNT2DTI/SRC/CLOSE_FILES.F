	LOGICAL FUNCTION CLOSE_FILES
C
CDEC$	IDENT	'21AU90'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	23_Jul-1990
C
C Description:
C
C	Module CLOSE_FILES called by MNT2DTI in package DTMCONVERT
C	Closes the files specified on the command line
C	
	IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$MNT2DTI:MNT2DTIMSG.PAR'	! MNT2DTI messages
	INCLUDE 'LSL$MNT2DTI:LUN.PAR'		! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE	'LSL$MNT2DTI:FILE.CMN'		! MNT2DTI filenames
	INCLUDE	'LSL$MNT2DTI:COMMANDS.CMN'	! Command line results
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
	LOGICAL		FOREIGN		! True if MNT is magtape /FOREIGN
C
C-------------------------------------------------------------------------------
C
C Check to see if the specified MNT input file is magtape or disk
C
	IF ( MAGTAPE ) THEN
C
	ELSE					! Close MNT disk file
C	
C MNT must be a disk file so close it
C
	   STATUS = FLRCLO( MNTLUN,MNTFILE(1:MNTLEN) )
	   IF ( STATUS ) THEN
	     IF ( LOG ) CALL LSL_PUTMSG( MNT2DTI__MNTCLOSED,MNTFILE(1:MNTLEN) )
	   ELSE
	     CALL LSL_PUTMSG( MNT2DTI__CLOSERR,MNTFILE(1:MNTLEN) )
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
	   IF ( LOG ) THEN
	      CALL LSL_PUTMSG( MNT2DTI__DTICLOSED,DTIFILE(1:DTILEN) )
	   ELSE
	      CALL WRITEF('DTI file closed.')
	   ENDIF
	ELSE
	   CALL LSL_PUTMSG( MNT2DTI__CLOSERR,DTIFILE(1:DTILEN) )
	   CALL LSL_ADDMSG( STATUS )
	ENDIF
C
999	CONTINUE
	CLOSE_FILES = STATUS
C
	RETURN
	END
