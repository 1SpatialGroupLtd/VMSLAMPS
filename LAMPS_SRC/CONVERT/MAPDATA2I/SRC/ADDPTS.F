	SUBROUTINE ADDPTS(NUMPTS,XY,DUMMY)
C
***     IDENT	23SE94
***     MODULE  ADDPTS
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created 					RJH	21-Oct-1986
CMOD	Used in MAPDATA2I to ensure compatibility	ST	20-Sep-1994
C       Mod 1400.
C
C Description
C       Used by COORDLIB to put AKIMA smoothed points into the LINE_OUT array.
C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'($STSDEF)/NOLIST'
C
C Arguments
C
	INTEGER*4	NUMPTS		! number of points
	REAL		XY(2,NUMPTS)	! line string
	LOGICAL*1	DUMMY		! dummy argument
C
C Common Blocks
C
	INCLUDE 'CMN:LINES.CMN'
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'
C
C Local Variables
C
	INTEGER*4	I		! counter
	LOGICAL		OK_SO_FAR	! no blunders ?
C
C------------------------------------------------------------------------------
C Check there have been no errors
C
	OK_SO_FAR = LSL_STATUS .OR. 
     &		((LSL_STATUS .AND. STS$M_SEVERITY) .EQ. STS$K_WARNING)
	IF (OK_SO_FAR) THEN
	   I = 0
C
C While there are still points to add and the output line is not full ..
C
100	   IF ((I .EQ. NUMPTS) .OR. (NUM_OUT .EQ. MAXPTS)) GO TO 200
C
C ... add the next point
C
	   I = I + 1
	   NUM_OUT = NUM_OUT + 1
	   LINE_OUT(1,NUM_OUT) = XY(1,I)
	   LINE_OUT(2,NUM_OUT) = XY(2,I)
	   GO TO 100
C
	ENDIF
C
C------------------------------------------------------------------------------
C Return
C
200	RETURN
	END
