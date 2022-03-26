C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE WHERE (XEND,YEND)
C                      Determination of coordinates of present point
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      CHARACTER*4     CHCODE
      INTEGER*2       PART (12)
      INTEGER*2       CHECK
      INTEGER*2       BIT (8)
      INTEGER*2       I,N,NUMB
      INTEGER*2       IXE,IYE
      REAL*4          XEND,YEND

C... "QIO" variabeln :
      INTEGER*4	FUN_STATUS
      INTEGER*4	MAX_TIME 
      INTEGER*4	SYS$QIOW
      CHARACTER*(12) BUFF
      INTEGER*2	BUFLEN
      INTEGER*4	ISTS(2)
      INTEGER*2	IST(2)
      EQUIVALENCE (ISTS,IST)

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... do it only in online mode
      IF (IMODE .NE. 1) RETURN

      CHCODE (1:2) = '**'
      CHCODE (3:3) = CHAR (13)
      CHCODE (4:4) = CHAR (10)

      GP1ERR = .FALSE.

C... put GP1 to LOCAL mode
      CALL LOCAL

C... send coordinate request
      NUMB = 4

      FUN_STATUS = SYS$QIOW (,%VAL(GP1_CHAN),
     +                  %VAL(FUN_QIO_W),
     +                  ISTS,,,
     +                  %REF(CHCODE),
     +                  %VAL(NUMB),,,,)

      IF (.NOT. FUN_STATUS) GOTO 999


C... and get answer
      BUFF (6:6) = CHAR (0)
      BUFLEN     = 9
      MAX_TIME   = 10

      FUN_STATUS = SYS$QIOW (,%VAL(GP1_CHAN),
     +                  %VAL(FUN_QIO_R),
     +                  ISTS,,,
     +                  %REF(BUFF),
     +                  %VAL(BUFLEN),
     +                  %VAL(MAX_TIME),,,)

      IF (.NOT. FUN_STATUS) GOTO 999

C... no answer, timeout ?
      IF (BUFF (6:6) .EQ. CHAR (0)) GOTO 997

80    CONTINUE
      DO 90   I = 1,8
              PART (I) = ICHAR (BUFF(I:I))
90    CONTINUE

C... is checksum ok?
      CHECK = 0

      DO 100   I = 1,6
               CHECK = CHECK + PART (I)
100   CONTINUE

      CHECK = MOD (CHECK,128)
      IF (CHECK .LT. 32) CHECK = CHECK + 32
      IF (CHECK .NE. MOD(PART (7),128)) GOTO 998

C... compose the coordinates:
C... X : 6 low bits    = 6 low bits of PART(1)   Y : PART(4)
C...     6 middle bits = 6 low bits of PART(2)       PART(5)
C...     4 high bits   = 4 low bits of PART(3)       PART(6)

      PART (1) = MOD (PART (1),128) - 32
      PART (2) = MOD (PART (2),128) - 32
      PART (3) = MOD (PART (3),16)
      PART (4) = MOD (PART (4),128) - 32
      PART (5) = MOD (PART (5),128) - 32
      PART (6) = MOD (PART (6),16)


      IF (PART(3) .GT. 7) GOTO 121
      XEND = FLOAT (PART (1) + 64 * (PART (2) + 64 * PART (3))) * 0.04
      GOTO 122

121   PART(3) = PART(3) - 8
      IXE  = (PART (1) + 64 * (PART (2) + 64 * PART (3))) - 32767
      IXE  = IXE - 1
      XEND = FLOAT (IXE) * 0.04

122   IF (PART(6) .GT. 7) GOTO 123
      YEND = FLOAT (PART (4) + 64 * (PART (5) + 64 * PART (6))) * 0.04
      GOTO 124

123   PART(6) = PART(6) - 8
      IYE  = (PART (4) + 64 * (PART (5) + 64 * PART (6))) - 32767
      IYE  = IYE - 1
      YEND = FLOAT (IYE) * 0.04

124   IF (LEUNIT .EQ. 0) GOTO 130
      XEND = XEND / 10.0
      YEND = YEND / 10.0
      IF (LEUNIT .EQ. 1) GOTO 130
      XEND = XEND / 2.54
      YEND = YEND / 2.54

130   CALL REMOTE
      RETURN


C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... no answer within the timelimit
997   CALL MESSAG (45)
      GP1ERR = .TRUE.
      RETURN

C... checksum error, set GP1ERR and return
998   CALL MESSAG (46)
      GP1ERR = .TRUE.
      RETURN


C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C...                          FATAL ERROR exits with stop of the program

C... QIOW failed
999   CALL MESSAG (71)
      CALL MESSAG (63)
      CALL MESSAG (65)
      CALL SYS$EXIT (%VAL(FUN_STATUS))

      E N D
