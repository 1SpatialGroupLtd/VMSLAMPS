C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-06 15:19:26.000000000 +0100
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
	SUBROUTINE SWAP ( NODE_POS, INDEX1, INDEX2)
C
C
CDEC$	IDENT	'06OC89'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
C Created.					  FJB  25-Sept-1989
C
C Swap routine for sorting array of node positions
C
	IMPLICIT NONE
C
C Parameters:                                          
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR/LIST'
C
C
C Workspace:
	INTEGER*2	INDEX1
	INTEGER*2	INDEX2
	INTEGER*4	TEMP_POS
	INTEGER*4	TEMP_OFF
	INTEGER*4	NODE_POS(MAX_NODES,2)
C
	TEMP_POS = NODE_POS(INDEX1,1)
	TEMP_OFF = NODE_POS(INDEX1,2)
	NODE_POS(INDEX1,1) = NODE_POS(INDEX2,1)
	NODE_POS(INDEX1,2) = NODE_POS(INDEX2,2)
	NODE_POS(INDEX2,1) = TEMP_POS
	NODE_POS(INDEX2,2) = TEMP_OFF
C
	RETURN
	END
