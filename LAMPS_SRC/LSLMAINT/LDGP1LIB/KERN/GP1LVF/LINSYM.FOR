C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE LINSYM (NSL)
C                       Appointment of symbol of stroke
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
      INTEGER*2       NSLIN,NSL
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      NSLIN  = NSL
      GP1ERR = .FALSE.
C
C... test, whether parameter is in permissible range
C
      IF (NSLIN .GE. 0 .AND. NSLIN .LE. 57) GOTO 10
C
      GP1ERR = .TRUE.
      CALL MESSAG (40)
      GOTO 20
C
C... plot code
C
10    CONTINUE
      CODE  = 98
      COUNT = 1
C
      NUMBER (1) = NSLIN
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
