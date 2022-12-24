C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-06 15:53:26.000000000 +0100
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
	SUBROUTINE LCMWARN(INSTR)
C
CDEC$	IDENT	'06OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		14-06-92
C
	IMPLICIT NONE
C
C Always output a message, and if needed do one to the listing file.
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
	INCLUDE 'HERE:LCM.CMN'
	INCLUDE 'HERE:COMMANDS.CMN'
	INCLUDE 'HERE:FILENAME.CMN'
	INCLUDE 'HERE:LUNS.PAR'
	INCLUDE 'HERE:LCMMSG.PAR'
C
C Arguments
	CHARACTER*(*)	INSTR
C
C Functions
C
C..............................................................................
C
	IF (LIST) THEN					!is there a list file?
	  CALL FLWSEL(LIST_LUN)				! select it
	  CALL FLWSTR('% '//INSTR)			! output data
	ENDIF
C
C	........................................................................
C 	lslputmsgs (bleughh!) HAVE to be used.. for all terminal output

	IF (.NOT.QUIET) THEN
	  CALL LSL_PUTMSG(LCM__WARN,INSTR)
	ENDIF
C
C..............................................................................
C
	RETURN
	END
