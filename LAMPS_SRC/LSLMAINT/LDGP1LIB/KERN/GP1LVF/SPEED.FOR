C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE SPEED (IV)
C                      Change of speed
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL*1       GP1ERR
      INTEGER*2       CODE
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (1)
      INTEGER*2       LEUNIT
      INTEGER*2       ANUNIT
      INTEGER*2       VELOC,IV
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      VELOC  = IV
      GP1ERR = .FALSE.
C
C... test, whether parameter is in permissible range
C
      IF (VELOC .LT. 1 .OR. VELOC .GT. 9) GOTO 10
C
C... plot code
C
      CODE  = 110
      COUNT = 1
C
      NUMBER (1) = VELOC
C
C... transmit
C
      CALL SENDGP
      GOTO 20
C
10    CONTINUE
      GP1ERR = .TRUE.
      CALL MESSAG (44)
C
20    CONTINUE
      RETURN
C
C
      E N D
