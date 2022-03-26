C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE VECTOR (X,Y,IP)
C                       Drawing of straight lines
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      INTEGER*2       IROUND,PEN,IP
      REAL*4          MAX,XEND,YEND,X,Y

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... constant:
      MAX = 1310.6996

C... initialize values
      XEND   = X * SCLFAC
      YEND   = Y * SCLFAC
      PEN    = IP
      GP1ERR = .FALSE.

C... conversion into mm
      IF (LEUNIT .EQ. 0) GOTO 10
      XEND = XEND * 10.0
      YEND = YEND * 10.0

      IF (LEUNIT .EQ. 1) GOTO 10
      XEND = XEND * 2.54
      YEND = YEND * 2.54

C... test, whether parameters are in permissible range
10    IF (ABS (XEND) .GT. MAX) GOTO 20
      IF (ABS (YEND) .GT. MAX) GOTO 20
      IF (PEN .GT. 4 .OR. PEN .LT. 2) GOTO 20

C... generate ASCII Code
      CODE  = 63 + PEN

C... convert coordinates into plotter increments
      COUNT = 2
      PARAM (1) = IROUND (25.0 * XEND)
      PARAM (2) = IROUND (25.0 * YEND)

C... transmit
      CALL SENDGP
      RETURN

20    CONTINUE
      GP1ERR = .TRUE.
      CALL MESSAG (24)
      RETURN


      E N D
