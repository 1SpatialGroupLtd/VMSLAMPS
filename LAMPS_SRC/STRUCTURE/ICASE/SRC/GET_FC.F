	SUBROUTINE GET_FC(ADDR,FC)
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	14-Oct-1991
C
C Description:
C       Binary chop to get FC of feature, given the address of its ST entry.
C
C
	IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
C
	INTEGER*4	ADDR
	INTEGER*2	FC
C
	INTEGER*4	GUESS
	INTEGER*4	HIGUESS
	INTEGER*4	LOGUESS
C
C------------------------------------------------------------------------------
C
	LOGUESS=1
	HIGUESS=STWIDPTR
10	GUESS=(HIGUESS+LOGUESS)/2
	IF(ADDR.LT.STINFO(1,GUESS))THEN
	   HIGUESS=GUESS-1
	ELSE
	   LOGUESS=GUESS
	ENDIF
	IF(HIGUESS.EQ.LOGUESS)THEN
	   FC=STINFO(2,LOGUESS)
	ELSE IF(HIGUESS.EQ.LOGUESS+1)THEN
	   IF(STINFO(1,HIGUESS).GT.ADDR)THEN
	      FC=STINFO(2,LOGUESS)
	   ELSE
	      FC=STINFO(2,HIGUESS)
	   ENDIF
	ELSE
	   GOTO 10
	ENDIF
C
	RETURN
	END
