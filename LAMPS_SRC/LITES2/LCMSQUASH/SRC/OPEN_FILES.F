	LOGICAL FUNCTION OPEN_FILES
C
CDEC$	IDENT	'26MY94'
C
C	created 	SG	09-06-92
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C description
C	The function opens the input and output files for LCMSQUASH
C	if error opening the input file the output files are marked for deletion
C	
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'HERE:LCMMSG.PAR'
C
	INCLUDE 'HERE:COMMANDS.CMN'
	INCLUDE 'HERE:FILENAME.CMN'
	INCLUDE 'HERE:LCM.CMN'
	INCLUDE 'HERE:LUNS.PAR'
C
C Functions called
	INTEGER*4	FLROPN		! VIOLIB - opens file
	INTEGER*4	FLWOPN		! VIOLIB - opens file
C
C Local variables
	INTEGER*4	RETCOD		! file I/O error return code
	INTEGER*4	RETVAL
	LOGICAL		OK		! function return
C
C ......................................................................
C
	WIPE_OUTPUT= .TRUE.			! mark file for deletion
	LINE_COUNT = 0
C
C ......................................................................
C
	RETVAL = FLWOPN(OUT_LUN,OUT_FNAME,RETCOD,)	! open output file
	IF (.NOT.RETVAL) THEN
	  CALL LSL_PUTMSG(LCM__FILWOPEN,OUT_FNAME(:OUT_LEN))
	  CALL LSL_ADDMSG(RETVAL)
	  GOTO 999
	ENDIF
C
C write first line to output, if to be encrypted, or a comment
C
	IF (CODE.OR.COMMENTL.GT.0) THEN
	   CALL EXPAND
	   IF (CODE) CALL EXPAND('#%%#%N',E_CODE)
	   IF (COMMENTL.GT.0) CALL APPEND('!%S',COMMENT(:COMMENTL))
	   CALL FLWLIN
	ENDIF
C
	IF (LIST) THEN				! do we want list file
	  RETVAL = FLWOPN(LIST_LUN,LIST_FNAME,RETCOD)
	  IF (.NOT.RETVAL) THEN
	    CALL LSL_PUTMSG(LCM__FILWOPEN,LIST_FNAME(:LIST_LEN))
	    CALL LSL_ADDMSG(RETVAL)
	    GOTO 999
	  ENDIF
	ENDIF
C
	IF (EXPLODE) THEN
	  RETVAL = FLWOPN(EXPL_LUN,EXPL_FNAME,RETCOD)
	  IF (.NOT.RETVAL) THEN
	    CALL LSL_PUTMSG(LCM__FILWOPEN,EXPL_FNAME(:EXPL_LEN))
	    CALL LSL_ADDMSG(RETVAL)
	    GOTO 999
	  ENDIF
	ENDIF
C
	RETVAL = FLROPN(IN_LUN,IN_FNAME,RETCOD)	! open lcm file
	IF (.NOT.RETVAL) THEN
	  CALL LSL_PUTMSG(LCM__FILROPEN,IN_FNAME(:IN_LEN))
	  CALL LSL_ADDMSG(RETVAL)
	  GOTO 999
	ENDIF
C
	WIPE_OUTPUT = .FALSE.		! unmark file for deletion
	CALL FLRSEL(IN_LUN)		! select file for input
C
C ......................................................................
C
999	OPEN_FILES = (RETVAL.EQ.LSL__NORMAL)
	RETURN
	END
