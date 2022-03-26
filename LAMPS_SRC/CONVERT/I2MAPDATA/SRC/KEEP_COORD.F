	LOGICAL FUNCTION KEEP_COORD(CURVE_FLAG)
C
CDEC$	IDENT	'10OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	10-Oct-1994
C
C	CONVERT I2MAPDATA Utility
C
C Description
C
C	Checks if the current point is to be kept based on the whether curve
C	flag is curved, unset or interpolated. The validity of the flag has
C	already been checked by CHECK_FLAG.
C
	IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	CURVE_FLAG	! the curve flag as an int
C
C------------------------------------------------------------------------------
C
	KEEP_COORD = CURVE_FLAG.NE.'I   '
C
	RETURN
	END
