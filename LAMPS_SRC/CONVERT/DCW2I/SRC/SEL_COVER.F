	LOGICAL FUNCTION SEL_COVER(SELECT)
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	13-May-1992
C
C Description:
C
C	Function to read a list of coverages from the command line and
C       select them or deselect them according to the value of the logical
C       argument
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common blocks
C
	INCLUDE 'SELECTIONS.CMN'
C
C Arguments
C
	LOGICAL		SELECT
C
C Local workspace
C
	INTEGER*4	I			! loop controls.
	BYTE		COMMA			! ASCII constant
	PARAMETER	(COMMA=44)
	BYTE		TMP_SEL(NUM_COVERAGES)	! temporary selections
	CHARACTER*255	TMP
	LOGICAL		MATCH
	INTEGER*4	LEN
	INTEGER*4	RETVAL
	INTEGER*4	ONOFF
C
C Functions
C
	LOGICAL		RDCHS,RDCH
	INTEGER*4	READSTR
	INTEGER*4	SIGCHS
C
C***********************************************************************
C
	SEL_COVER=.TRUE.			! assume success
	MATCH = .FALSE.
	IF (SELECT) THEN
	   ONOFF = 1
	ELSE
	   ONOFF = -1
	ENDIF
C
C Fill string with blanks so that SIGCHS can find the end
C
10	DO 20 I = 1, 255
	   TMP(I:I) = CHAR(32)
20	CONTINUE
C
C Read up to each comma or end of line
C
	LEN = READSTR(TMP,COMMA,,.TRUE.,RETVAL)
	LEN = SIGCHS(TMP)
C
C Upper case the string
C
	CALL STR$UPCASE(TMP,TMP)
C
C Check for sillies
C
	IF (LEN.EQ.0) GOTO 50
	IF (LEN.EQ.1) THEN
	   CALL LSL_PUTMSG(DCW2I__TWOCHARS,'coverage')
	   GOTO 999
	ENDIF
C
C Deselect or Select ALL
C
	IF (LEN.EQ.3.AND.TMP(1:3).EQ.'ALL') THEN
	   DO 35 I = STARTPOS,ENDPOS
		 COVER_SEL(I) = ONOFF
35	   CONTINUE
	   CALL SHOW_SEL(3)
	   GOTO 1000
	ENDIF
C
C Coverage name too long?
C
	IF (LEN.GT.2) THEN
	   CALL LSL_PUTMSG(DCW2I__TWOCHARS,'coverage')
	   GOTO 999
	ENDIF
C
C We have one or more individual coverages. Find it in the list
C
	MATCH = .FALSE.
	DO 40 I = STARTPOS,ENDPOS
	   IF (COVERAGE(I)(1:2).EQ.TMP(1:2)) THEN
	      MATCH = .TRUE.
	      TMP_SEL(I) = ONOFF
	      GOTO 45
	   ENDIF
40	CONTINUE
45	IF (.NOT.MATCH) THEN
	   CALL LSL_PUTMSG(DCW2I__COVINVALID,TMP(1:LEN),LIB_NAME(LIBRARY))
	   GOTO 999
	ENDIF
C
C End of line
C
50	IF (RETVAL.EQ.LSL__STREOL) THEN
C
C If any were found, save the selections
C
	   IF (MATCH) THEN
	      DO 60 I = STARTPOS,ENDPOS
		 IF (TMP_SEL(I).NE.0) COVER_SEL(I) = TMP_SEL(I)
60	      CONTINUE
	      CALL SHOW_SEL(3)
	   ELSE
C
C Otherwise complain
C
	      CALL LSL_PUTMSG(DCW2I__NONAME,'coverage')
	      GOTO 999
	   ENDIF
	   GOTO 1000
	ENDIF
C
C Read upto next comma
C
	GOTO 10
C
C
C***********************************************************************
C
C Errors
C
999	CALL WRITEF
	SEL_COVER=.FALSE.		! reject the rest of the command line.
1000	RETURN
C
	END
