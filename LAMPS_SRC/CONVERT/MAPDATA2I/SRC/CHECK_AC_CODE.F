C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-25 11:40:42.000000000 +0100
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
	INTEGER*4 FUNCTION CHECK_AC_CODE(WHICH_CODE)
C
CDEC$	IDENT	'25SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	13-Sep-1994
CMOD	Used in MAPDATA2I to ensure compatibility	ST	20-Sep-1994
C       Mod 1400.
C
C	CONVERT MAPDATA2I Utility - Check AC code
C
C Description
C
C	Checks the validity of an AC code.
C
C	Returns the error code held in LSL_STATUS if the code is invalid,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'		! FRTLIB ACD interface
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
C
C Arguments
C
	INTEGER*4	WHICH_CODE		! AC code
C
C------------------------------------------------------------------------------
C Assume success
C
	CHECK_AC_CODE = LSL__NORMAL
C
C Just check the code is within the allowed range
C
 	IF ( WHICH_CODE.LT.1 .OR. WHICH_CODE.GT.ACD_CODE_MAX ) THEN
	   CALL LSL_PUTMSG(MD2I__BADATTCODE,WHICH_CODE,1,ACD_CODE_MAX)
	   GOTO 9999
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	CHECK_AC_CODE = LSL_STATUS
C
C Return
C
10000	RETURN
	END
