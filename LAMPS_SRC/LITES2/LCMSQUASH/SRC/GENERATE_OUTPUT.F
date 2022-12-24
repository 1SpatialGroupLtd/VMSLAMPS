C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-05-26 11:14:48.000000000 +0100
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
	SUBROUTINE GENERATE_OUTPUT(INSTR)
C
CDEC$	IDENT	'26MY94'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		11-06-92
C
	IMPLICIT NONE
C
C process a LCM REFerence taken from the input
C Currently this simply outputs the input string via generate_output
C
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
C
	INCLUDE  'HERE:LCM.CMN'
	INCLUDE  'HERE:COMMANDS.CMN'
	INCLUDE  'HERE:LUNS.PAR'
	INCLUDE  'HERE:FILENAME.CMN'
C
C Arguments
	CHARACTER*(*)	INSTR			!input strings
C
C Local stuff
	INTEGER		LENGTH
C
C .............................................................................
C if something was in the buffer, check that there is enough space for the 
C command preceeded by a #. If not output the buffer and flush it
C 
	LENGTH = LEN(INSTR)				!length of input

	IF ((LENGTH + LCM_OUT_LEN + 1).GT.MY_BUFSIZ) THEN !not enough space
	  CALL FLUSH()
	ELSEIF (LCM_OUT_LEN.GT.0) THEN			!Enough space in buffer
	  LCM_OUT_LEN = LCM_OUT_LEN + 1			!  increment count
	  LCMBUFFER(LCM_OUT_LEN:LCM_OUT_LEN) = '#'	!  add separator
	ENDIF
C
	LCMBUFFER(LCM_OUT_LEN+1:LCM_OUT_LEN+LENGTH) = INSTR !add string
	LCM_OUT_LEN = LCM_OUT_LEN+LENGTH		!update count
C
C .............................................................................
C
	RETURN
	END

C
C
C-------------------------------------------------------------------------------
C
C
	SUBROUTINE FLUSH()
C
CDEC$	IDENT	'06OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		11-06-92
C
	IMPLICIT NONE
C
C process a LCM REFerence taken from the input
C Currently this simply outputs the input string via generate_output
C
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
C
	INCLUDE  'HERE:LCM.CMN'
	INCLUDE  'HERE:COMMANDS.CMN'
	INCLUDE  'HERE:LUNS.PAR'
	INCLUDE  'HERE:FILENAME.CMN'
C
C Arguments
C
C .............................................................................
	IF (LCM_OUT_LEN.GT.0) THEN
	  IF (CODE) CALL ENCRYPT(E_KEY(:E_KLEN),LCMBUFFER(:LCM_OUT_LEN))
	  CALL FLWSEL(OUT_LUN)			!  select output
	  CALL FLWSTR(LCMBUFFER(:LCM_OUT_LEN))	!  output contents
	  LCM_OUT_LEN = 0			!  reset count
	ENDIF
C
C .............................................................................
C
	RETURN
	END
