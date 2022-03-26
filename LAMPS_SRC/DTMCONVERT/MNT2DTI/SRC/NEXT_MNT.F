	LOGICAL FUNCTION NEXT_MNT
C
CDEC$	IDENT	'21AU90'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	14-Aug-1990
C
C Description:
C
C	Module NEXT_MNT called by MNT2DTI in package DTMCONVERT
C	Called to skip or find the next MNT file on tape
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
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE	'LSL$MNT2DTI:FILE.CMN'		! MNT2DTI filenames
	INCLUDE	'LSL$MNT2DTI:COMMANDS.CMN'	! Command line results
	INCLUDE 'LSL$MNT2DTI:MNT_HEADER.CMN'	! MNT header information
C
C Functions
C
	LOGICAL		MTIEOV			! Find end-of-volume
	LOGICAL		MTIBCK			! Space back 1 block
	LOGICAL		MTIRDB			! Read block
	LOGICAL		TEST_FOREIGN		! Test if MNT file is magtape
C
C Parameters
C
	LOGICAL		SKIPMNT			! Test if to skip next MNT
C
C Local variables
C
	INTEGER*4	STATUS			! Return status
	INTEGER*4	ERROR			! System error status
	LOGICAL		FOREIGN			! True if MNT is magtape/FOREIGN
	BYTE		MTBUF(MAXBLK)		! Buffer for data
	INTEGER*4	MTBYTES			! Number of bytes read
C
C-------------------------------------------------------------------------------
C
C Skip map to End-Of-Volume which is denoted by a tape mark
C OR locate read head at beginning of header record or next MNT file
C
	STATUS = MTIEOV()
	IF ( .NOT.STATUS ) THEN
	   CALL LSL_ADDMSG( STATUS )
	   IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	   GOTO 999
	ENDIF
C
	IF ( LOG ) THEN
	   CALL LSL_PUTMSG( MNT2DTI__TAPEMARK, MTINBL )
	ENDIF
C
C Read over next block which may be another tape mark or the next header
C
	STATUS = MTIRDB(MTBUF,BLKSIZ,MTBYTES)
	IF ( STATUS ) THEN
C
C Read was successful so a header record was read instead.
C Therefore only 1 tape mark separates file. Move back a block
C
	   STATUS = MTIBCK()
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_ADDMSG( STATUS )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999
	   ENDIF
	   MNTBEGIN = .TRUE.
	ELSE
C
C MTIRDB returns an error when tape mark is read but this is OK
C
	   IF ( STATUS .EQ. LSL__EOF ) THEN
	      STATUS = LSL__NORMAL
C
	      IF ( LOG ) THEN
	         CALL LSL_PUTMSG( MNT2DTI__TAPEMARK, MTINBL )
	      ENDIF
C
	      STATUS = MTIRDB(MTBUF,BLKSIZ,MTBYTES)
	      IF ( STATUS ) THEN
C
C Read was successful so another file exists on tape
C
	         STATUS = MTIBCK()
	         IF ( .NOT.STATUS ) THEN
	            CALL LSL_ADDMSG( STATUS )
	            IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	            GOTO 999
	         ENDIF
	         MNTBEGIN = .TRUE.
	      ELSE
	         CALL LSL_PUTMSG( MNT2DTI__ENDOFTAPE )
	         MNTEOT = .TRUE.
	         MNTBEGIN = .FALSE.
	         GOTO 999
	      ENDIF
C
	   ELSE
	      MNTBEGIN = .FALSE.
	      CALL LSL_ADDMSG( STATUS )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999	
	   ENDIF
	ENDIF
C
999	CONTINUE
	NEXT_MNT = STATUS
C
	RETURN
	END
