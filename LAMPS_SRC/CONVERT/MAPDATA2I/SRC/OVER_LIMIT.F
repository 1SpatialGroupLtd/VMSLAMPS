C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-23 18:46:10.000000000 +0100
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
	LOGICAL FUNCTION OVER_LIMIT(INDEX)
C
CDEC$	IDENT	'23SE94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author				Steve Townrow	26-Jul-1994
C
C Description:
C       Each time we increment an index into a points array (be it PTS,
C       LINE_IN or LINE_OUT) we should test it won't run of the end of the
C       array. This test is therefore done often and warranted it's own
C       routine. And here it is....
C
C
	IMPLICIT	NONE
C
C Arguments
C
	INTEGER*4	INDEX
C
C Parameters
C
	INCLUDE 'LSL$CMNCOORD:MAXPTS.PAR'
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! MAPDATA2I messages
C
C------------------------------------------------------------------------------
C
	OVER_LIMIT = .FALSE.
C
	IF (INDEX.GT.MAXPTS) THEN
	   CALL LSL_PUTMSG(MD2I__OUTBUFFULL,MAXPTS)
	   OVER_LIMIT = .TRUE.
	ENDIF
C
C and that's it
C
	RETURN
	END
C
