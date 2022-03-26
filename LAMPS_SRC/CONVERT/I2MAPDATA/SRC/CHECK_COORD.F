	SUBROUTINE CHECK_COORD(COORD)
C
CDEC$	IDENT	'10OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	10-Oct-1994
C
C	CONVERT I2MAPDATA Utility - Check coordinate
C
C Description
C
C	Checks an ordinate to see if it is absent
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE	'CMN:IFF.CMN'		! IFF stuff
C
C Arguments
C
	REAL*4		COORD		! the IFF ordinate value
C
C Local variables
C
	REAL*4		RCOORD		! local copy of COORD
	INTEGER*4	ICOORD		! local integer version of COORD
	EQUIVALENCE	(ICOORD,RCOORD)	! to check against IFF_ABSENT
C
C------------------------------------------------------------------------------
C
C Make a local copy of the argument as we need to check for IFF_ABSENT.
C IFF_ABSENT is an int and we can't equivalence this int on the argument -
C only the copy.
C
	RCOORD = COORD
C
C Check it for absence
C
	IF (ICOORD.EQ.IFF_ABSENT) COORD = 0.0
C
C Return
C
	RETURN
	END
