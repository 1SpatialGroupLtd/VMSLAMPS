	LOGICAL FUNCTION SPAWN_CMD()
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	13-May-1992
C
C Description:
C
C	Function to SPAWN a DCL command from the text in TXTBUF
C	Command. If argument(s) are missing the user is prompted
C	Function returns .TRUE. if all is well.
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'DCW2IMSG.PAR'
C
C Local worspace
C
	BYTE		CH		! a character
	CHARACTER*128	DCLSTR		! for SPAWN command
	INTEGER		I 		! temp var
	LOGICAL		OK		! function return
C
C Functions
C
	LOGICAL		RDCH		! read from TXTBUF
	LOGICAL		LIB$SPAWN
C
C ......................................................................
C
	I=0
170	IF (RDCH(CH)) THEN
	   GOTO 180
	ELSE	
	   I=I+1
	   DCLSTR(I:I)=CHAR(CH)
	   GOTO 170
	ENDIF
C
180	IF (I.EQ.0) THEN
	   CALL LSL_PUTMSG(DCW2I__DCL)
	   CALL WRITEF
	   SPAWN_CMD=.FALSE.
	   GOTO 20
	ENDIF
C
	OK=LIB$SPAWN(DCLSTR(1:MIN(I,80)))
	IF (OK) THEN
	   SPAWN_CMD=.TRUE.
	ELSE
	   CALL LIB$STOP(%VAL(OK)) !error
	   CALL LSL_PUTMSG(DCW2I__CANTSPAWN)
	   CALL LSL_ADDMSG(OK)
	   CALL WRITEF
	   SPAWN_CMD=.FALSE.
	ENDIF
20	RETURN
	END
