C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-08-21 14:13:26.000000000 +0100
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
	LOGICAL FUNCTION READ_DATA( RECNUM )
C
CDEC$	IDENT	'21AU90'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	26-Jul-1990
C
C Description:
C
C	Module READ_DATA called by MNT_SCAN in program MNT2DTI
C	Reads a data record of a MNT file
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
	INCLUDE 'LSL$MNT2DTI:MNT_HEADER.CMN'	! MNT header record
	INCLUDE 'LSL$MNT2DTI:MNT_DATA.CMN'	! MNT data record
	INCLUDE	'LSL$MNT2DTI:FILE.CMN'		! MNT2DTI filenames
	INCLUDE	'LSL$MNT2DTI:COMMANDS.CMN'	! Command line results
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
	INTEGER*2	RECNUM		! Number of data record being read
C
C Local variables
C
	INTEGER		STATUS		! Return status
	INTEGER*2	LENGTH		! Number of bytes in logical record
	BYTE		MTBUF( MAXBLK )	! Tape buffer
	INTEGER		MTBYTES		! No. of bytes read from tape
	LOGICAL		NONUM		! Flag if number not read from TXTBUF
	LOGICAL		SKIP_CLUTTER	! Skip clutter character in 100m data
	INTEGER*2	I,J		! Loop counters
	INTEGER*2	ELEVNUM		! Number of the elevation datum
	INTEGER*2	OFFSET		! Offset within element
	INTEGER*2	SZEBLOCK	! Size of blocks forming profile
	INTEGER*2	TEMP		! Elevation value to be checked
C
	DATA		LENGTH	 / 1024 /
C
C-------------------------------------------------------------------------------
C
C Read the data record into the LSLLIB text buffer. Note that the data record
C may take up more than 1 1024-byte record. 
C
	OFFSET = 1
	ELEVNUM = 1
	IF ( .NOT.MAGTAPE ) LENGTH = BLKSIZ
C
C If the MNT resolution is 100m and the field size for data values is 5, the 5th
C character of the field is a clutter value. The data value is held in the first
C 4 characters, as in: '  58C  57C  59C  61C  61C....' where C is the clutter
C value. The SETWIN moves on by 4 then skips 1.
C
	SKIP_CLUTTER = .FALSE.
	IF (MNTPOINTS.EQ.100 .AND. MNTDSIZE.EQ.5) THEN
	   MNTDSIZE = 4
	   SKIP_CLUTTER = .TRUE.
	ENDIF
C
C If the MNT is on tape then the data must be read in 4 kbyte blocks
C otherwise read in 1 kbyte blocks from disk
C
	IF ( .NOT.MAGTAPE ) CALL SET_TXTLIM( LENGTH )
C
C Read next block from tape if needed
C
5	CONTINUE
	IF ( MAGTAPE .AND. LOGREC .GT. BLKSIZ - (MNTDSIZE-1) ) THEN
	   STATUS = MTIRDB( MTBUF,BLKSIZ,MTBYTES )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      IF ( STATUS.EQ.LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999
	   ENDIF
	   LOGREC = -1*KBYTE		
	   CALL SETAUX( MTBUF,BLKSIZ )	! Set buffer to read into (4 kbytes)
	ENDIF
C
C Loop back to here if the data record takes up more than one 1 kbyte record
C
10	CONTINUE
	IF ( .NOT.MAGTAPE ) OFFSET = 1
C
	IF ( MAGTAPE ) THEN		! Read from tape into MTBUF
	   LOGREC = LOGREC + KBYTE	! Offset within physical record 
	   CALL DCPSET( LOGREC+1 )	! Set the decoding pointer
	ELSE			
	   CALL BSLN
	   STATUS = FLRLIN()		! Read record into TXTBUF
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( MNT2DTI__ERRRDDATA,RECNUM )
	      CALL LSL_ADDMSG( STATUS )
	      GOTO 999
	   ENDIF
	   LOGREC = 0
	ENDIF
C
C The record has been read successfully so now decode it into the MNT_DATA
C common variable MNTELEV
C
C Loop reading elevation words until the end of the buffer is reached
C
500	CONTINUE
C
C Check if the end of the data record has been reached
C
	IF ( ELEVNUM .GT. MNTPOINTS ) GOTO 999 	
C
C Check if the end of the logical block has been reached
C
	IF ( OFFSET-LOGREC .GT. LENGTH-(MNTDSIZE-1) ) GOTO 10
C
C or if the end of the physical record has been reached
C
	IF ( LOGREC .GT. BLKSIZ - (MNTDSIZE-1) ) GOTO 5
C
C If the end of record or buffer has not been reached read the next 
C elevation datum into the common array MNTELEV
C
	CALL SETWIN ( OFFSET,MNTDSIZE )
	NONUM = RDINT( TEMP )
	MNTELEV( ELEVNUM ) = TEMP
	ELEVNUM = ELEVNUM + 1			    ! Number for next datum
	OFFSET = OFFSET + MNTDSIZE		    ! Byte offset for next datum
	IF ( SKIP_CLUTTER ) OFFSET = OFFSET + 1     ! Skip clutter character
	GOTO 500
C
999	CONTINUE
	IF ( LOGREC .EQ. BLKSIZ-KBYTE ) LOGREC = BLKSIZ
	READ_DATA = STATUS
C
	RETURN
	END
