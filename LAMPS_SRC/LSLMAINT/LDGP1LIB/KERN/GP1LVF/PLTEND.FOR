C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE PLTEND
C                      Terminate the job :
C                      Close datafile and switch the GP1 to LOCAL
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'


C-----------------------------------------------------------------------

C... if offline then skip
      IF (IMODE .EQ. 0) GOTO 10

C... switch to LOCAL
      CALL LOCAL

C... if online do not close datafile
      IF (IMODE .EQ. 1) GOTO 20
10    CLOSE (UNIT = ICHANL)

C... end of dialogue program
20    CALL MESSAG (23)

      RETURN

      E N D
