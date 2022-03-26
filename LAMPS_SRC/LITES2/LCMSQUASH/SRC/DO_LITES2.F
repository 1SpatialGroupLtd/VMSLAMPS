	SUBROUTINE DO_LITES2(INSTR)
C
CDEC$	IDENT	'28JA94'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		11-06-92
C
	IMPLICIT NONE
C
C process a LITES2 primary command taken from the input
C Abbreviate the command, and check for LET, DECLARE, MACRO
C
C .....................................................................
C Change history
CMOD WI/CC 1335, avoid abbreviation of WRITE
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
	INTEGER		LENGTH
	INTEGER		VSTART,VEND		!verb starts and ends here
	INTEGER		ASTART			!rest of command (args)
	INTEGER		VLEN
	INTEGER		NSTART,NEND		!name starts and ends here
	CHARACTER*4	VERB
C
C Fn
	INTEGER		WORD_START
	INTEGER		WORD_END
	INTEGER		NEXT_WORD
	INTEGER		NAME_END
	LOGICAL		IS_ALPHA
	INTEGER		STR$CASE_BLIND_COMPARE
C
C .............................................................................
C
	LENGTH = LEN(INSTR)
C
C	........................................................................
C	get the LITES2 Verb from the command line
C
	VSTART = WORD_START(INSTR, 1)
	VEND = NAME_END(INSTR, VSTART)
	ASTART = VEND + 1
C
	VLEN = VEND - VSTART + 1

	IF (VLEN.GT.4) THEN
C
C avoid abbreviation of WRITE - must be given in full
	  IF (STR$CASE_BLIND_COMPARE(INSTR(VSTART:VEND),'WRITE').NE.0) THEN
	    VEND = VSTART + 3
	    VLEN = 4
	  ENDIF
	ENDIF

	IF (VLEN.GT.0) VERB(:VLEN) = INSTR(VSTART:VEND)
C
C	........................................................................
C	Output the command line
C	
	IF (VLEN.EQ.0) THEN
	  CALL GENERATE_OUTPUT('%'//INSTR(ASTART:))
	ELSE
	  IF (ASTART.LE.LENGTH) THEN
	    CALL GENERATE_OUTPUT('%'//VERB(:VLEN)//INSTR(ASTART:))
	  ELSE
	    CALL GENERATE_OUTPUT('%'//VERB(:VLEN))
	  ENDIF
	ENDIF
C
C if no verb, forget this lot
	IF (VLEN.EQ.0) GOTO 100
C
C...............................................................................
C	upper case the verb - for comparisons below
C
	CALL STR$UPCASE(VERB(:VLEN),VERB(:VLEN))
C
C...............................................................................
C	was it a DECLARE or MACRO?
C
	IF (VERB(:VLEN).EQ.'DECL' .OR. VERB(:VLEN).EQ.'DEC') THEN
C
	    IF (VERB(:VLEN).EQ.'DEC') THEN
	      CALL LCMWARN('Abbreviated command found: '//VERB(:VLEN))
	    ENDIF
	    NSTART = NEXT_WORD(INSTR, VEND)	!secondary command
	    IF (NSTART.EQ.0) THEN
		CALL LCMWARN('Secondary command not found in: '//
     &						INSTR(VSTART:))
		ASTART = LENGTH
	    ELSE
		ASTART = NSTART
		NSTART = NEXT_WORD(INSTR, ASTART)	!variable name
		IF (NSTART.EQ.0) THEN
		  CALL LCMWARN('Variable not found in '//INSTR(VSTART:))
		  ASTART = LENGTH
		ELSE
		  NEND = WORD_END(INSTR, NSTART)	   !declared
		  CALL ADD_NAME(INSTR(NSTART:NEND), VAR_TREE_PTR)  !add to tree
		  ASTART = NEND+1
		ENDIF
	    ENDIF
C	    
C	......................................................................
C	found a MACRO
C
	ELSE IF(VERB(:VLEN).EQ.'MACR' .OR. VERB(:VLEN).EQ.'MAC') THEN
	    IF (VERB(:VLEN).EQ.'MAC') THEN
	      CALL LCMWARN('Abbreviated command found: '//VERB(:VLEN))
	    ENDIF
	    NSTART = NEXT_WORD (INSTR, VEND)
	    IF (NSTART.EQ.0) THEN
	      CALL LCMWARN('Name not found for macro: '//INSTR(VSTART:))
	      ASTART = LENGTH
	    ELSE
	      NEND = WORD_END(INSTR, NSTART)
	      CALL ADD_NAME(INSTR(NSTART:NEND), MACRO_TREE_PTR)	!add to tree
	      ASTART = NEND + 1
	    ENDIF
C
C	......................................................................
C	found a LET
C		Look for the start of the new word
C		if non-alpha character found check fo ', $
C
C
	ELSE IF(VERB(:VLEN).EQ.'LET'.OR. VERB(:VLEN).EQ.'LE') THEN
	    IF (VERB(:VLEN).EQ.'LE') THEN
	      CALL LCMWARN('Abbreviated command found: '//VERB(:VLEN))
	    ENDIF
	    NSTART = NEXT_WORD (INSTR, VEND)
	    IF (NSTART.EQ.0) THEN
		CALL LCMWARN ('Variable missing in LET command: '//
     &			INSTR(VSTART:) )
		ASTART = LENGTH
	
	    ELSE
	      IF (INSTR(NSTART:NSTART).EQ.'''') THEN
		CALL LCMWARN ('LET command is self-modifying: '//
     &			INSTR(VSTART:) )
		ASTART = NSTART
	      ELSE IF (INSTR(NSTART:NSTART).EQ.'$') THEN
		CALL LCMWARN ('Attempted change to system variable: '//
     &			INSTR(VSTART:) )
		ASTART = LENGTH
	      ELSE
	        NEND = NAME_END(INSTR, NSTART)
	        IF (NEND.EQ.0) THEN
		  CALL LCMWARN ('Illegal variable name in LET command: '//
     &						INSTR(VSTART:))
	        ELSE
		  CALL CHECK_NAME(INSTR(NSTART:NEND), VAR_TREE_PTR) !check in tree
	        ENDIF
	        ASTART = NEND + 1
	      ENDIF
	    ENDIF
	ENDIF
C
C
C	......................................................................
C	found a JFALSE,JTRUE,JUMP. The argument should be a valid label
C
C	ELSE IF(	(VERB(:VLEN).EQ.'JFAL')
C     &		.OR.	(VERB(:VLEN).EQ.'JTRU')
C		.OR.	(VERB(:VLEN).EQ.'JUMP')) THEN
C
C
C	......................................................................
C	found a THEN,ELSE The args should be a LITES2 primary command
C
C	ELSE IF(	(VERB(:VLEN).EQ.'THEN')
C     &		.OR.	(VERB(:VLEN).EQ.'ELSE')) THEN
C
C	ENDIF
C
C	........................................................................
C	check the rest of the line
C
100	IF (ASTART.LE.LENGTH) THEN
C
C	......................................................................
C	nothing we understand - check it begins with a char
C
	  IF (VLEN.EQ.0) THEN
	    IF(.NOT.IS_ALPHA(INSTR(ASTART:ASTART))) THEN
	      CALL LCMWARN('Unrecognised primary command: '//INSTR(ASTART:))
	    ENDIF
	  ENDIF
	  CALL CHECK_REST(INSTR(ASTART:))
	ENDIF
C
C .............................................................................
C
	RETURN
	END
