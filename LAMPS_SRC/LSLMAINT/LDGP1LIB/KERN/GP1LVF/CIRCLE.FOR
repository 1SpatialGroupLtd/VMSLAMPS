C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE CIRCLE (XS,YS,XE,YE,XM,YM,IC)
C                       Drawing of circles and parts of circles
C=====================================================================
C
      IMPLICIT NONE

C... variables:
C
      LOGICAL*1      GP1ERR
      INTEGER*2      CODE,IROUND
      INTEGER*2      COUNT
      INTEGER*2      NUMBER (7)
      INTEGER*2      LEUNIT
      INTEGER*2      ANUNIT
      INTEGER*2      FLAG,IC
      REAL*4         MAX,SCLFAC
      REAL*4         XSTART,YSTART,XS,YS
      REAL*4         XEND,YEND,XE,YE
      REAL*4         XMID,YMID,XM,YM
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
      COMMON /GP1C03/ SCLFAC
C
C... constant:
C
      MAX = 1310.6996
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
      XSTART = XS * SCLFAC
      YSTART = YS * SCLFAC
      XEND   = XE * SCLFAC
      YEND   = YE * SCLFAC
      XMID   = XM * SCLFAC
      YMID   = YM * SCLFAC
      FLAG   = IC
      GP1ERR = .FALSE.

C
C... conversion into mm
C
      IF (LEUNIT .EQ. 0) GOTO 20
      XSTART = XSTART * 10.0
      YSTART = YSTART * 10.0
      XEND   = XEND   * 10.0
      YEND   = YEND   * 10.0
      XMID   = XMID   * 10.0
      YMID   = YMID   * 10.0
C
      IF (LEUNIT .EQ. 1) GOTO 20
      XSTART = XSTART * 2.54
      YSTART = YSTART * 2.54
      XEND   = XEND   * 2.54
      YEND   = YEND   * 2.54
      XMID   = XMID   * 2.54
      YMID   = YMID   * 2.54
C
C... test, whether parameters are in permissible range
C
20    IF (ABS (XSTART) .GT. MAX) GOTO 30
      IF (ABS (YSTART) .GT. MAX) GOTO 30
      IF (ABS (XEND)   .GT. MAX) GOTO 30
      IF (ABS (YEND)   .GT. MAX) GOTO 30
      IF (ABS (XMID)   .GT. MAX) GOTO 30
      IF (ABS (YMID)   .GT. MAX) GOTO 30
C
C... plot code, conversion into plotter increments
C
      CODE     = 70
      COUNT    = 7
C
      NUMBER (1) = IROUND (25.0 * XSTART)
      NUMBER (2) = IROUND (25.0 * YSTART)
      NUMBER (3) = IROUND (25.0 * XEND)
      NUMBER (4) = IROUND (25.0 * YEND)
      NUMBER (5) = IROUND (25.0 * XMID)
      NUMBER (6) = IROUND (25.0 * YMID)
      NUMBER (7) = FLAG
C
C... transmit
C
      CALL SENDGP
      GOTO 40
C
30    CONTINUE
      GP1ERR = .TRUE.
      CALL MESSAG (26)
C
40    CONTINUE
      RETURN
C
C
      E N D
