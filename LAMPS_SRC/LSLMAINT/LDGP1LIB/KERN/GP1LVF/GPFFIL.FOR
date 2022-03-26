C[0z[1w[10m[9;188s

C=======================================================================
C 718.300.0700   GPFFIL -- PLOTFILE TRANSFER TO GP1 
C                          (LIBRARY VMS/FORTRAN)

C Read and plot file
C=====================================================================

      PROGRAM GPFFIL

      IMPLICIT NONE
      INCLUDE 'GP1LVF.GLO'

C... variables
      LOGICAL*1   ERR
      LOGICAL     EXIST
      CHARACTER*80 FILNAM
      INTEGER*2   CODE_COUNT,CODE_STRING (500)
      INTEGER*2   BLANK,DPOINT,POINT,LENGTH,OUT,IN
      INTEGER*2   IPARAM (130),FN_SIZE
      INTEGER*2   I, J, M, M1, M2, M3, N, NN
      INTEGER*4   LIB$GET_INPUT,LIB$GET_LUN, LUN, FUN_STATUS
      REAL*4      XSCALE,YSCALE

C------------------------------------------------------------------------

C... initialize variables
      OUT  = 5
      IN   = 5

C... initialize GP1 and write titles
      CALL GPINIT (1,'DK:SYMBOL.GP1',20,ERR)
      CALL MESSAG (16)
      WRITE (OUT,9000)

C... get a free logical unit number
      FUN_STATUS = LIB$GET_LUN (LUN)
      IF (.NOT. FUN_STATUS) GOTO 998

C... read file name from terminal
20    FUN_STATUS = LIB$GET_INPUT (FILNAM,
     +             'File name : ',
     +             FN_SIZE)
      IF (.NOT. FUN_STATUS) GOTO 20

C... does this file exist ?
      INQUIRE (FILE = FILNAM (1:FN_SIZE), EXIST = EXIST)
      IF (.NOT. EXIST) GOTO 996

C... access to plot file
      OPEN (UNIT=LUN, NAME=FILNAM, TYPE='OLD', READONLY, ERR=999)

75    CALL VECTOR (0.0,0.0,3)
      WRITE (OUT,9002)
      READ (IN,*,ERR=75) XSCALE
      IF (XSCALE .LT. 0.01 .OR. XSCALE .GT. 250.0) GOTO 75
      YSCALE = XSCALE
      CALL SCALE (XSCALE,YSCALE)
      WRITE (7,9007)

C... plotting...

80    READ (LUN,9003,ERR=997,END=110)
     +      CODE_COUNT,(CODE_STRING (I), I = 1,CODE_COUNT)

      CODE_COUNT = CODE_COUNT + 2
      CODE_STRING (CODE_COUNT - 1) = 13
      CODE_STRING (CODE_COUNT)     = 10

      CALL PUTIN (CODE_STRING,CODE_COUNT)

      GOTO 80


110   CALL VECTOR (0.0,0.0,3)
      XSCALE = 1.0
      YSCALE = 1.0
      CALL SCALE (XSCALE,YSCALE)
      CALL PLTEND

      CALL EXIT

C-----------------------------------------------------------------------

C... file not exist
996   WRITE (OUT,9006)
      CALL EXIT

C... error during reading the file
997   CONTINUE
      WRITE (OUT,9007)I
      CALL EXIT

C... error opening a channel
998   WRITE (7,9005)
      CALL SYS$EXIT (%VAL(FUN_STATUS))

C... error opening the file
999   WRITE (7,9004) FILNAM
      CALL EXIT

C-----------------------------------------------------------------------

9001  FORMAT (3I5)
9000  FORMAT ( 1X, 'GPFFIL - FILE TRANSFER PROGRAM' , ///,
     +         1X, 'This program sends a plot file to the GP1',/,
     +         1X, '-----------------------------------------',//)
9002  FORMAT (/1X, 'Scale factor [0.1..250.0] : ',$)
9003  FORMAT (Q,80A1)
9004  FORMAT (/1X,'GPFPUS - Cannot open the input file ',A80,//)
9005  FORMAT (/1X,'GPFPUS - Error opening a channel',//)
9006  FORMAT (/1X,'GPFPUS - File does not exist',//)
9007  FORMAT (/1X,'GPFPUS - Reading error data file in line',I3,//)
9008  FORMAT (A80)

      E N D
