	SUBROUTINE CHAR_CHECK(FSN,STRLEN,STR)
C
CDEC$	IDENT	'22MY92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	22-Sept-1992
C
C Description:
C
C       Routine to check the input string for special characters so that a
C       report can be made at the end of processing. This is so that strange
C       characters can be added to the TRI file .
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
C
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
C
C Arguments
C
	BYTE		STR(*)		! the input string
	INTEGER*4	STRLEN		! the string length
	INTEGER*2	FSN		! the FSN in case of error
C
C Local workspace
C
	BYTE		TESTCH		! the character to check
	INTEGER*4	I,J,K		! counter
	LOGICAL*4	MATCH		! already in list?
C
C ......................................................................
C
	DO 300 I = 1,STRLEN
	   TESTCH = STR(I)
	   IF (TESTCH.GT.127) THEN
	      CALL LSL_PUTMSG(DCW2I__8BITASCII,FSN)
	   ELSEIF (TESTCH.EQ.27 .OR. TESTCH.EQ.14 .OR. TESTCH.EQ.15) THEN
	      CALL LSL_PUTMSG(DCW2I__CODEXT,FSN)
	   ENDIF
300	CONTINUE
C
C ......................................................................
C
999	RETURN
	END
