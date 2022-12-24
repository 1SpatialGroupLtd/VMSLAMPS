C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-05-10 15:02:22.000000000 +0100
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
	LOGICAL FUNCTION RDSXD
C
CDEC$	IDENT	'10MY90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Read SXD entry
C
C Description
C
C	Reads a feature description table entry
C
C	Expects the FC just read 
C	            to be in INTARG(1) in /CMDCOM/
C		the SXF transfer code just read 
C	            to be in INTARG(2) in /CMDCOM/
C
C	Returns FALSE if something goes wrong with a command line, 
C	TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNI2SXF:I2SXFMSG.PAR' ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	! DCL command decoding
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:EXCEPTION.CMN'	! number reading errors
	INCLUDE 'LSL$CMNI2SXF:TABLE.CMN'! feature description table
C
C Local Variables
C
	INTEGER*4	I		! counter
	LOGICAL		NOTHING		! nothing read ?
C
C Assume that everything goes well
C
	RDSXD = .TRUE.
C
C Check the table isn't full
C
	IF (TABLE_LEN .GE. MAX_TABLE) THEN
	   CALL LSL_PUTMSG(I2SXF__TABLEFULL,MAX_TABLE)
	   GOTO 9999
	ENDIF
C
C Get ready for a new FC
C
	TABLE_LEN = TABLE_LEN + 1
C
C We have already read the FC so check that it is in range and save it
C
	IF ( INTARG(1).LT.0 .OR. INTARG(1).GT.MAX_WORD ) THEN
	   CALL LSL_PUTMSG(I2SXF__BADFC,INTARG(1))
	   GOTO 9998
	ELSE
	   FC_TABLE(TABLE_LEN) = INTARG(1)
	ENDIF
C
C We don't need to check the SXF transfer code - it would have
C overflowed if it was too large
C
	SXF_TABLE(TABLE_LEN) = INTARG(2)
C
C and finish
C
	GOTO 9000		! success
C
C Errors
C
9998	TABLE_LEN = TABLE_LEN - 1
9999	RDSXD = .FALSE.			! failure
C
C Return
C
9000	RETURN
	END
