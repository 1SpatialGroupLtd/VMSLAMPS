C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE GPSTAT (BIT)
C                       Fetch status byte of plotter
C BIT1: 0=CONTINUE 1=HALT             BIT2: BUFFER 0=NOT FULL 1=FULL
C BIT3: 0=LOCAL 1=REMOTE              BIT4: REFERENZ 0=LOST 1=I.O.
C BIT5: CODE 0=I.O. 1=NOT VALID       BIT6: =1
C BIT7: CHECKSUM 0=I.O.  1=ERROR      BIT8: BUFFER 0=EMPTY 1=NOT EMPTY
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      INTEGER*2  ANSWER, STX, ACK, NAK
      INTEGER*2  BIT (8), I, M, N
      REAL*4     TIME

C... "QIO" variabeln :
      INTEGER*4	MAX_TIME 
      INTEGER*4	FUN_STATUS
      INTEGER*4	SYS$QIO
      INTEGER*4	SYS$QIOW
      CHARACTER*(10) BUFF
      INTEGER*2	BUFLEN
      INTEGER*4	ISTS(2)
      INTEGER*2	IST(2)
      EQUIVALENCE (ISTS,IST)

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... constants:
      STX    = 2
      ACK    = 6

C... if offline then skip
      IF (IMODE .EQ. 0) RETURN

C... send status request to the GP1
      BUFF (1:1) = CHAR(STX)
      BUFLEN     = 1

      FUN_STATUS = SYS$QIOW (,%VAL(GP1_CHAN),
     +                  %VAL(FUN_QIO_W),
     +                  ISTS,,,
     +                  %REF(BUFF),
     +                  %VAL(BUFLEN),,,,)

      IF (.NOT. FUN_STATUS) GOTO 998

C... wait for status-byte answer

      MAX_TIME = 5
C... if symbol-storing, wait longer for answer
      IF (CODE .EQ. 112) MAX_TIME = 50
C... if text-type change, wait longer for answer
      IF (CODE .EQ. 93)  MAX_TIME = 50

      FUN_STATUS = SYS$QIOW (,%VAL(GP1_CHAN),
     +                  %VAL(FUN_QIO_R),
     +                  ISTS,,,
     +                  %REF(BUFF),
     +                  %VAL(BUFLEN),
     +                  %VAL(MAX_TIME),,,)

      IF (.NOT. FUN_STATUS) GOTO 998
      IF (BUFF(1:1) .EQ. CHAR(STX)) GOTO 996

      ANSWER = ICHAR ( BUFF (1:1) )

C... test answer of "ACK" (highly true GP1 is set to ACK/NAK)
      IF (ANSWER .EQ. ACK .OR. ANSWER .EQ. NAK) GOTO 997

C... split up in 8 bit
      DO 20  I = 1,8
             BIT (I) = 0
20    CONTINUE

      IF (ANSWER .LT. 0) ANSWER = ANSWER + 256

      DO 30  N = 1,8
             BIT (N) = MOD (ANSWER,2) / 1
             ANSWER = ANSWER / 2
30    CONTINUE

      RETURN

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C...                          FATAL ERROR exits with stop of the program

C... time out, no answer from GP1
996   CALL MESSAG (22)
      FUN_STATUS = 1
      GOTO 999

C... GP1 is set to transmission mode 1
997   CALL MESSAG (62)
      FUN_STATUS = 1
      GOTO 999

C... QIOW failed
998   CALL MESSAG (66)

999   CALL MESSAG (63)
      CALL MESSAG (65)
      CALL SYS$EXIT (%VAL(FUN_STATUS))

      E N D
