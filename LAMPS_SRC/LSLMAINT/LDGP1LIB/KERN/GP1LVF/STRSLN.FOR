C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE STRSLN (SLS)
C                       Slanting of characters
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL*1       GP1ERR
      INTEGER*2       CODE,IROUND
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (1)
      INTEGER*2       LEUNIT
      INTEGER*2       ANUNIT
      REAL*4          SLSTR,SLS
      REAL*4          RAD
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C... constant:
C
      RAD = 0.017453293
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SLSTR  = SLS
      GP1ERR = .FALSE.
C
      IF (ANUNIT .EQ. 0) SLSTR = SLSTR * RAD
      IF (ANUNIT .EQ. 1) SLSTR = SLSTR * RAD * 0.9
C
C... test, whether parameter is in permissible range
C
      IF (SLSTR .LE. 2.1 .AND. SLSTR .GE. 1.0) GOTO 10
C
      GP1ERR = .TRUE.
      CALL MESSAG (35)
      GOTO 30
C
C... plot code, conversion into plotter format
C
10    CONTINUE
      CODE  = 92
      COUNT = 1
C
      NUMBER (1) = IROUND (COS (SLSTR) * 32767.0)
C
C... transmit
C
20    CONTINUE
      CALL SENDGP
C
30    CONTINUE
      RETURN
C
C
      E N D
