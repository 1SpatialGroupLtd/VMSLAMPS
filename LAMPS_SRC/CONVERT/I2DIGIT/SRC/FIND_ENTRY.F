	INTEGER*4 FUNCTION FIND_ENTRY(FC)
C
CDEC$	IDENT	'16OC91'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	12-Dec-1991
C
C Description:
C       Binary chop to get FC of feature in parameter file list
C
C
	IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'GENERAL.CMN'
C
C Arguments
C
	INTEGER*2	FC
C
C Local variables
C
	INTEGER*4	ENTRY,I
C	INTEGER*4	GUESS
C	INTEGER*4	HIGUESS
C	INTEGER*4	LOGUESS
C
C------------------------------------------------------------------------------
C
C A binary chop relies on the parameter file being sorted. If it is not,
C the chop will not work. Hence (for now) we'll just do a linear search.
C This is becuase of time contraints.
C
C	ENTRY = -1		! not found yet
C
C	LOGUESS=1
C	HIGUESS=PARRAY_PTR
C10	GUESS=(HIGUESS+LOGUESS)/2
C	IF(FC.LT.PARRAY(1,GUESS))THEN
C	   HIGUESS=GUESS-1
C	ELSE
C	   LOGUESS=GUESS
C	ENDIF
C	IF(HIGUESS.EQ.LOGUESS)THEN
C	   ENTRY=LOGUESS
C	ELSE IF(HIGUESS.EQ.LOGUESS+1)THEN
C	   IF(PARRAY(1,HIGUESS).GT.FC)THEN
C	      ENTRY=LOGUESS
C	   ELSE
C	      ENTRY=HIGUESS
C	   ENDIF
C	ELSE
C	   GOTO 10
C	ENDIF
C
	ENTRY = UNDEFINED
	DO 50 I = 1,PARRAY_PTR
	   IF (PARRAY(1,I).EQ.FC) THEN
	      ENTRY = I
	      GOTO 100
	   ENDIF
50	CONTINUE
C
100	FIND_ENTRY = ENTRY
C
	RETURN
	END
