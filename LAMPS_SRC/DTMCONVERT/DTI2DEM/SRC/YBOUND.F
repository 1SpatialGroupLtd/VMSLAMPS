	LOGICAL FUNCTION YBOUND (X,YS)
C
CDEC$	IDENT	'25OC89'
C
C	Copyright  		Laser-Scan Ltd., Cambridge, England.
C
C	Author 					RWR	19-Nov-1985
C
C	Modified				APB	25-Oct-1989
C	
C		Updated to use LSLLIB, DTILIB and standard messages
C
C Description:
C 	Function to evaluate y-DOMAIN (YS) at profile (X).
C	assumes DOMAIN has no reentrant sides
C	Returns .FALSE. if there is no intersection
C	YS(2) >= YS(1)
C
	IMPLICIT NONE
C
C Arguments
C
	REAL*8		X		! X coordinate of column
	REAL*8		YS(2)		! where X cuts domain
C
C Common blocks
C
        INCLUDE		'LSL$DTI2DEM:DEMA.CMN'
        INCLUDE		'LSL$DTI2DEM:GENERAL.CMN'
C
C Local variables
C 
 	REAL*8		ZERO
	PARAMETER	(ZERO=0.0D0)
C
	REAL*8		X1,Y1,X2,Y2	! ends of a side of polygon
	REAL*8		Y,CON1,CON2	! distance from X to X1 and X2
C
	INTEGER		I,K
C
C-------------------------------------------------------------------------------
C
	YBOUND = .TRUE.
C
C Start at SE corner (when DEMPOL is 4)
C
	X1 = DOMAIN(1,DEMPOL)
	Y1 = DOMAIN(2,DEMPOL)
	K = 0
C
C Look at each side of polygon in turn
C
	DO 100 I = 1,DEMPOL
	   X2 = DOMAIN(1,I)
	   Y2 = DOMAIN(2,I)
C
C Work out distance from X to ends of line being tested
C
	   CON1 = X - X1
	   CON2 = X - X2
C
C If X cuts this side of polygon, then compute where
C
	   IF (CON1*CON2 .LE. ZERO) THEN
C
C Compute intersection of X with this side of polygon
C
	      IF (CON1.NE.ZERO) THEN	! not coincident with 1st end
	         IF (CON2.EQ.ZERO) THEN	!     coincident with 2nd end
	            Y = Y2
	         ELSE			! not coincident with either end
	            Y = Y1 + CON1 * (Y1 - Y2) / (X1 - X2)
	         ENDIF
	      ELSEIF (CON2.NE.0) THEN	! coincident with 1st, not 2nd
	         Y = Y1
	      ELSE			! vertical side
	         YS(1) = Y1
	         YS(2) = Y2
	         GOTO 200
	      ENDIF
C
C Store this intersection point
C
	      IF (K .EQ. 0) THEN
	         YS(1) = Y
	         K = 1
C
C Store this Y as second point if 
C 1) it is different from one that is already stored
C 2) it is on an extreme vertex; case of vertical sides dealt with above
C
	      ELSEIF (Y.NE.YS(1).OR.X.EQ.MINXDEM.OR.X.EQ.MAXXDEM) THEN
	         YS(2) = Y
	         GOTO 200
	      ENDIF
	   ENDIF
C
C Move onto next polygon side
C
	   X1 = X2
	   Y1 = Y2
  100	CONTINUE
C
	YBOUND = .FALSE.
C
  200	CONTINUE
	IF (YBOUND) THEN
	   Y1=YS(1)
	   Y2=YS(2)
	   YS(1)=MIN(Y1,Y2)
	   YS(2)=MAX(Y1,Y2)
	ENDIF
C
	RETURN
	END