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
