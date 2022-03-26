C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      INTEGER FUNCTION IROUND (X)
C                             Round Numbers
C=====================================================================

      IMPLICIT NONE

C... variables
C
      REAL*4   PSIGN,X
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PSIGN = 1.0
      IF (X .LT. 0.0) PSIGN = -1.0
      X = X + PSIGN * 0.5
      IF (X .GT.  32766.0) X = 32766.0
      IF (X .LT. -32766.0) X = -32766.0
      IROUND = INT (X)
C
      RETURN
C
C
      E N D
