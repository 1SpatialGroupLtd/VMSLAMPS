C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE LOCAL
C                     Switch from REMOTE to LOCAL
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      INTEGER*2  BIT (8), I

C... "QIO" variabeln :
      INTEGER*4	FUN_STATUS
      INTEGER*4	SYS$QIOW
      CHARACTER*(12) COMMAND
      INTEGER*2	BUFLEN,IST(2)
      INTEGER*4	ISTS(2)
      EQUIVALENCE (ISTS,IST)

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... if offline then skip
      IF (IMODE .EQ. 0) RETURN

C... switch to LOCAL
      COMMAND (1:1) = CHAR (23)
      COMMAND (2:2) = CHAR (55)
      COMMAND (3:3) = CHAR (13)
      COMMAND (4:4) = CHAR (10)
      BUFLEN = 4

      FUN_STATUS = SYS$QIOW (,%VAL(GP1_CHAN),
     +                  %VAL(FUN_QIO_W),
     +                  ISTS,,,
     +                  %REF(COMMAND),
     +                  %VAL(BUFLEN),,,,)

      IF (.NOT. FUN_STATUS) GOTO 999

C... wait until GP1 is really in LOCAL mode
10    CONTINUE
      DO 20 I = 1,1000
20    CONTINUE
      CALL GPSTAT (BIT)
      IF (BIT (3) .EQ. 1) GOTO 10
      RETURN


C... QIOW failed              FATAL ERROR exits with stop of the program
999   CALL MESSAG (67)
      CALL MESSAG (63)
      CALL SYS$EXIT (%VAL(FUN_STATUS))

      E N D
