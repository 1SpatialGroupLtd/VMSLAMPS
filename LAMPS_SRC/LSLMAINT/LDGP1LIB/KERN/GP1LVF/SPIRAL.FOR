C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE SPIRAL (XSTART, YSTART, ALFAP, BETAP, RB, RE, IC)
C                       Drawing of circles, spirals and parts thereof
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL*1   GP1ERR
      REAL*4      X1,Y1,X2,Y2
      REAL*4      XSTART,YSTART
      REAL*4      W1,W2
      REAL*4      R1,R2
      REAL*4      RB,RE
      REAL*4      X,Y
      REAL*4      XM,YM
      REAL*4      TX1,TY1
      REAL*4      TX2,TY2
      REAL*4      R
      REAL*4      SIA,COA
      REAL*4      ALFA,ALFAP
      REAL*4      BETA,BETAP
      REAL*4      FAK
      REAL*4      PI,RAD
      INTEGER*2   NUM
      INTEGER*2   FLAG,IC
      INTEGER*2   K
      INTEGER*2   LEUNIT,ANUNIT
C           
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
C
C... constants:
C
      RAD  = 0.01745329
      PI   = 3.14159265
      FAK  = 1.0
      ALFA = 0.08
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      X1   = XSTART
      Y1   = YSTART
      W1   = ALFAP
      W2   = BETAP
      R1   = RB
      R2   = RE
      FLAG = IC
C
C... convert angle into radian measure, eliminate negative radii
C
      IF (ANUNIT .EQ. 0) GOTO 30
      IF (ANUNIT .EQ. 1) GOTO 20
      IF (ANUNIT .EQ. 2) GOTO 40
C
20    W1 = W1 * 0.9
      W2 = W2 * 0.9
C
30    W1 = W1 * RAD
      W2 = W2 * RAD
C
40    R1 = ABS (R1)
      R2 = ABS (R2)
C
C... compute center coordinates
C
      XM = X1 - R1 * COS (W1)
      YM = Y1 - R1 * SIN (W1)
C
C... displacement
C
      TX1 = X1 - XM
      TY1 = Y1 - YM
C
C... amount of points to be computed
C
      R = (R1 + R2) / 2.0
C
      IF (R.LT.0.1) GOTO 70
C
      BETA = W2 - W1
      IF (BETA.LT.0.001) BETA = BETA + 2 * PI
      IF (FLAG.GE.0) GOTO 50
      BETA = 2 * PI - BETA
      IF (BETA.LT.0.001) BETA = BETA + 2 * PI
      ALFA = -ALFA
C
50    CONTINUE
      NUM = INT (ABS (BETA / ALFA))
C
C... compute end point
C
      TX2 = (R2 / R1) * (TX1 * COS (W2 - W1) - TY1 * SIN (W2 - W1))
      TY2 = (R2 / R1) * (TX1 * SIN (W2 - W1) + TY1 * COS (W2 - W1))
      X2  = TX2 + XM
      Y2  = TY2 + YM
C
C... compute values of trigonometric functions and extension factor
C
      SIA = SIN (ALFA)
      COA = COS (ALFA)
      IF (ABS (R2 - R1).GT.0.001) FAK = (R2 / R1) ** (1.0 / FLOAT (NUM))
C
C... compute circle points and convert back
C
      CALL VECTOR (X1,Y1,3)
      IF (GP1ERR) GOTO 70
C
      DO 60   K   = 1,NUM
              X   = FAK * (TX1 * COA - TY1 * SIA)
              Y   = FAK * (TX1 * SIA + TY1 * COA)
              TX1 = X
              TY1 = Y
              X   = X + XM
              Y   = Y + YM
C
              CALL SPLINE (0,X,Y)
              IF (GP1ERR) GOTO 70
C
60    CONTINUE
C
      CALL SPLINE (1,X2,Y2)
C
70    CONTINUE
      RETURN
C
C
      E N D
