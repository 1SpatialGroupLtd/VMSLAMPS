C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-08-16 12:01:04.000000000 +0100
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
	LOGICAL FUNCTION READ_RECB( RECNUM )
C
CDEC$	IDENT	'01NO89'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					APB	06-Oct-1989
C
C Description:
C
C	Module READ_RECB called by DEM_SCAN in program DEM2DTI
C	Reads a B record of a DEM file
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
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text buffer
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input 
	INCLUDE 'LSL$DEM2DTI:DEMA.CMN'		! DEM A record
	INCLUDE 'LSL$DEM2DTI:DEMB.CMN'		! DEM B record
	INCLUDE	'LSL$DEM2DTI:FILE.CMN'		! DEM2DTI filenames
	INCLUDE	'LSL$DEM2DTI:COMMANDS.CMN'	! Command line results
C
C Functions
C	
	LOGICAL		MTIRDB		! Read from magtape
	LOGICAL		FLRLIN		! Read from file into TXTBUF
	INTEGER		READSTR		! Read string from TXTBUF
	LOGICAL		RDINT		! Read word integer from TXTBUF
	LOGICAL		RDREAL		! Read single precision real
	LOGICAL		RREAL8		! Read double precision real
C
C Parameters
C
	INTEGER*2	RECNUM		! Number of B record being read
C
C Local variables
C
	INTEGER*2	BUFFER		! Number of buffer being read from file
	INTEGER		STATUS		! Return status
	INTEGER*2	LENGTH		! Number of bytes in logical record
	BYTE		MTBUF( MAXBLK )	! Tape buffer
	INTEGER		MTBYTES		! No. of bytes read from tape
	LOGICAL		NONUM		! Flag if number not read from TXTBUF
	INTEGER*2	I,J		! Loop counters
	INTEGER*2	ELEVNUM		! Number of the elevation datum
	INTEGER*2	OFFSET		! Offset within element
C
	DATA		LENGTH	/ 1024 /
C
C-------------------------------------------------------------------------------
C
C Read the B record into the LSLLIB text buffer. Note that the B record may
C take up more than 1 1024-byte record. 
C
	BUFFER = 0
	ELEVNUM = 1
C
C If the DEM is on tape then the data must be read in 4 kbyte blocks
C otherwise read in 1 kbyte blocks from disk
C
	IF ( .NOT.MAGTAPE ) CALL SET_TXTLIM( LENGTH )
C
C Read next block from tape if needed
C
5	CONTINUE
	IF ( MAGTAPE .AND. LOGREC .GT. BLKSIZ - (DEMBBYT(6)-1) ) THEN
	   STATUS = MTIRDB( MTBUF,BLKSIZ,MTBYTES )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      IF ( STATUS.EQ.LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999
	   ENDIF
	   IF ( RECNUM .EQ. 1 ) THEN
	      LOGREC = 0		! Skip the A record
	   ELSE
	      LOGREC = -1*KBYTE		
	   ENDIF
	   CALL SETAUX( MTBUF,BLKSIZ )	! Set buffer to read into (4 kbytes)
	ENDIF
C
C Loop back to here if the B record takes up more than one 1 kbyte record
C
10	CONTINUE
	BUFFER = BUFFER + 1
C
	IF ( MAGTAPE ) THEN		! Read from tape into MTBUF
	   LOGREC = LOGREC + KBYTE	! Offset within physical record 
	   CALL DCPSET( LOGREC+1 )	! Set the decoding pointer
	ELSE			
	   CALL BSLN
	   STATUS = FLRLIN()		! Read A record into TXTBUF
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( DEM2DTI__ERRRDRECB,RECNUM )
	      CALL LSL_ADDMSG( STATUS )
	      GOTO 999
	   ENDIF
	   LOGREC = 0
	ENDIF
C
C The record has been read successfully so now decode it into the DEMB
C common variables
C
	IF ( BUFFER .EQ. 1 ) THEN	! First 1024 bytes so read header
C
C Element (1) DEMID - Row and column identification for this record
C
	   DO 100 I = 1,2
	      CALL SETWIN( DEMBOFF(1) + DEMBBYT(1)*(I-1) + LOGREC,DEMBBYT(1) )
	      NONUM = RDINT( DEMID(I) )
100	   CONTINUE
C
C Element (2) DEMNROW - Number of rows in this profile
C
	   DO 200 I = 1,2
	      CALL SETWIN( DEMBOFF(2) + DEMBBYT(2)*(I-1) + LOGREC,DEMBBYT(2) )
	      NONUM = RDINT( DEMNROW(I) )
200	   CONTINUE
C
C Element (3) DEMFIRST - The coordinates of the first elevation in profile
C
	   DO 300 I = 1,2
	      CALL SETWIN( DEMBOFF(3) + DEMBBYT(3)*(I-1) + LOGREC, DEMBBYT(3) )
	      NONUM = RREAL8( DEMFIRST(I) )
300	   CONTINUE
C
C Element (4) DEMDATUM - Elevation of datum for this profile
C
	   CALL SETWIN( DEMBOFF(4) + LOGREC,DEMBBYT(4) )
	   NONUM = RREAL8( DEMDATUM )
C
C Element (5) DEMPRNG - Min and max elevations
C
	   DO 400 I = 1,2
	      CALL SETWIN( DEMBOFF(5) + DEMBBYT(5)*(I-1) + LOGREC,DEMBBYT(5) )
	      NONUM = RREAL8( DEMPRNG(I) )
400	   CONTINUE
	ENDIF	
C
C Element (6) DEMELEV - the elevation data. There are DEMNROW(1) of them
C			altogether. If this is the first buffer then start
C			reading from the offset position, otherwise beginning
C			at the first byte of the buffer
C
	CALL DCPSAV( OFFSET )		! Save the current buffer position
C
C Loop reading elevation words until the end of the buffer is reached
C
500	CONTINUE
C
C Check if the end of the B record has been reached
C
	IF ( ELEVNUM .GT. DEMNROW(1) ) GOTO 999 	
C
C Check if the end of the logical record has been reached
C
	IF ( OFFSET-LOGREC .GT. LENGTH - (DEMBBYT(6)-1) ) GOTO 10
C
C or if the end of the physical record has been reached
C
	IF ( LOGREC .GT. BLKSIZ - (DEMBBYT(6)-1) ) GOTO 5
C
C If the end of record or buffer has not been reached read the next 
C elevation datum into the common array DEMELEV
C
	CALL SETWIN ( OFFSET,DEMBBYT(6) )
	NONUM = RDINT( DEMELEV( ELEVNUM ) )
	ELEVNUM = ELEVNUM + 1			! Number for next datum
	OFFSET = OFFSET + DEMBBYT(6)		! Byte offset for next datum
	GOTO 500
C
999	CONTINUE
	IF ( LOGREC .EQ. BLKSIZ-KBYTE ) LOGREC = BLKSIZ
	READ_RECB = STATUS
C
	RETURN
	END
C
