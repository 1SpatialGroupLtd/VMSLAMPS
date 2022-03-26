	SUBROUTINE CHECK_RANGE( X , Y )
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	11-Nov-1990
C
C Description:
C
C	Module CHECK_RANGE called by ARC2I in package CONVERT.
C	Modifies RANGE if X,Y or point lies outside
C	
C-------------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Common blocks
C
	INCLUDE	'HERE:IFFINFO.CMN'		! IFF information
C
C Arguments
C
	REAL	X,Y				! Input coords
C
C-------------------------------------------------------------------------------
C
	IF (X.LT.RANGE(1)) RANGE(1) = X
	IF (X.GT.RANGE(2)) RANGE(2) = X
	IF (Y.LT.RANGE(3)) RANGE(3) = Y
	IF (Y.GT.RANGE(4)) RANGE(4) = Y
C
	RETURN
	END
