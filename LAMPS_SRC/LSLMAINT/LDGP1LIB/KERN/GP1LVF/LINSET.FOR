C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE LINSET (NL)
C                       Appointment of type of stroke
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL         GP1ERR
      INTEGER*2       CODE
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (1)
      INTEGER*2       LEUNIT
      INTEGER*2       ANUNIT
      INTEGER*2       NUMLIN,NL
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      NUMLIN = NL
      GP1ERR = .FALSE.
C
C... test, whether parameter is in permissible range
C
      IF (NUMLIN .LT. 1 .OR. NUMLIN .GT. 7) GOTO 10
C
C... select type of stroke
C
      CODE  = 95
      COUNT = 1
C
      NUMBER (1) = NUMLIN
C
C... transmit
C
      CALL SENDGP
C
      GOTO 20
C
10    CONTINUE
      GP1ERR = .TRUE.
      CALL MESSAG (37)
C
20    CONTINUE
      RETURN
C
C
      E N D
