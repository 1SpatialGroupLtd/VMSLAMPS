C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE LINRAT (RL)
C                       Determine ratio drawn / blank part of stroke
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
      REAL*4          RLIN,RL
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      RLIN   = RL
      GP1ERR = .FALSE.
C
C... test, whether parameter is in permissible range
C
      IF (RLIN .GE. 0.0 .AND. RLIN .LE. 327.67) GOTO 10
C
      GP1ERR = .TRUE.
      CALL MESSAG (39)
      GOTO 20
C
C... plot code, conversion of ration number into plotter format
C
10    CONTINUE
      CODE  = 97
      COUNT = 1
C
      NUMBER (1) = INT (100.0 * RLIN + 0.5)
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
