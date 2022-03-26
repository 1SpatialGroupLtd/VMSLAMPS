	SUBROUTINE DO_MACRO(INSTR)
C
CDEC$	IDENT	'06OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		11-06-92
C
	IMPLICIT NONE
C
C process a MACRO taken from the input
C Currently this simply outputs the input string via generate_output
C
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
C
	INCLUDE  'HERE:COMMANDS.CMN'
	INCLUDE  'HERE:LCM.CMN'
C
C Arguments
	CHARACTER*(*)	INSTR			!input strings
C
C workspace
	INTEGER		P1, P2			!pointers into string
C
C Functions
	INTEGER		WORD_START
	INTEGER		NAME_END
C
C
C .............................................................................
C	the string will be output anyway so do it
C
	CALL GENERATE_OUTPUT(INSTR)
C
C	........................................................................
C	work out name of macro
C
	P1 = WORD_START(INSTR,1)
	P2 = NAME_END(INSTR,P1)

	IF (P2.GT.0) THEN				!got a name
	  CALL CHECK_NAME(INSTR(P1:P2), MACRO_TREE_PTR)	!was it declared
	  IF (P2.LT.LEN(INSTR)) THEN			!anything left?
	    CALL CHECK_REST(INSTR(P2+1:))		!check rest of line
	  ENDIF
C
	ELSE
	  CALL LCMWARN('Error parsing macro name in previous line')
	ENDIF
C
C .............................................................................
C
	RETURN
	END
