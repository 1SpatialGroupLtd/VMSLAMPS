C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-05 13:33:30.000000000 +0100
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
	SUBROUTINE PROCESS_CMD(INSTR_LEN, INSTR)
C
CDEC$	IDENT	'05OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		10-06-92
C
	IMPLICIT NONE
C
C does the actual processing on the LITES COMMAND line
C
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
C
	INCLUDE  'HERE:COMMANDS.CMN'
	INCLUDE  'HERE:LUNS.PAR'
	INCLUDE  'HERE:FILENAME.CMN'
C
C Arguments
	INTEGER		INSTR_LEN
	CHARACTER*(*)	INSTR			!input strings
C
C Workspace:
	CHARACTER	FIRST_CHAR
C
C .............................................................................
C if we are exploding (ooooer!) output the exploded  line to a file
C
	IF (EXPLODE) THEN
	  CALL FLWSEL(EXPL_LUN)
	  CALL EXPAND('%S',INSTR(1:INSTR_LEN))
	  CALL FLWLIN()
	ENDIF
C
C	.......................................................................
C
	FIRST_CHAR = INSTR(1:1)		!look at the first character
C
	IF (FIRST_CHAR.EQ.'%'.AND.INSTR_LEN.GT.1) THEN
	  CALL DO_LITES2(INSTR(2:INSTR_LEN) )
C
	ELSE IF (FIRST_CHAR.EQ.'@'.AND.INSTR_LEN.GT.1) THEN
	  CALL DO_LCMREF (INSTR(2:INSTR_LEN) )
C
	ELSE IF (FIRST_CHAR.EQ.''''.AND.INSTR_LEN.GT.1) THEN	! ' character
	  CALL DO_CMDSUBS(INSTR(2:INSTR_LEN) )
C
	ELSE IF (FIRST_CHAR.EQ.'.'.AND.INSTR_LEN.GT.1) THEN	! label
	  CALL DO_LABEL(INSTR(2:INSTR_LEN) )
C
	ELSE
	  CALL DO_MACRO(INSTR(1:INSTR_LEN) )
	ENDIF
C
C .............................................................................
C
	RETURN
	END
