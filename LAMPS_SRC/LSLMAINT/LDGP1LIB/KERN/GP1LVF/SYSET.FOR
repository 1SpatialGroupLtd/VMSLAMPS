C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE SYSET (NS)
C                      Appointment and drawing of a symbol
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
      INTEGER*2       NSYMB,NS
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      NSYMB  = NS
      GP1ERR = .FALSE.
C
C... test, whether parameter is in permissible range
C
      IF (NSYMB .GE. 0 .AND. NSYMB .LE. 57) GOTO 10
C
      GP1ERR = .TRUE.
      CALL MESSAG (28)
      GOTO 20
C
C... select symbol
C
10    CONTINUE
      CODE       = 85
      COUNT      = 1
      NUMBER (1) = NSYMB
C
C... transmit
C
      CALL SENDGP
C
C... draw symbol
C
      CODE  = 84
      COUNT = 0
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
