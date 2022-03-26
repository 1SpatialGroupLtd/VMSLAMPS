C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE PLOT (X,Y,IP)
C                     Drawing of straight lines, set origin, end
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      INTEGER*2       IP,PEN
      REAL*4          X,Y,XEND,YEND
      LOGICAL*1       SETOR
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      XEND = X
      YEND = Y
      PEN  = IP
C
      SETOR = .FALSE.
      IF (PEN .LT. 0) SETOR = .TRUE.
      PEN = IABS (PEN)
C
C... end
C
      IF (PEN .EQ. 999) GOTO 10
C
C... wrong selection of pen
C
      IF (PEN .GT. 4 .OR. PEN .LT. 2) GOTO 20
C
C... drawing
C
      CALL VECTOR (XEND,YEND,PEN)
C
C... set origin
C
      IF (SETOR) CALL SETORG
      GOTO 20
C
C... end
C
10    CONTINUE
      CALL VECTOR (0.0,0.0,3)
      CALL PLTEND
C
20    CONTINUE
      RETURN
C
C
      E N D
