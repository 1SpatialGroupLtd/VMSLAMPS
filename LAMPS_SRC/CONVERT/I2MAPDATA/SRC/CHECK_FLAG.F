C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-11 13:38:42.000000000 +0100
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
	SUBROUTINE CHECK_FLAG(FLAG,IS_CURVE)
C
CDEC$	IDENT	'11OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	10-Oct-1994
C
C	CONVERT I2MAPDATA Utility - Check flag
C
C Description
C
C	Checks the validity of a curve or priority flag
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'	! for messages
	INCLUDE	'CMN:GEN.PAR'		! for UNSET_FLAG
C
C Common blocks
C
	INCLUDE	'CMN:IFF.CMN'		! IFF stuff
C
C Arguments
C
	INTEGER*4	FLAG		! the curve or priority as an int
	LOGICAL		IS_CURVE	! Are we checking the CURVE flag?
C
C------------------------------------------------------------------------------
C
C Checking a CURVE flag
C
 	IF (IS_CURVE) THEN
	   IF (FLAG.EQ.IFF_ABSENT) FLAG = UNSET_FLAG
C
C Should be 'C   ' or '    '
C
	   IF (FLAG.NE.'C   ' .AND.FLAG.NE.'I   '.AND.FLAG.NE.UNSET_FLAG) THEN
	      CALL LSL_PUTMSG(I2MD__UNKCURFLG,POINTNUM,FSN)
	      FLAG = UNSET_FLAG
	   ENDIF
	ELSE
C
C Check PRIORITY flag
C
	   IF (FLAG.EQ.IFF_ABSENT) FLAG = UNSET_FLAG
C
C Should be 'H   ', 'L   ' or '    '
C
	   IF (FLAG.NE.'H   '.AND.FLAG.NE.'L   '.AND.FLAG.NE.UNSET_FLAG) THEN
	      CALL LSL_PUTMSG(I2MD__UNKPRIOFLG,POINTNUM,FSN)
	      FLAG = UNSET_FLAG
	   ENDIF
	ENDIF
C
C Return
C
	RETURN
	END
