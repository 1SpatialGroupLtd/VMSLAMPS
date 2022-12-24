C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-06 15:53:24.000000000 +0100
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
	SUBROUTINE GET_CMD(IN_PTR, IN_LEN, IN, OUT_LEN,  OUT)
C
CDEC$	IDENT	'06OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		10-06-92
C
	IMPLICIT NONE
C
C gets the first LITES2 executable command and returns it in OUT
C sets a pointer to the start of the next command in that line
C
C Effectively splits a compressed command into bits
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
C
	INCLUDE  'HERE:COMMANDS.CMN'
C
C Arguments
	INTEGER		IN_PTR			!pointer where to start looking
	INTEGER		IN_LEN
	INTEGER		OUT_LEN
	CHARACTER*(*)	IN			!input strings
	CHARACTER*(*)	OUT			!output
C
C Workspace:
	INTEGER		STA_PTR, END_PTR	!pointers into string
	LOGICAL		DONE
C
C Funs
	INTEGER		WORD_START
	INTEGER		WORD_END
	INTEGER		FIND_DELIM
	INTEGER		BACK_WORD_END
C
C .............................................................................
C Initialise
C
	STA_PTR = IN_PTR			! pointer to start of command
	END_PTR = IN_PTR			! pointer to end of command
	OUT_LEN = 0
	END_PTR = FIND_DELIM('#', IN(1:IN_LEN), STA_PTR) !find #
	IF (END_PTR.LE.0) THEN		! no #
	   END_PTR = IN_LEN
	   IN_PTR = IN_LEN+1		! past end of line
	ELSE
	   IN_PTR = END_PTR+1		! after #
	   END_PTR = END_PTR-1		! before #
	ENDIF
C
C so now IN_PTR is pointing to start of next command
C STA_PTR:END_PTR is a window onto this command
C
C .............................................................................
C copy the command without leading and trailing spaces
C
	IF (END_PTR.GE.STA_PTR) THEN
C
C 	  ......................................................................
C	  find the start and end of the command
C
	  STA_PTR = WORD_START( IN(:END_PTR), STA_PTR)	!find first non-blank
C
C 	  ......................................................................
C	  strip trailing spaces
C
	  END_PTR = BACK_WORD_END(IN(:END_PTR),END_PTR)
C
C 	  ......................................................................
C	  copy the parts of the input string that forms a LITES command
C
	  IF (STA_PTR.GT.0.AND.END_PTR.GE.STA_PTR) THEN	! copy part of string
	    OUT_LEN = END_PTR - STA_PTR + 1
	    OUT(:OUT_LEN) = IN(STA_PTR:END_PTR)
	  ENDIF
C
	ENDIF
C
C .............................................................................
C
	RETURN
	END
