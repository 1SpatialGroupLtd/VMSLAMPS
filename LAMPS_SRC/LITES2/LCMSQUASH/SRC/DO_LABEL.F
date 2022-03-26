	SUBROUTINE DO_LABEL(INSTR)
C
CDEC$	IDENT	'05OC92'
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
	INCLUDE  'HERE:COMMANDS.CMN'
	INCLUDE  'HERE:LCM.CMN'
C
C Arguments
	CHARACTER*(*)	INSTR			!input strings
C
C Work space
	INTEGER		START
C
C Fns
	INTEGER		WORD_START
C
C .............................................................................
C
	START = WORD_START(INSTR,1)
C	
	CALL GENERATE_OUTPUT('.'//INSTR(START:))
C
C .............................................................................
C
	RETURN
	END
