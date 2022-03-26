	PROGRAM	MNT2DTI
C
CDEC$	IDENT	'21AU90'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	23-Jul-1990
C
C Description:
C
C	Module MNT2DTI in package DTMCONVERT
C	Conversion utility to read in a I.G.N (Institut Geographique
C	National - France) M.N.T file and write a LSL (Laser Scan Ltd)
C	DTI (Digital Terrain Image) file.
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
	INCLUDE	'LSL$CMNLSL:CLD.CMN'		! LSLLIB filenames
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE	'LSL$MNT2DTI:FILE.CMN'		! MNT2DTI filenames
	INCLUDE	'LSL$MNT2DTI:COMMANDS.CMN'	! Command line results
	INCLUDE 'LSL$MNT2DTI:MNT_HEADER.CMN'	! MNT header information
C
C Functions
C
	LOGICAL		OBEY       		! Command line interpreter
	LOGICAL		NEXT_MNT		! Find next MNT on tape
	LOGICAL		OPEN_FILES		! Open MNT and DTI files
	LOGICAL		WRITE_DTI		! Write data to DTI file
	LOGICAL		CLOSE_FILES		! Close MNT and DTI files
	LOGICAL		FLROPN			! Open a file for read
	LOGICAL		MTINIT			! Initialise a tape for read
	LOGICAL		MTIEOV			! Find end-of-volume
	LOGICAL		MTIBCK			! Space back 1 block
	LOGICAL		MTIRDB			! Read block
	LOGICAL		TEST_FOREIGN		! Test if MNT file is magtape
C
C Local Variables
C
	INTEGER		STATUS			! Return error status
	INTEGER		ERROR			! System error status
	LOGICAL		FOREIGN			! True if MNT is magtape/FOREIGN
	INTEGER		I			! Loop counter
	INTEGER		NUMCREATED		! Number of DTI files created
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
C Parse input filename
C
	IF ( MAGTAPE ) THEN
	   STATUS = TEST_FOREIGN( MNTFILE,FOREIGN,ERROR )
	   IF ( STATUS .EQ. LSL__NORMAL .AND. FOREIGN ) THEN
	      MAGTAPE = .TRUE.	
	      CALL WRITEF( 'Initializing tape for read - Please wait.' )
	      STATUS = MTINIT( MNTFILE(1:MNTLEN), .FALSE., )
	      IF ( .NOT.STATUS ) THEN
	         CALL LSL_PUTMSG( MNT2DTI__MAGTAPE,MNTFILE(1:MNTLEN) )
	         CALL LSL_ADDMSG( STATUS )
	         IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	         GOTO 999
	      ENDIF	
C
C Either the tape is not mounted foreign or the user specified a device name
C that isn't a tape device, in which case the filename is missing
C
	   ELSEIF ( STATUS .EQ. LSL__NORMAL .AND. .NOT.FOREIGN ) THEN
	      IF ( MNTFILE(1:1) .EQ. 'M' .OR. MNTFILE(1:1) .EQ. 'm' ) THEN
	         STATUS = MNT2DTI__NOTMNTFOR
	         CALL LSL_PUTMSG( STATUS,MNTFILE(1:MNTLEN) )
	         GOTO 999
	      ELSE
C
C Disk device name only
C
	         STATUS = MNT2DTI__NOFILNAM
	         CALL LSL_PUTMSG( STATUS,MNTFILE(1:MNTLEN) )
	         GOTO 999
	      ENDIF
C
C Error in device name
C
	   ELSEIF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( MNT2DTI__NODEVICE,MNTFILE(1:MNTLEN) )
	      GOTO 999
	   ENDIF
C
	ELSE					! Read MNT file from disk	
C	
C MNT must be a disk file so open it for read
C
	   MAGTAPE = .FALSE.
	   STATUS = FLROPN( MNTLUN,MNTFILE(1:MNTLEN) )
	   IF ( STATUS ) THEN
	     IF ( LOG ) CALL LSL_PUTMSG( MNT2DTI__MNTOPEN,MNTFILE(1:MNTLEN) )
	   ELSE
	     CALL LSL_PUTMSG( MNT2DTI__FILOPEN,MNTFILE(1:MNTLEN) )
	     CALL LSL_ADDMSG( STATUS )
	     GOTO 999
	   ENDIF
C
C Give warning that /HEADER or /SELECT will be ignored if specified on
C command line when not using magtape.
C
	   IF ( SELECT .OR. HEADER ) CALL LSL_PUTMSG( MNT2DTI__IGNOREDQUAL )
C
	ENDIF
C
C Process selected files on tape or just the one if disk
C
	NUMCREATED = 0
	MNTNUM = 1
	MNTBEGIN = .TRUE.
	MNTEOT = .FALSE.
C
100	CONTINUE
	IF ( MAGTAPE ) THEN
	   IF ( SELECT ) THEN
C
C See if the current MNT file was in the select list
C
	      DO 200 I = 1, NUMINT
	         IF (IARRAY(I).EQ.MNTNUM) GOTO 300
200           CONTINUE
C
C It was not, so skip it
C
	      CALL WRITEF('Skipping MNT file %^W%I0%^L',MNTNUM)
	      STATUS = NEXT_MNT()
	      IF ( (.NOT.STATUS).OR.MNTEOT ) GOTO 999
	      GOTO 500
	   ENDIF
	ENDIF
300	CONTINUE
C
	IF ( .NOT.MNTBEGIN ) GOTO 400
C
C Open the input MNT file (magtape or disk) and the output DTI file
C
	STATUS = OPEN_FILES()
	IF ( .NOT.STATUS ) GOTO 999
C
C Write the MNT data to the DTI file
C
	STATUS = WRITE_DTI()
	IF ( .NOT.STATUS ) GOTO 999
C
C Close the MNT and DTI files
C
	STATUS = CLOSE_FILES()
	IF ( .NOT.STATUS ) GOTO 999
C
	NUMCREATED = NUMCREATED + 1
C
	IF (SELECT.AND.(NUMCREATED.EQ.NUMINT)) GOTO 999
C
400	IF ( MAGTAPE ) THEN
	   STATUS = NEXT_MNT()			! Find next MNT file
	   IF ( (.NOT.STATUS).OR.MNTEOT ) GOTO 999
	ENDIF
C
500	MNTNUM = MNTNUM + 1
C
	IF ( MAGTAPE ) GOTO 100
C
C And exit with the success/error status from earlier
C
999	CONTINUE
C
C If STATUS is .TRUE. or .FALSE., change it to a proper message code
C
	IF ( STATUS ) THEN
	   STATUS = MNT2DTI__NORMAL
	ELSEIF ( .NOT.STATUS ) THEN
	   STATUS = MNT2DTI__ABORT
	ENDIF
C
	CALL LSL_EXIT( STATUS )
C
	END

