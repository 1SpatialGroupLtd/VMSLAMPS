C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE STRSET (TEXT)
C                       Plotting a text line
C                       End of text marked with "$"
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      CHARACTER*(80)  TEXT
      INTEGER*2       I,N
      INTEGER*2       CHARAC

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      DO 10   I = 1,80
              PARAM (I) = ICHAR (TEXT (I:I))
10    CONTINUE

      GP1ERR = .FALSE.

C... plot code
      CODE = 89

C... counting of characters and end $

      N = 1
      DO 30  I = 1,80
             CHARAC = PARAM (I)
             IF (CHARAC .EQ. 8) PARAM (I) = 127
             IF (CHARAC .LT. 32 .AND. CHARAC .NE. 0) GP1ERR = .TRUE.
             IF (CHARAC .EQ. 36) GOTO 25
             IF (CHARAC .EQ. 0) GOTO 25
             IF (CHARAC .GT. 32) N = I
             GOTO 30
25           N = I - 1
             GOTO 35
30    CONTINUE
             
35    IF (.NOT. GP1ERR) GOTO 40
      CALL MESSAG (32)
      GOTO 50

40    CONTINUE
      N = N + 1
      PARAM (N) = 36
      COUNT      = -N

C... transmit
      CALL SENDGP

50    CONTINUE
      RETURN

      E N D
