C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE ORIWIN (COORDIN)
C                      Values of origin and window
C                      X/Y-ORIGIN, X/Y-WINDOW-MIN, X/Y-WINDOW-MAX
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      INTEGER*2       PART (8)
      INTEGER*2       CHECK
      INTEGER*2       I,N,TRIPLE
      INTEGER*2       IX,IY
      REAL*4          COORDIN (6), X, Y

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

C... send request for origin/window coordinates
      CODE       = 109
      COUNT      = 0
      CALL SENDGP

C... and get answer (3 times a coordinate pair)
      DO 140  TRIPLE = 1,3

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
      X = FLOAT (PART (1) + 64 * (PART (2) + 64 * PART (3))) * 0.04
      GOTO 122

121   PART(3) = PART(3) - 8
      IX  = (PART (1) + 64 * (PART (2) + 64 * PART (3))) - 32767
      IX  = IX - 1
      X   = FLOAT (IX) * 0.04

122   IF (PART(6) .GT. 7) GOTO 123
      Y = FLOAT (PART (4) + 64 * (PART (5) + 64 * PART (6))) * 0.04
      GOTO 124

123   PART(6) = PART(6) - 8
      IY  = (PART (4) + 64 * (PART (5) + 64 * PART (6))) - 32767
      IY  = IY - 1
      Y   = FLOAT (IY) * 0.04

124   IF (LEUNIT .EQ. 0) GOTO 130
      X = X / 10.0
      Y = Y / 10.0
      IF (LEUNIT .EQ. 1) GOTO 130
      X = X / 2.54
      Y = Y / 2.54

130   COORDIN (TRIPLE*2-1)   = X
      COORDIN (TRIPLE*2) = Y

140   CONTINUE


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
999   CALL MESSAG (68)
      CALL MESSAG (63)
      CALL MESSAG (65)
      CALL SYS$EXIT (%VAL(FUN_STATUS))

      E N D
