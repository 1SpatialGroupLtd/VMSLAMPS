	LOGICAL FUNCTION PROCESS_BUFFER
C
CDEC$	IDENT	'08OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		9-06-92
C
	IMPLICIT NONE
C
C Utility to compress LITES2 command macros into a more compact form.
C It does this by:
C	removing comments
C	compressing lines
C	shortening LITES2 commands to 4 characters
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
C
	INCLUDE  'HERE:LCM.CMN'
	INCLUDE  'HERE:FILENAME.CMN'
	INCLUDE  'HERE:LUNS.PAR'
	INCLUDE  'HERE:COMMANDS.CMN'
C
C Functions:
C
	INTEGER		RDSTRING
	INTEGER		FIND_DELIM
C
C Workspace:
	INTEGER		OK			! Function return
	CHARACTER*(MY_BUFSIZ)	INSTR
	CHARACTER*(MY_BUFSIZ)	CMDSTR
	INTEGER		INSTR_LEN, INSTR_PTR
	INTEGER		CMDSTR_LEN, CMDSTR_PTR
	INTEGER		TMP_LEN
C
C .............................................................................
C
	OK = .TRUE.
	INSTR_PTR = 1
	CMDSTR_PTR = 1
C
C ..............................................................................
C first lets get an actual string.. I hate byte arrays. If /LIST was used,
C output the string that we read. It will be followed by diagnostic messages
C
	INSTR_LEN = RDSTRING(INSTR)

	IF (LIST) THEN
	  CALL FLWSEL(LIST_LUN)
	  CALL EXPAND('%I   %S',LINE_COUNT,INSTR(:INSTR_LEN))
	  CALL FLWLIN()
	ENDIF
C
C	------------------------------------------------------------------------
C	Yes this is a WRITEF.. You want to make it into a LSL_PUTMSG then DIY.
C	I think that there is too much information here for LSLPUTMSG to display
C	sensibly. The object here is to get a listing file lookalike.
C
	IF (LOG) THEN
	  CALL WRITEF('%I   %S',LINE_COUNT,INSTR(:INSTR_LEN))
	ENDIF
C
C...............................................................................
C	look for the comment character "!" and truncate the line to the
C	character before it
C
	TMP_LEN = FIND_DELIM('!', INSTR(:INSTR_LEN), 1) - 1
	IF (TMP_LEN.GE.0) INSTR_LEN = TMP_LEN
C
C...............................................................................
C	while no more commands can be read from the line read and process
C	you can change the DO WHILES into labels and GOTOs.. but who'd want to?
C
	OK = .TRUE.				!I know it is but just in case
	DO  WHILE (INSTR_PTR.LE.INSTR_LEN)
	  CALL GET_CMD(INSTR_PTR, INSTR_LEN,INSTR, CMDSTR_LEN, CMDSTR) !get cmd
	  OK = CMDSTR_LEN.GT.0					! did it exist
	  IF (OK) THEN						! yup
	    CALL PROCESS_CMD(CMDSTR_LEN,CMDSTR(:CMDSTR_LEN))	! process it
	  ENDIF							
	END DO							! next
C
C...............................................................................
C
	PROCESS_BUFFER = OK
	RETURN
	END
