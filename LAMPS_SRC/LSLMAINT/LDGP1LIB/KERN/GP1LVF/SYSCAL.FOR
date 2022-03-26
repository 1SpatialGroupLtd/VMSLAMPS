C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE SYSCAL (SS)
C                       Appointment of symbol size
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
      REAL*4          SSYMB,SS,SCLFAC
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
      COMMON /GP1C03/ SCLFAC
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SSYMB  = SS * SCLFAC
      GP1ERR = .FALSE.
C
C... conversion into mm
C
      IF (LEUNIT .EQ. 0) GOTO 10
      SSYMB = SSYMB * 10.0
C
      IF (LEUNIT .EQ. 1) GOTO 10
      SSYMB = SSYMB * 2.54
C
C... test, whether parameter is in permissible range
C
10    IF (SSYMB .GE. 0.05 .AND. SSYMB .LE. 1250.0) GOTO 20
C
      GP1ERR = .TRUE.
      CALL MESSAG (29)
      GOTO 30
C
C... plot code, convert scale factor into plotter increments
C
20    CONTINUE
      CODE       = 86
      COUNT      = 1
      NUMBER (1) = INT (20.0 * SSYMB + 0.5)
C
C... transmit
C
      CALL SENDGP
C
30    CONTINUE
      RETURN
C
C
      E N D
