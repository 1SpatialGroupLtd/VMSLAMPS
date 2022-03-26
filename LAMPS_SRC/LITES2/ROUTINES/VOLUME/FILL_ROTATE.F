	SUBROUTINE FILL_ROTATE(ANGLE,XX,YY)
C
CDEC$	IDENT	'15MY91'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author CC Brunt, 11 February 1991
C
C This subroutine rotates the given X and Y coordinates by ANGLE
C It replaces the old ROT45
C
	IMPLICIT NONE
C
C arguments
C
	REAL		ANGLE		! angle to rotate by
	REAL		XX,YY		! coordinates to rotate
C
C workspace
C
	REAL		OLDANG,SINANG,COSANG
	SAVE		OLDANG,SINANG,COSANG
	DATA		OLDANG,SINANG,COSANG/0.0,0.0,1.0/
	REAL		SAVX		! preserve XX
C
C get new SIN and COS if required
C
	IF (ANGLE.NE.OLDANG) THEN
	   OLDANG = ANGLE
	   SINANG = SIN(OLDANG)
	   COSANG = COS(OLDANG)
	ENDIF
C
C preserve the original value of XX
C
	SAVX = XX
C
C now rotate
C
	XX = SAVX*COSANG - YY*SINANG
	YY = SAVX*SINANG + YY*COSANG
C
	RETURN
	END
