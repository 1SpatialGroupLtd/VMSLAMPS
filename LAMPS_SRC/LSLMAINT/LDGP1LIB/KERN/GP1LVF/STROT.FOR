C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE STROT (RS)
C                      Rotation of text line
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL*1       GP1ERR
      INTEGER*2       CODE,IROUND
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (2)
      INTEGER*2       LEUNIT
      INTEGER*2       ANUNIT
      REAL*4          RSTR,RS
      REAL*4          RAD,TWOPI
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C... constant:
C
      RAD   = 0.017453293
      TWOPI = 6.2831854
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      RSTR   = RS
      GP1ERR = .FALSE.
C
      IF (ANUNIT .EQ. 0) RSTR = RSTR * RAD
      IF (ANUNIT .EQ. 1) RSTR = RSTR * RAD * 0.9
C
C... test, whether parameter is in permissible range
C
      IF (ABS (RSTR) .LT. TWOPI) GOTO 10
      GP1ERR = .TRUE.
      CALL MESSAG (34)
      GOTO 20
C
C... plot code, conversion into plotter increments
C
10    CODE  = 91
      COUNT = 2

      NUMBER (1) = IROUND (SIN (RSTR) * 32767.0)
      NUMBER (2) = IROUND (COS (RSTR) * 32767.0)
C
C... transmit
C
      CALL SENDGP
C
20    CONTINUE
      RETURN
C
C
      E N D
