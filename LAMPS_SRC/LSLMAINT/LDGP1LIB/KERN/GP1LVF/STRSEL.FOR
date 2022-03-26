C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE STRSEL (TEXT)
C                       Plotting a text line
C                       Length of line parameter will sent first
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      CHARACTER*(80)  TEXT
      INTEGER*2       LEPART (3),LENGTH,I,N,SP,CHARAC

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... initialize
      SP     = 32
      GP1ERR = .FALSE.
      CODE = 116

C... determine the length, blanks at the end will be ignored
      LENGTH = 0
      DO 5    I = 1,80
              IF (TEXT (I:I) .NE . ' ') LENGTH = I
5     CONTINUE
      IF (LENGTH .EQ. 0) RETURN

C... cut length to 77
      IF (LENGTH .GT. 77) LENGTH = 77
      COUNT = - (LENGTH + 3)

C... exchange
      DO 10   I = 4,80
          PARAM (I) = ICHAR (TEXT (I-3:I-3))
          IF (PARAM(I) .EQ. 8) PARAM (I) = 127
          IF (PARAM(I) .LT. 32 .AND. PARAM(I) .NE. 0) GP1ERR = .TRUE.
10    CONTINUE

C... error in string ?
      IF (.NOT. GP1ERR) GOTO 20
      CALL MESSAG (32)
      RETURN

C... split length in 3 parts, put it in PARAM(1,2,3)
20    PARAM (1)  = MOD (LENGTH,64)
      LENGTH     = LENGTH / 64
      PARAM (2)  = MOD (LENGTH,64)
      LENGTH     = LENGTH / 64
      PARAM (3)  = MOD (LENGTH,16)
      PARAM (1)  = PARAM (1) + SP
      PARAM (2)  = PARAM (2) + SP
      PARAM (3)  = PARAM (3) + SP

C... transmit
      CALL SENDGP
      RETURN
      E N D
