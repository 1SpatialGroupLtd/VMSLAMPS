C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-08-24 14:49:38.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
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
