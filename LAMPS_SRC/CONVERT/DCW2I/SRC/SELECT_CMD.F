	LOGICAL FUNCTION SELECT_CMD(SELECT)
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	13-May-1992
C
C Description:
C
C	Function to set coverage, GEOREF and library selections.
C	Use in conjunction with function DESELECT for turning selections
C	off again. 
C	Function returns .TRUE. if all is well, .FALSE. if an error
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
C
C Functions
C
	LOGICAL 	SEL_COVER	! (de)select coverages
	LOGICAL 	SEL_GEOREF	! (de)select GEOREFs
	LOGICAL 	RDCOMM  	! read command from line
C
C Command table
C
	EXTERNAL	SELECT_CMD_TABLE
	INTEGER		SELECT_CMD_TABLE
	EXTERNAL	CLASS_CMD_TABLE
	INTEGER		CLASS_CMD_TABLE
	EXTERNAL	LIBRARY_CMD_TABLE
	INTEGER		LIBRARY_CMD_TABLE
C
C Arguments
C
	LOGICAL		SELECT
C
C Local workspace
C
	INTEGER*4	CMD     	! decoded command number
	INTEGER*4	I	     	! loopy
	CHARACTER*8	STR		! name of command
	INTEGER*4	STRLEN		! length of STR
	INTEGER*4	ST		! window on COVER_SEL
	INTEGER*4	END		! window on COVER_SEL
C
C ......................................................................
C
	SELECT_CMD=.TRUE.		! assume success
C
C Note command name
C
	IF (SELECT) THEN
	   STRLEN = 6
	   STR(1:STRLEN) = 'SELECT'
	ELSE
	   STRLEN = 8
	   STR(1:STRLEN) = 'DESELECT'
	ENDIF
C
	CMD=RDCOMM(SELECT_CMD_TABLE)	! get command
C
C Branch to deal with each sub command
C
	GOTO (
     &		10,	! nothing/error
     &		15,	! CLASS
     &		20,	! COVERAGES
     &		30,	! GEOREF
     &		40	! LIBRARY
     &			), CMD+1
C
C command number out of range
C
	SELECT_CMD=.FALSE.
	GOTO 999
C
C ......................................................................
C Error
10	CALL WRITEF
	CALL WRITEF('Available %S command qualifiers are:',STR(1:STRLEN))
	CALL WRITEF
	CALL WRITEF('COVERAGES  GEOREF  LIBRARY')
	CALL WRITEF
	SELECT_CMD=.FALSE.
	GOTO 999
C
C ......................................................................
C SELECT CLASS command
C
15	CMD=RDCOMM(CLASS_CMD_TABLE)		! get command
C
C Check library sub command
C
	IF (CMD.GT.0.AND.CMD.LE.5) THEN
	   IF (CMD.EQ.1 .OR. CMD.EQ.2) WANT_AREAS  = SELECT
	   IF (CMD.EQ.1 .OR. CMD.EQ.3) WANT_LINES  = SELECT
	   IF (CMD.EQ.1 .OR. CMD.EQ.4) WANT_POINTS = SELECT
	   IF (CMD.EQ.1 .OR. CMD.EQ.5) WANT_TEXT   = SELECT
	   WANT_ALL_CLASSES = (WANT_AREAS  .AND. WANT_LINES .AND.
     &		               WANT_POINTS .AND. WANT_TEXT)
	   CALL SHOW_SEL(5)
	   SELECT_CMD=.TRUE.
	ELSE
	   CALL WRITEF
	   CALL WRITEF('Available %S CLASS command qualifiers are:',
     &		        STR(1:STRLEN))
	   CALL WRITEF
	   CALL WRITEF('ALL  AREAS  LINES  POINTS  TEXT')
	   CALL WRITEF
	   SELECT_CMD=.FALSE.
	ENDIF
	GOTO 999
C
C ......................................................................
C SELECT COVERAGE command
C
20	HAD_SEL_COV = .FALSE.
	SELECT_CMD=.FALSE.
	IF (HAD_SEL_LIB) THEN
	   IF (SEL_COVER(SELECT)) THEN
	      HAD_SEL_COV = .TRUE.
	      SELECT_CMD=.TRUE.
	   ENDIF
	ELSE
	   CALL LSL_PUTMSG(DCW2I__GIVELIB)
	   CALL WRITEF
	ENDIF
	GOTO 999
C
C ......................................................................
C SELECT GEOREF
C
30	HAD_SEL_GEO = .FALSE.
	SELECT_CMD=.FALSE.
	IF (LIBRARY.EQ.BROWSE) THEN
	   CALL LSL_PUTMSG(DCW2I__NOGEOS)
	   CALL WRITEF	   
	ELSE
	   IF (SEL_GEOREF(SELECT)) THEN
	      HAD_SEL_GEO = .TRUE.
	      SELECT_CMD = .TRUE.
	   ENDIF
	ENDIF
	GOTO 999
C
C ......................................................................
C SELECT LIBRARY command
C
40	CMD=RDCOMM(LIBRARY_CMD_TABLE)		! get command
C
C Check library sub command
C
	IF (CMD.GT.0.AND.CMD.LE.NUM_LIBS) THEN
C
C Set maximum window on selection array
C
	   STARTPOS = 1
	   ENDPOS = NUM_COVERAGES
C
C Check if we are selecting a library with a different set of coverages, remove
C the old ones
C
	   IF (SELECT) THEN
	      LIBRARY = CMD
	      IF (LIBRARY.EQ.BROWSE) THEN
		 STARTPOS = BROWSE_COVER_POS
		 ST  = 1
		 END = STARTPOS-1
	      ELSE
		 ENDPOS = BROWSE_COVER_POS-1
		 ST  = BROWSE_COVER_POS
		 END = NUM_COVERAGES
	      ENDIF
	      HAD_SEL_LIB = .TRUE.
	   ELSE
	      IF (LIBRARY.EQ.CMD) THEN
		 LIBRARY = 0
		 ST = 1
		 END = NUM_COVERAGES
		 HAD_SEL_LIB = .FALSE.
	      ELSE
		 CALL LSL_PUTMSG(DCW2I__LIBNOTSEL)
		 CALL WRITEF
		 GOTO 999
	      ENDIF
	   ENDIF
C
	   DO 45 I = ST,END
	      COVER_SEL(I)= 0
45	   CONTINUE
	   CALL SHOW_SEL(2)
C
	ELSE
	   CALL WRITEF
	   CALL WRITEF('Available %S LIBRARY command qualifiers are:',
     &		        STR(1:STRLEN))
	   CALL WRITEF
	   CALL WRITEF('BROWSE  EURNASIA  NOAMER  SASAUS  SOAMAFR')
	   CALL WRITEF
	   SELECT_CMD=.FALSE.
	ENDIF
C
C ......................................................................
C
999	RETURN
	END
