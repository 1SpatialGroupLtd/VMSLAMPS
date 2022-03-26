	SUBROUTINE ROTATION_TO_POINT(ROTATE)
C
CDEC$	IDENT	'02NO94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	10-Oct-1994
C
C       MOD 1417. Use SYM_LEN instead of 10 IFF units.	ST	2-Nov-1994
C       This is derived from the scale if present.
C
C Description
C
C	From the only point in the points buffer XYZ and the given angle,
C       this routine will generate a second point at a distance of 1 IFF
C       unit.
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'CMN:GEN.PAR'		! For UNSET_FLAG
C
C Common blocks
C
	INCLUDE	'CMN:IFF.CMN'		! IFF stuff
C
C Arguments
C
	REAL*4		ROTATE		! the orientation in radians
C
C------------------------------------------------------------------------------
C An orientation of zero results in a single point feature
C
	IF (ROTATE.EQ.0.0 .OR. NPTS.EQ.2) GOTO 9000
C
C SYM_LEN holds the length of the vector. This should be 4 sheet millimetres
C if the Map Descriptor scale is available to calculate this or 10 IFF units
C if not.
C
	XYZ(1,NPTS+1) = XYZ(1,NPTS) + (SYM_LEN * COS(ROTATE))
	XYZ(2,NPTS+1) = XYZ(2,NPTS) + (SYM_LEN * SIN(ROTATE))
	FLAGS(1,NPTS+1) = UNSET_FLAG
	FLAGS(2,NPTS+1) = UNSET_FLAG
	NPTS = NPTS + 1
C
C------------------------------------------------------------------------------
C Return
C
9000	RETURN
	END
