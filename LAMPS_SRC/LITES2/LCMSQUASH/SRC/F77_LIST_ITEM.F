C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-05 16:05:10.000000000 +0100
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
	SUBROUTINE F77_LIST_ITEM(INSTR)
C
CDEC$	IDENT	'05OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		14-06-92
C
	IMPLICIT NONE
C
C Always output a message to the listing file.
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
	INCLUDE 'HERE:COMMANDS.CMN'
	INCLUDE 'HERE:LUNS.PAR'
C
C Arguments
	CHARACTER*(*)	INSTR
C
C Functions
C
C..............................................................................
C
	IF (LIST) THEN					!is there a list file?
	  CALL EXPAND('%T%T%S',INSTR)			!make up warning
	  CALL FLWSEL(LIST_LUN)				! select it
	  CALL FLWLIN()					! output data
	ENDIF
C
C..............................................................................
C
	RETURN
	END
