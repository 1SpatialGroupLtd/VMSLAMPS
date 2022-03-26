C[0z[1w[10m[9;188s
C
C=====================================================================
C 718.300.0369   GP1LIB -- GP1 FORTRAN LIBRARY
C
      SUBROUTINE SYMBOL (X,Y,H,TEXT,ALPHA,N)
C                       Draw text line and symbols
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C...variables:
      LOGICAL     NOTODO,SYMERR
      CHARACTER*(80) CH_STRING
      INTEGER*2   STRING (40),TEXT (1)
      INTEGER*2   N,NUM,NUMSYM,NUMB
      INTEGER*2   I,K,L,M,INDEX
      REAL*4      HIGHT,H,PHI,ALPHA
      REAL*4      X,Y,XEND,YEND

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      XEND   = X
      YEND   = Y
      HIGHT  = H
      PHI    = ALPHA
      NUMB   = N
      NUM    = N
      SYMERR = .FALSE.

C... state of pen
      NOTODO = .FALSE.
      IF (INT(XEND+0.0001) .EQ. 999 .AND. INT(YEND+0.0001) .EQ. 999)
     +    NOTODO = .TRUE.

C... test if the value of number is in permissible range
      IF (NUMB .EQ. 0) GOTO 50
      IF (NUMB .LE. 0) GOTO 30
      IF (NUMB .GT. 80) NUMB = 80

C... exchange storage
      DO 10  I = 1,(NUMB / 2 + 1)
             STRING (I) = TEXT (I)
10    CONTINUE

C... text
      IF (.NOT. NOTODO) CALL VECTOR(XEND,YEND,3)
      IF (GP1ERR) SYMERR = .TRUE.

C... scaling and rotation of text
      CALL STRSCL (HIGHT)
      IF (GP1ERR) SYMERR = .TRUE.
      CALL STROT (PHI)
      IF (GP1ERR) SYMERR = .TRUE.

C... fill up text array with blanks
      INDEX = NUMB / 2 + 1
      IF (MOD (NUMB,2) .EQ. 1)
     +    STRING (INDEX) = MOD (STRING (INDEX),256) + 8192
      NUMB = INT (FLOAT (NUMB) / 2.0 + 0.6) + 1

      DO 20   I = NUMB,40
              STRING (I) = 8224
20    CONTINUE
      
C... write text
      DO 22  I = 1,40
      CH_STRING (2*I-1:2*I-1) = CHAR ( MOD (STRING (I) , 256))
      CH_STRING (2*I:2*I)     = CHAR ( STRING (I) / 256 )
22    CONTINUE

      CALL STRSET (CH_STRING)
      IF (GP1ERR) SYMERR = .TRUE.
      IF (SYMERR .OR. NUM .GT. 80) GOTO 50

      DO 25   I = 1,40
              IF (MOD (STRING (I), 256) .NE. 32) K = 2 * I - 1
              IF ((STRING (I) / 256) .NE. 32)    K = 2 * I
25    CONTINUE
      L = NUM - K
      IF (L .LE. 0) GOTO 50

      DO 26   I = 1,80
              CH_STRING (I:I) = ' '
26    CONTINUE

      DO 27   I = 1,L
              CALL STRSET (CH_STRING)
27    CONTINUE
      GOTO 50

C... symbol
30    CONTINUE
      NUMSYM = TEXT (1) + 11
      IF (NOTODO) GOTO 40
      IF (NUMB .EQ. -1) CALL VECTOR(XEND,YEND,3)
      IF (GP1ERR) SYMERR = .TRUE.
      IF (NUMB .LT. -1) CALL VECTOR(XEND,YEND,2)
      IF (GP1ERR) SYMERR = .TRUE.

C... scaling and rotation of symbol
40    CALL SYSCAL (HIGHT)
      IF (GP1ERR) SYMERR = .TRUE.
      CALL SYROTA (PHI)
      IF (GP1ERR) SYMERR = .TRUE.

C... draw symbol
      CALL SYSET (NUMSYM)
      IF (GP1ERR) SYMERR = .TRUE.

50    IF (SYMERR) GP1ERR = .TRUE.
      RETURN

      E N D
