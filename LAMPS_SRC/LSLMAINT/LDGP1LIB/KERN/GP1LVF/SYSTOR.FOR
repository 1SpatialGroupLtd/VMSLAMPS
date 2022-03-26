C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN

      SUBROUTINE SYSTOR
C                      Storing of user defined symbols on TU58
C=====================================================================

      IMPLICIT NONE

      INTEGER*2       CODE
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (130)

      COMMON /GP1C02/ CODE,COUNT,NUMBER

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      CODE  = 112
      COUNT = 0

      CALL SENDGP

      RETURN


      E N D
