	SUBROUTINE CHECK_RANGE(X,Y)
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Oct-1991
C
C Description:
C	Routine to keep track of range for output file.
C
C
        IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'LSL$ICASE:IFFVARS.CMN'         ! IFF information
C
C Arguments
C
	REAL	X,Y				! Input coords
C
C-----------------------------------------------------------------------------
C
	IF (X.LT.RANGE(1)) RANGE(1) = X
	IF (X.GT.RANGE(2)) RANGE(2) = X
	IF (Y.LT.RANGE(3)) RANGE(3) = Y
	IF (Y.GT.RANGE(4)) RANGE(4) = Y
C
	RETURN
	END
