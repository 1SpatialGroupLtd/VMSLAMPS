C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE GPINIT (MODE, FILNAM, ICHAN, IERR)
C                       Initializing plotter
C                       Inputparamters : MODE 0=Offline 1=Online 2=mix
C                                        FILNAMe for Offline
C                                        ICHAN logical unit number
C                                        (no use, compatible to RT11)
C                      Outputparameter : IERR error flag (Logical)
C         (no use for the moment always set false. Its here for 
C          compatibility to RT11 libr.)  All errors results in abort !
C=====================================================================

      IMPLICIT NONE
      INCLUDE 'GP1LVF.GLO'

C... variables:
      LOGICAL*1  IERR
      CHARACTER*(*) FILNAM
      CHARACTER*(10) BUFF
      INTEGER*4  ICHAN
      INTEGER*2  ANSWER,CR,BIT (8),MODE

C... "QIO" variabeln :
      INTEGER*4	FUN_STATUS, LUN
      INTEGER*4 LIB$GET_LUN
      INTEGER*4	SYS$QIOW
      INTEGER*4	SYS$GETDVIW
      INTEGER*4	SYS$ASSIGN
      CHARACTER*12 PLOTTER
      PARAMETER	(PLOTTER = 'PLOTTER_LINE')
      INTEGER*2  BUFLEN
      INTEGER*4  ISTS(2)
      INTEGER*2  IST(2)
      EQUIVALENCE (ISTS,IST)

C... "GET DEVICE TYP" parameters :
      STRUCTURE /ITMLST/
      INTEGER*2 BUFLEN
      INTEGER*2 CODG
      INTEGER*4 BUFADR
      INTEGER*4 RETLENADR
      END STRUCTURE
      RECORD /ITMLST/ DVI_LIST
      INTEGER*4 CLASS, CLASS_LEN

C... "QIO" symbols :
      INCLUDE '($IODEF)'
      INCLUDE '($DCDEF)'
      INCLUDE '($SSDEF)'
      INCLUDE '($DVIDEF)'

C... definitions
      FUN_QIO_W = IO$_WRITEVBLK
      FUN_QIO_R = IO$_READVBLK .OR. IO$M_NOECHO .OR. IO$M_TIMED
      CR        = 13
      IERR      = .FALSE.
      IMODE     = MODE
      IF (IMODE .NE. 0 .AND. IMODE .NE. 1 .AND. IMODE .NE. 2) GOTO 996

C... if offline skip the line-assignement procedures
      IF (IMODE .EQ. 0) GOTO 10

C... find out the device class of "PLOTTER_LINE" :
C... (it should be a terminal-line; spooled or queued not valid)
      DVI_LIST.BUFLEN    = 4
      DVI_LIST.CODG      = DVI$_DEVCLASS
      DVI_LIST.BUFADR    = %LOC (CLASS)
      DVI_LIST.RETLENADR = %LOC (CLASS_LEN)

      FUN_STATUS = SYS$GETDVIW (,,'PLOTTER_LINE',DVI_LIST,,,,,)

      IF ((.NOT. FUN_STATUS) .AND. 
     +     (FUN_STATUS .NE. SS$_IVDEVNAM)) GOTO 998

C... is the "PLOTTER_LINE" a terminal ?
      IF ((FUN_STATUS .EQ. SS$_IVDEVNAM) .OR.
     +     (CLASS .NE. DC$_TERM)) GOTO 995

C... assign the channel "GP1_CHAN" to "PLOTTER_LINE"
      FUN_STATUS = SYS$ASSIGN (PLOTTER,GP1_CHAN,,)
      IF (.NOT. FUN_STATUS) GOTO 997

C... if online skip file opening
10    IF (IMODE .EQ. 1) GOTO 20

C... get a free logical unit number
      FUN_STATUS = LIB$GET_LUN (LUN)
      IF (.NOT. FUN_STATUS) GOTO 993
      ICHANL = LUN

C... open file for output
      OPEN (UNIT   = ICHANL,
     +      ERR    = 993,
     +      FILE   = FILNAM,
     +      ORGANIZATION = 'SEQUENTIAL',
     +      ACCESS       = 'SEQUENTIAL',
     +      RECORDTYPE   = 'VARIABLE',
     +      FORM   = 'FORMATTED',
     +      STATUS = 'NEW')

C... if offline, the job is done
      IF (IMODE .EQ. 0) GOTO 40

C... transmit CR to clean-up the situation
20    BUFF (1:1) = CHAR(CR)
      BUFLEN     = 1

      FUN_STATUS = SYS$QIOW (,%VAL(GP1_CHAN),
     +                  %VAL(FUN_QIO_W),
     +                  ISTS,,,
     +                  %REF(BUFF),
     +                  %VAL(BUFLEN),,,,)

      IF (.NOT. FUN_STATUS) GOTO 994

C... fetch status byte
      CALL GPSTAT (BIT)

C... in HALT ?
      IF (BIT (1) .EQ. 1) CALL MESSAG (61)
C... reference lost ?
      IF (BIT (4) .EQ. 0) CALL MESSAG (49)
C... in LOCAL ?
      IF (BIT (3) .EQ. 0) GOTO 30

C... switch to LOCAL
      CALL LOCAL

C... switch to REMOTE
30    CONTINUE
      CALL REMOTE

C... set len and angle unit
40    LEUNIT = 0
      ANUNIT = 0
      SCLFAC = 1.0

      RETURN

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C...                          FATAL ERROR exits with stop of the program


C... opening file caused an error
993   CALL MESSAG (64)
      FUN_STATUS = 1
      GOTO 999

C... "SYS$QIOW" ends with error ?
994   CALL MESSAG (59)
      GOTO 999

C... defining of "PLOTTER_LINE" is not well done
995   IF (FUN_STATUS .EQ. SS$_IVDEVNAM) THEN
      CALL MESSAG (52)
      ELSE
      CALL MESSAG (53)
      END IF
      GOTO 999

C... parameter mode not in range
996   CALL MESSAG (60)
      GOTO 999

C... "SYS$ASSIGN" fails (set the line unprotect in system-startup)
997   CALL MESSAG (58)
      GOTO 999

C... "GETDVIW" ends with error ?
998   CALL MESSAG (54)
999   CALL MESSAG (63)
      CALL MESSAG (65)
      CALL SYS$EXIT (%VAL(FUN_STATUS))

      E N D
