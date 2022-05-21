C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-05-24 12:24:00.000000000 +0100
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
	LOGICAL FUNCTION READBLK
C
CDEC$	IDENT	'24MY91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	4-Jan-1991
C
C Description:
C
C	Module READBLK called by ARC2I in package CONVERT.
C	This reads a tape block into MTBUF. MTIRDB does not fill the buffer
C	given as an argument when in encounters the EOF. Since the block size
C	is up to 65535, any remainder is not read into MTBUF. So when this
C	happens, the function reads in lines of 80 to fill MTBUF.
C	
	IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
	INCLUDE 'HERE:LUN.PAR'			! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:CLD.CMN'		! DCL command interpretation
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:GENERAL.CMN'		! General variables
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
C
C Functions
C
	LOGICAL		MTIRDB			! Read block
C
C Local variables
C
	INTEGER*4	STATUS			! Return status
	INTEGER*4	ERROR			! System error status
	INTEGER*4	OK			! success of a call
	INTEGER*4	I			! Pointer to MTBUF
C
C-------------------------------------------------------------------------------
C
100	STATUS = MTIRDB(MTBUF,BLKSIZ,MTBYTES)
C
	MTBLOCKS = MTBLOCKS + 1
C
	IF ( .NOT.STATUS ) THEN
	   IF ( STATUS .EQ. LSL__EOF ) THEN
	      LAST_BLOCK = .TRUE.
	      STATUS = LSL__NORMAL
	   ELSE
	      CALL LSL_ADDMSG( STATUS )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999
	   ENDIF
	ENDIF
C
C This is removed because GET_EXP_LINE will now read records that span blocks
C which implies that the blocksize need not be exactly divisible by 80.
C S.Townrow 24/5/91 (Mod 1001)
C
C	IF ( MOD(MTBYTES,80).NE.0) THEN
C	   STATUS = ARC2I__BLKSIZ
C	   CALL LSL_PUTMSG( STATUS )
C	   GOTO 999
C	ENDIF
C
999	CONTINUE
	READBLK = STATUS
C
	RETURN
	END
