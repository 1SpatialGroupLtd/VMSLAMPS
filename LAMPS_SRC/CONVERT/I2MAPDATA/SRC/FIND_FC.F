C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-21 13:32:12.000000000 +0100
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
	LOGICAL FUNCTION FIND_FC(WHICH_FC)
C
CDEC$	IDENT	'21SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	20-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Find FC in CODE table
C
C Description
C
C	Finds a feature code in the CODE table.
C
C	Returns .TRUE. if the FC is present, .FALSE. otherwise.
C
	IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'CMN:TABLES.CMN'		! parameter tables
C
C Arguments
C
	INTEGER*4	WHICH_FC		! feature code
C
C Local variables
C
	INTEGER*4	I			! counter
C
C Assume success
C
	FIND_FC = .TRUE.
C
C Initialise current FC index
C
	FC_IND = 0
C
C Check if we have any entries
C
	IF ( FC_NUM.LE.0 ) GOTO 9999
C
C Now search the CODE table for the FC
C
	I = 0
C
 100	I = I + 1
	IF ( FC_TAB(FC_FC,I).NE.WHICH_FC .AND. I.LT.FC_NUM ) GOTO 100
C
C Check if the FC is present, and if so set the current index
C
	IF ( FC_TAB(FC_FC,I).NE.WHICH_FC ) GOTO 9999
	FC_IND = I
C
	GOTO 10000
C
C Failure
C
9999	FIND_FC = .FALSE.
C
C Return
C
10000	RETURN
	END
