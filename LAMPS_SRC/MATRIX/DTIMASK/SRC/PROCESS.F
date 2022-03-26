	SUBROUTINE PROCESS(VAL,SIZE,INPUT,OUTPUT)
C
CDEC$	IDENT	'17JN91'
C
C Copyright Laser-Scan Laboratories Limited, Cambridge, England.
C
C	Created					CCB 	17-Jun-1991
C
	IMPLICIT NONE
C
C arguments
	INTEGER	VAL			! data value
	INTEGER	SIZE			! array size
	BYTE	INPUT(*)		! input array
	BYTE	OUTPUT(*)		! output array
C
C workspace
	INTEGER	LVAL
	BYTE	BVAL
	EQUIVALENCE (LVAL,BVAL)
	INTEGER	I
C
	LVAL = VAL
C
	DO 10 I=1,SIZE
	   IF (INPUT(I).NE.0) OUTPUT(I) = BVAL
10	CONTINUE
C
	RETURN
	END
