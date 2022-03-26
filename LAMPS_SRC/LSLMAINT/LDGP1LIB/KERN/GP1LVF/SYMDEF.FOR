C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
      SUBROUTINE SYMDEF (IPARAM)
C                       Definition of an user symbol
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      INTEGER*2       IPARAM (130)
      INTEGER*2       CODE,I
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (130)
C
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C... gp1 code, number of parameters and symbol data block
C
      IF (IPARAM (1) .GT. 57 .OR. IPARAM (1) .LT. 26) GOTO 20
      CODE       = 111
      COUNT      = IPARAM (2) * 3 + 2
      IF (COUNT .LT. 2 .OR. COUNT .GT. 122) GOTO 20
      DO 10 I = 1,COUNT
            IF (IPARAM (I) .GT. 127 .OR. IPARAM (I) .LT. -128) GOTO 20
            NUMBER (I) = IPARAM (I)
10    CONTINUE
C
C... transmit
C
      CALL SENDGP
      GOTO 30
C
20    CONTINUE
      CALL MESSAG (51)
C
30    CONTINUE
      RETURN
C
C
      E N D
