C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE SETPAR (LENGTH,ANGLE)
C                       Set len and angle unit
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL*1       GP1ERR
      INTEGER*2       LEUNIT
      INTEGER*2       ANUNIT
      INTEGER*2       LENGTH,LEN
      INTEGER*2       ANGLE,ANG
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
C
C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      LEN    = LENGTH
      ANG    = ANGLE
      GP1ERR = .FALSE.
C
      IF ((LEN .GE. 0 .AND. LEN .LE. 2) .AND.
     +    (ANG .GE. 0 .AND. ANG .LE. 2)) GOTO 10
C
      GP1ERR = .TRUE.
      CALL MESSAG (47)
      GOTO 20
C
10    CONTINUE
      LEUNIT = LEN
      ANUNIT = ANG
C
20    CONTINUE
      RETURN
C
C
      E N D
