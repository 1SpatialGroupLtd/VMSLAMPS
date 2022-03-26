	SUBROUTINE USRGTX(TEXT,TEXTL,TS,HEIGHT,ROTAT,AUX)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Example user routine
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
					! 0.01mm
	REAL*4		AUX(8)		! data about text (in IFF units)
					! AUX(1) = angle (in radians)
					! AUX(2) = cosine of angle
					! AUX(3) = sine of angle
					! AUX(4) = height (in IFF units)
					! AUX(5) = minimum X value 
					!         (rel to locating point)
					! AUX(6) = maximum X value
					! AUX(7) = minimum Y value 
					! AUX(8) = maximum Y value
C
C working storage
C
	INCLUDE	'USRKEEP.CMN'
	INCLUDE 'USRFEAT.CMN'
C
	INTEGER*4	I		! loop counter
	REAL		PI
	PARAMETER	(PI = 3.141592654)
C
C switch on number  of USER routine
C
	GOTO (9000,200,9000,9000,9000,9000,700,700,9000) USR_ACTION
	GOTO 9000
C
C listing details of feature
C
  200	CONTINUE
C
C output the text
C
	PRINT 230,TEXT(1:TEXTL),180.0*ROTAT/PI,HEIGHT,(USR_FC(I),I=1,4),
     &	          (AUX(I),I=1,8)
  230	FORMAT(' Text: "',A,'" - at ',F7.3,' deg'/' height ',I4,
     &	       ' Text status ',4(I5,2X)/' Aux - ',8(F8.3)/)
C
C get more points
	GOTO 9999
C
C get and store feature
  700	CONTINUE
	IF (NHTXTS+1.GT.NUMTXTS) THEN
	   PRINT 710
  710	   FORMAT(' Tried to store too many texts' /)
	ELSE
C
	   NHTXTS = NHTXTS + 1
	   FEATXT(NHTXTS)  = TEXT
	   FEATXTL(NHTXTS) = TEXTL
	   FEATTXRO(NHTXTS) = ROTAT
	   FEATTXHT(NHTXTS) = HEIGHT
	   DO 720, I=1,4
	      FEATTXTS(I,NHTXTS) = TS(I)
  720	   CONTINUE
	ENDIF
	GOTO 9999
C
C invalid action
C
 9000	CONTINUE
	PRINT 9010,USR_ACTION
 9010	FORMAT(' Unknown action',I6,' for user routine USRGTX'//
     &	       ' User routine being aborted'/)
C
 9999	CONTINUE
	RETURN
	END
