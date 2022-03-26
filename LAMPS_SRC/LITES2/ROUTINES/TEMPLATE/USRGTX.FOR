	SUBROUTINE USRGTX(TEXT,TEXTL,TS,HEIGHT,ROTAT,AUX)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines.
C	Dummy user routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	TEXTL		! number of characters in TEXT
	CHARACTER*(*)	TEXT		! text string, if text feature
	INTEGER*4	TS(4)		! text component status
	REAL		ROTAT		! rotation of text component
	INTEGER*4	HEIGHT		! height of text (in points or
					! 0.01mm)
	REAL*4		AUX(8)		! data about text (in IFF units)
					! AUX(1) = angle (in radians)
					! AUX(2) = cosine of angle
					! AUX(3) = sine of angle
					! AUX(4) = height (in IFF units)
					! AUX(5) = minumum X value 
					!         (rel to locating point)
					! AUX(6) = maximum X value
					! AUX(7) = minimum Y value 
					! AUX(8) = maximum Y value
C
C this is a dummy routine that does nothing
C
	RETURN
	END
