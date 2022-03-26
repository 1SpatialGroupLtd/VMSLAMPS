C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE CHDIS (ICHDI)
C                       Change Character Distance
C=====================================================================

      IMPLICIT NONE

C... variables:
C
      LOGICAL*1       GP1ERR
      INTEGER*2       CODE
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (1)
      INTEGER*2       LEUNIT
      INTEGER*2       ANUNIT
      INTEGER*2       NUMPEN,ICHDI
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      GP1ERR = .FALSE.
C
C... test, whether parameter is in permissible range
C
      IF (ICHDI .GT. 20 .OR. ICHDI .LT. -20) GOTO 10
C
C... plot code
C
      CODE  = 117
      COUNT = 1
C
      NUMBER (1) = ICHDI
C
C... transmit
C
      CALL SENDGP
      GOTO 20
C
10    CONTINUE
      GP1ERR = .TRUE.
      CALL MESSAG (56)
C
20    CONTINUE
      RETURN
C
C
      E N D
