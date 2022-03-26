        INTEGER*4  FUNCTION GET_FILES()
C
CDEC$	IDENT	'22AP91'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
	IMPLICIT NONE
C
	INCLUDE 'PARAMS.PAR'
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'
	INCLUDE 'LSL$CMNLSL:MTOVCM.CMN'
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'COMMAND.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
C
C
C System parameters
	INCLUDE		'($DCDEF)/NOLIST'
	INCLUDE 	'($DVIDEF)/NOLIST'
	INCLUDE		'($MTDEF)/NOLIST'
	INCLUDE 	'($SSDEF)/NOLIST'
C
C Functions:
C
	INTEGER*4	IFFOPEN		! open IFF file for readonly
	INTEGER		LIB$GETDVI
	INTEGER		MTONIT		! init magtape
	INTEGER		MTOSPC		! space forward through magtape
	INTEGER		MTOEOV		! find end of volume
	INTEGER		MTORWD		! rewind magtape
	INTEGER		FLROPN		! open file for read
	INTEGER		FLWOPN		! open file for writing
C
C Workspace:
	INTEGER		VAL
	LOGICAL		START,EOF
	LOGICAL		NORWND
	INTEGER*4	IERR		! for error return	
	INTEGER*4	OK		! for error return	
C
C
C ......................................................................
C
	GET_FILES=SS$_NORMAL
C
C Open MOSS input file
C
	IF (.NOT.FLROPN(MOSSLUN,P1_FIL(1:P1_LEN),,)) GOTO 20
	CALL WRITEF('Opened MOSS file %S for read',
     &	     P1_FIL(1:P1_LEN))
C
C Open TXT output file
C
	IF (.NOT.FLWOPN(TXTLUN,P2_FIL(1:P2_LEN),,)) GOTO 20
	CALL WRITEF('Opened TXT file %S for write',
     &	     P2_FIL(1:P2_LEN))
C
C Error opening GEN file for output
C
20	CALL ERRSNS(,IERR,OK)
	IF (OK.EQ.0) OK=IERR
	CALL LSL_ADDMSG(OK)
C
C ......................................................................
C
30	IF (GET_FILES) GET_FILES=SS$_NORMAL        ! normal completion?
	RETURN
	END

