C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-23 17:45:58.000000000 +0100
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
	INTEGER*4 FUNCTION GET_AC_CODE(CODE_OUT,NAME_IN)
C
CDEC$	IDENT	'23SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	14-Sep-1994
CMOD	Used in MAPDATA2I to ensure compatibility	ST	20-Sep-1994
C       Mod 1400.
C
C	CONVERT MAPDATA2I Utility - Get AC code from name
C
C Description
C
C	Gets an AC code, given the associated name.
C
C	Returns the error code held in LSL_STATUS if something goes wrong,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! message definitions
C
C Arguments
C
	INTEGER*4	CODE_OUT		! output AC code
	CHARACTER*(*)	NAME_IN			! input AC name
C
C Common Blocks
C
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'		! FRTLIB ACD interface
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
C
C Functions called
C
	LOGICAL		ACDFND_NAME		! get AC definition from name
C
C------------------------------------------------------------------------------
C Assume success
C
	GET_AC_CODE = LSL__NORMAL
C
C Find the given name in the ACD table
C
	IF ( ACDFND_NAME(NAME_IN,) ) THEN
	   CALL LSL_ADDMSG(MD2I__UNKATTNAME,NAME_IN)
	   LSL_STATUS = MD2I__UNKATTNAME		! reset status
	   GOTO 9999
	ENDIF
C
C and set the AC code
C
	CODE_OUT = ACD_CODE
C
	GOTO 10000
C
C Failure
C
9999	GET_AC_CODE = LSL_STATUS
C
C------------------------------------------------------------------------------
C Return
C
10000	RETURN
	END
