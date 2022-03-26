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
