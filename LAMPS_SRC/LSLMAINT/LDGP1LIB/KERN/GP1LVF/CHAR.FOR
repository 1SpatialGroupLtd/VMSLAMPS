C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE CHAR (TYPE)
C                       Appointment of lettering type
C=====================================================================
C
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
      INTEGER*2       TYP,TYPE
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      TYP    = TYPE
      GP1ERR = .FALSE.
C
C... test, whether parameter is in permissible range
C
      IF (TYP .LT. 0 .OR. TYP .GT. 1) GOTO 10
C
C... plot code
C
      CODE       = 88
      COUNT      = 1
      NUMBER (1) = TYP
C
C... transmit
C
      CALL SENDGP
      GOTO 20
C
10    CONTINUE
      GP1ERR = .TRUE.
      CALL MESSAG (31)
C
20    CONTINUE
      RETURN
C
C
      E N D
