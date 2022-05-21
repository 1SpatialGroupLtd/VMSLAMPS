C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-08-21 14:51:36.000000000 +0100
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
	LOGICAL FUNCTION READ_HEADER( MESSAGES )
C
CDEC$	IDENT	'21AU90'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	24-Jul-1990
C
C Description:
C
C	Module READ_HEADER called by MNT_SCAN in program MNT2DTI
C	Reads the header record of a MNT file
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
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text buffer
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input 
	INCLUDE 'LSL$MNT2DTI:MNT_HEADER.CMN'	! Header record
	INCLUDE	'LSL$MNT2DTI:FILE.CMN'		! MNT2DTI filenames
	INCLUDE	'LSL$MNT2DTI:COMMANDS.CMN'	! Command line results
C
C Argument
C
	LOGICAL		MESSAGES	! (IN) Echo messages to screen
C
C Functions
C	
	LOGICAL		MTIRDB		! Read from magtape
	LOGICAL		MTIBCK		! Backspace one block on tape
	LOGICAL		FLRLIN		! Read from file into TXTBUF
	INTEGER		READSTR		! Read string from TXTBUF
	LOGICAL		RDINT		! Read word integer from TXTBUF
	LOGICAL		RDREAL		! Read single precision real
	LOGICAL		RREAL8		! Read double precision real
C
C Local variables
C
	INTEGER		STATUS		! Return status
	INTEGER 	MTHLEN		! Length of magtape header block(s)
	BYTE		MTBUF( MAXBLK )	! Tape buffer
	INTEGER		MTBYTES		! No. of bytes read from tape
	LOGICAL		NONUM		! Flag if number not read from TXTBUF
	INTEGER*2	I,J		! Loop counters
	INTEGER*2	OFFSET		! Offset within element
C
	DATA		MTHLEN  / 80 /	
C
C-------------------------------------------------------------------------------
C
C Read the header record into the LSLLIB text buffer
C
	CALL WRITEF( 'Reading header record from MNT file ' )
	MTHLEN = BLKSIZ
C
C If input MNT is magtape 
C
	IF ( MAGTAPE ) THEN		
	   CALL SET_TXTLIM( MTHLEN )	
	   CALL BSLN
C
C Skip the header records (80 byte blocks) if required.
C
10	   CONTINUE
	   IF ( .NOT.HEADER ) GOTO 50
	   STATUS = MTIRDB( TXTBUF,MTHLEN,MTBYTES )
	   IF ( STATUS ) GOTO 10
C
	   IF ( STATUS .NE. LSL__EOF .AND. STATUS .NE. LSL__NORMAL ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999
	   ENDIF
C
C Now read the block containing the header record. 
C
50	   CONTINUE
	   STATUS = MTIRDB( MTBUF,BLKSIZ,MTBYTES )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999
	   ENDIF
	   CALL SETAUX( MTBUF,BLKSIZ )	! Set buffer to read from
C
C otherwise input MNT is a disk file
C
	ELSE			
	   CALL SET_TXTLIM( BLKSIZ )	! Number of bytes in text buffer	
	   STATUS = FLRLIN()		! Read header record into TXTBUF
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( MNT2DTI__ERRRDHEAD )
	      CALL LSL_ADDMSG( STATUS )
	      GOTO 999
	   ENDIF
	ENDIF
C
C The record has been read successfully so now decode it into the MNT header
C common variables
C
C Element (1) MNTNAM   - name of MNT file
C
	CALL SETWIN( MNTHOFF(1),MNTHBYT(1) )
	MNTNAML = READSTR( MNTNAM )
	IF ( LOG .AND. MESSAGES ) 
     &     CALL LSL_PUTMSG( MNT2DTI__MNTFILNAM,MNTNAM(1:MNTNAML) )
C
C Element (2) MNTSYS - MNT system of coordinates
C
	CALL SETWIN( MNTHOFF(2),MNTHBYT(2) )
	MNTNAML =  READSTR( MNTSYS )
C
C Element (3) MNTCORN - Coordinates of corners of map
C			Ordered: first point of first profile,
C				 last point of first profile,
C				 first point of last profile,
C				 last point of last profile,
	OFFSET = 0
	DO 200 I = 1,4
	   DO 200 J = 1,2
	      CALL SETWIN( MNTHOFF( 3 ) + MNTHBYT(3)*OFFSET,MNTHBYT(3) )
	      NONUM = RREAL8( MNTCORN(I,J) )
	      OFFSET = OFFSET + 1		
200	CONTINUE
C
C Element (4) MNTPTSEP - Separation between 2 points in a profile
C
	CALL SETWIN( MNTHOFF(4),MNTHBYT(4) )
	NONUM = RREAL8( MNTPTSEP )
C
C Element (5) MNTPRSEP - Separation between 2 profiles
C
	CALL SETWIN( MNTHOFF(5),MNTHBYT(5) )
	NONUM = RREAL8( MNTPRSEP )
C
C Element (6) MNTXYUN - Units for (x/y) coordinates
C
	CALL SETWIN( MNTHOFF(6),MNTHBYT(6) )
	MNTNAML =  READSTR( MNTXYUN )
C
C Element (7) MNTPOINTS - Number of points in a profile
C
	CALL SETWIN( MNTHOFF(7),MNTHBYT(7) )
	NONUM =  RDINT( MNTPOINTS )
C
C Element (8) MNTPROFS - Number of profiles
C
	CALL SETWIN( MNTHOFF(8),MNTHBYT(8) )
	NONUM =  RDINT( MNTPROFS )
C
C Element (9) MNTSIN - Rotation from axis to MNT (Sin)
C
	CALL SETWIN( MNTHOFF(9),MNTHBYT(9) )
	NONUM = RREAL8( MNTSIN )
C
C Element (10) MNTCOS - Rotation from axis to MNT (Cos)
C
	CALL SETWIN( MNTHOFF(10),MNTHBYT(10) )
	NONUM = RREAL8( MNTCOS )
C
C Element (11) MNTZRNG - Minimum and maximum Z values
C
	DO 300 I = 1,2
	   CALL SETWIN( MNTHOFF(11) + MNTHBYT(11)*(I-1),MNTHBYT(11) )
	   NONUM = RREAL8( MNTZRNG(I) )
300	CONTINUE
C
C Element (12) MNTZUN - Units for Z values : METRES or DECIMETRES
C
	CALL SETWIN( MNTHOFF(12),MNTHBYT(12) )
	MNTNAML =  READSTR( MNTZUN )
C
C Element (13) MNTZUN - Size of field for data values
C
	CALL SETWIN( MNTHOFF(13),MNTHBYT(13) )
	NONUM =  RDINT( MNTDSIZE )
C
999	CONTINUE
	READ_HEADER = STATUS
C
	RETURN
	END
