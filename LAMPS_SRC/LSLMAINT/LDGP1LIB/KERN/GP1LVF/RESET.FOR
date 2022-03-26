C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE RESET
C                     Set default values
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

      GP1ERR = .FALSE.
      LEUNIT = 0
      ANUNIT = 0
      SCLFAC = 1.0

      CALL VECTOR (0.0,0.0,3)
      CALL SCALE  (1.0,1.0)
      CALL SETPAR (0,0)
      CALL SYSET  (0)
      CALL SYSCAL (5.0)
      CALL SYROTA (0.0)
      CALL CHAR   (1)
      CALL STRSCL (5.0)
      CALL STROT  (0.0)
      CALL STRSLN (90.0)
      CALL PENCHA (1)
      CALL LINSET (1)
      CALL LINSCL (5.0)
      CALL LINRAT (5.0)
      CALL LINSYM (0)
      CALL LINSRO (0.0)
      CALL CLRWIN
      CALL SPEED  (9)

      RETURN


      E N D
