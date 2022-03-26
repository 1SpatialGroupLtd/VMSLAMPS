C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE LINE (NU,NS,SL,RL,SY)
C                     Appoint all parameters of line
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL*1   GP1ERR,LINERR
      INTEGER*2   NUMLIN,NU
      INTEGER*2   NSLIN,NS
      REAL*4      SLIN,SL
      REAL*4      RLIN,RL
      REAL*4      SYROLI,SY
      INTEGER*2   LEUNIT,ANUNIT
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      NUMLIN = NU
      NSLIN  = NS
      SLIN   = SL
      RLIN   = RL
      SYROLI = SY
      LINERR = .FALSE.
C
C... type of stroke
C
      IF (NUMLIN .EQ. 999) GOTO 10
      CALL LINSET (NUMLIN)
      IF (GP1ERR) LINERR = .TRUE.
C
C... symbol of stroke
C
10    CONTINUE
      IF (NSLIN .EQ. 999) GOTO 20
      CALL LINSYM (NSLIN)
      IF (GP1ERR) LINERR = .TRUE.
C
C... length of interrupted part
C
20    CONTINUE
      IF (INT (SLIN+1.0E-5) .EQ. 999) GOTO 30
      CALL LINSCL (SLIN)
      IF (GP1ERR) LINERR = .TRUE.
C
C... ratio of drawn to blank lines
C
30    CONTINUE
      IF (INT (RLIN+1.0E-5) .EQ. 999) GOTO 40
      CALL LINRAT (RLIN)
      IF (GP1ERR) LINERR = .TRUE.
C
C... roration of symbol of stroke
C
40    CONTINUE
      IF (INT (SYROLI+1.0E-5) .EQ. 999) GOTO 50
      CALL LINSRO (SYROLI)
      IF (GP1ERR) LINERR = .TRUE.
C
50    IF (LINERR) GP1ERR = .TRUE.
      RETURN
C
C
      E N D
