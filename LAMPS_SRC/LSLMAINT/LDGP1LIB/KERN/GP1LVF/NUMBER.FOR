C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE NUMBER (XE,YE,HI,FN,PH,RO)
C                       Convert number into string and write
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      INTEGER*2  DIGIT1 (8)
      INTEGER*2  DIGIT2 (16)
      INTEGER*2  CHAR (36)
      INTEGER*2  ROUND,RO
      INTEGER*2  BLANK
      INTEGER*2  NUM
      INTEGER*2  I
      REAL*4     PHI,PH
      REAL*4     XEND,YEND,XE,YE
      REAL*4     FNUM,FN
      REAL*4     RNUM,SIGN,ARNUM
      REAL*4     HIGHT,HI
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      XEND  = XE
      YEND  = YE
      HIGHT = HI
      FNUM  = FN
      PHI   = PH
      ROUND = RO
C
C... is requested an excessive number of digits or illegal number resp.?
C
      IF (IABS (ROUND).GT.7) GOTO 70
C
C... round off
C
      SIGN = 1.0
      IF (FNUM .LT. 0.0) SIGN = -1.0
      RNUM = AINT (10.0 ** ROUND * FNUM + 0.5 * SIGN) / (10.0 ** ROUND)
      IF (ROUND .EQ. -1) RNUM = AINT (FNUM + 0.5 * SIGN)
C
C... split up the number into digits
C
      ENCODE (16,9000,DIGIT1,ERR=70) RNUM
C
C... store a digit into each component (unpack)
C
      DO 10  I = 1,8
             DIGIT2 (2 * I - 1) = MOD (DIGIT1 (I),256)
             DIGIT2 (2 * I)     = DIGIT1 (I) / 256
10    CONTINUE
C
C... count leading blanks
C
      IF (DIGIT2 (1) .NE. 32) GOTO 45
      DO 20  I = 1,16
             IF (DIGIT2 (I) .EQ. 32) GOTO 20
             BLANK = I
             GOTO 30
20    CONTINUE
C
C... shift to the left and fill up with blanks
C
30    IF (RNUM .GE. 0) BLANK = BLANK - 1
      DO 40  I = BLANK,16
             DIGIT2 (I-BLANK+1) = DIGIT2 (I)
             DIGIT2 (I)         = 32
40    CONTINUE
C
C... pack
C
45    DO 50  I = 1,36
             CHAR (I) = 8224
50    CONTINUE
C
      DO 60  I = 1,8
             CHAR (I) = DIGIT2(2 * I - 1) + 256 * DIGIT2 (2 * I)
60    CONTINUE
C
C... determine number of digits
C
      ARNUM = ABS (RNUM)
      IF (ARNUM .GT. 1.0E-7 .AND. ARNUM .LT. 1.0) NUM = 1
      IF (ARNUM .GE. 1.0) NUM = INT (ALOG10 (ARNUM)) + 1
      IF (ROUND .GE. 0) NUM = NUM + ROUND + 1
C
      NUM = NUM + 1
C
C... draw
C
      CALL SYMBOL (XEND,YEND,HIGHT,CHAR,PHI,NUM)
C
70    CONTINUE
      RETURN
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C... format
C
9000  FORMAT (F16.8)
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C
      E N D
