C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE TKREI
C                      Pen down and circle with tangentialdrive
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      INTEGER*2       CODE
      INTEGER*2       COUNT
C
      COMMON /GP1C02/ CODE,COUNT
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C... full circle counterclockwise with engraphing tool
C
      CODE       = 114
      COUNT      = 0
C
      CALL SENDGP
C
C
      RETURN
C
C
      E N D
