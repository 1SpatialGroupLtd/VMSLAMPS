	SUBROUTINE GET_WIDTH(ADDR,WID,NUM)
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	14-Oct-1991
C
C Description:
C       Binary chop to get width of feature, given the address of its ST entry.
C       The argument number selects which width we want, casing or fill.
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
C
	INTEGER*4	ADDR
	REAL*4		WID
	INTEGER*4	NUM    ! 1 is case width, 2 is area width
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
	   WID=STWID(NUM,LOGUESS)
	ELSE IF(HIGUESS.EQ.LOGUESS+1)THEN
	   IF(STINFO(1,HIGUESS).GT.ADDR)THEN
	      WID=STWID(NUM,LOGUESS)
	   ELSE
	      WID=STWID(NUM,HIGUESS)
	   ENDIF
	ELSE
	   GOTO 10
	ENDIF
C
	RETURN
	END
