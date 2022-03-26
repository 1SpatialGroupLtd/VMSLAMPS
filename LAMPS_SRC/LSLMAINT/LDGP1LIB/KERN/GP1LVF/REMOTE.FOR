C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE REMOTE
C                      Switch to REMOTE
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'


C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


C... switch from LOCAL to REMOTE

      CODE       = 34
      COUNT      = 0

      CALL SENDGP

      RETURN


      E N D
