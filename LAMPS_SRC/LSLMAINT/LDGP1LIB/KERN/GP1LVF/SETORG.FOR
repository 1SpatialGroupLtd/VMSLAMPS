C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE SETORG
C                      Set origin at present point
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:      
      CHARACTER*4  CHCODE
      INTEGER*2    NUM

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

      CHCODE (1:2) = '%%'
      CHCODE (3:3) = CHAR (13)
      CHCODE (4:4) = CHAR (10)

      GP1ERR = .FALSE.

C... put GP1 to LOCAL mode
      CALL LOCAL

C... send coordinate request
      NUM = 4

      FUN_STATUS = SYS$QIOW (,%VAL(GP1_CHAN),
     +                  %VAL(FUN_QIO_W),
     +                  ISTS,,,
     +                  %REF(CHCODE),
     +                  %VAL(NUM),,,,)

      IF (.NOT. FUN_STATUS) GOTO 999

C... switch again to REMOTE
      CALL REMOTE

      RETURN




C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C...                           FATAL ERROR exit with stop of the program

C... QIOW failed
999   CALL MESSAG (70)
      CALL MESSAG (63)
      CALL MESSAG (65)
      CALL SYS$EXIT (%VAL(FUN_STATUS))



      E N D
