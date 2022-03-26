C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN

      SUBROUTINE FACTOR (FACT)
C                       Scaling of both axes
C                       Only change the scale in the library modules,
C                       no scale sending to GP1
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:

      REAL*4  FACT


C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      SCLFAC = FACT

      RETURN


      E N D
