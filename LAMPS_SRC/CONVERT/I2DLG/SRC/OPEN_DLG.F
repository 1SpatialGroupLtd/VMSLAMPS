        INTEGER*4  FUNCTION OPEN_DLG()
C
CDEC$	IDENT	'06OC89'
C
C 	Copyright Laser-Scan Ltd., Cambridge, England
C
C	Created.				FJB	10-Aug-1989
C
C Open a DLG output file using FORTRAN on lun DLGLUN. Luns are defined
C in PARAMS.PAR
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
C
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'
	INCLUDE 'LSL$CMNLSL:MTOVCM.CMN'
	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN'
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
	INTEGER		LIB$GETDVI
	INTEGER		MTONIT		! init magtape
	INTEGER		MTORWD		! rewind magtape
C
C Workspace:
	INTEGER		VAL
	LOGICAL		NORWND
	INTEGER*4	IERR		! for error return	
	INTEGER*4	OK		! for error return	
C
C
C ......................................................................
C
C
	OPEN_DLG = SS$_NORMAL
	IS_TAPE = .FALSE.
C
C Open DLG output file
C
C Note: the name has already been parsed into the RDFLN common block
C
C
C Check if output is a mag tape unit
C
	IF( HAD_DEVICE ) THEN
	   OPEN_DLG=LIB$GETDVI(DVI$_DEVCLASS,,DEV_NAM(1:DEV_LEN),VAL,,)
	   IF (.NOT.OPEN_DLG) THEN
	      CALL LSL_PUTMSG(I2DLG__UNKDEV,DEV_NAM(1:DEV_LEN))
	      CALL LSL_ADDMSG(OPEN_DLG)
	      OPEN_DLG=I2DLG__BADDEV
	      GOTO 1000
	   ENDIF
C
	   IS_TAPE = VAL .EQ. DC$_TAPE
C
	ENDIF
C
C Initialize tape as output & rewind
C
	IF (IS_TAPE) THEN
C
C Get name of device
C
	   OPEN_DLG=LIB$GETDVI(DVI$_DEVNAM,,DEV_NAM(1:DEV_LEN),,
     &	               DEV_NAM,DEV_LEN)
	   IF (.NOT.OPEN_DLG) THEN
	      CALL LSL_PUTMSG(I2DLG__BADDEV,DEV_NAM(1:DEV_LEN))
	      CALL LSL_ADDMSG(OPEN_DLG)
	      OPEN_DLG=I2DLG__BADDEV
	      GOTO 1000
	   ENDIF
C
C	   
C Initialise tape
C
	   OPEN_DLG=MTONIT(DEV_NAM(:DEV_LEN),.TRUE.,NORWND)
	   IF (OPEN_DLG .NE. LSL__NORMAL) THEN
	      CALL LSL_PUTMSG(I2DLG__MTOPEN,DEV_NAM(1:DEV_LEN))
	      CALL LSL_ADDMSG(OPEN_DLG)
	      CALL LSL_ADDMSG(MTOERR)
	      OPEN_DLG=I2DLG__MTOPEN
	      GOTO 1000
	   ELSEIF (HAD_LOG) THEN		! tell user of success?
	      OPEN_DLG=I2DLG__DLGTAPOPN		! yes
	      CALL LSL_PUTMSG(OPEN_DLG,DEV_NAM(:DEV_LEN))
	   ENDIF
C
C Rewind 
	   IF (REWIND) THEN
	      OPEN_DLG=MTORWD()			! rewind tape
	      IF (OPEN_DLG .NE. LSL__NORMAL) THEN
	         CALL LSL_PUTMSG(I2DLG__MTORWD,DEV_NAM(1:DEV_LEN))
	         CALL LSL_ADDMSG(OPEN_DLG)
	         CALL LSL_ADDMSG(MTOERR)
	         OPEN_DLG=I2DLG__MTORWD
	         GOTO 1000
	      ENDIF
	   ENDIF
C
C ......................................................................
C
C Or open DLG disk file
C
	ELSE
C
C	   OPEN (UNIT=DLGLUN,STATUS='NEW',CARRIAGECONTROL='NONE',
	   OPEN (UNIT=DLGLUN,STATUS='NEW',CARRIAGECONTROL='LIST',
     &	      RECL=144,FILE=DLG_FILE(:DLG_FILE_LEN),ERR=20)
	   IF (HAD_LOG) THEN			! tell user of success?
	      OPEN_DLG=I2DLG__DLGOPNOUT		! yes
	      CALL LSL_PUTMSG(OPEN_DLG,DLG_FILE(:DLG_FILE_LEN))
	   ENDIF
	   GOTO 30
C
C Error opening DLG file for output
C
20	   CALL ERRSNS(,IERR,OK)
	   IF (OK.EQ.0) OK=IERR
	   OPEN_DLG=I2DLG__ERROPNDLG
	   CALL LSL_PUTMSG(OPEN_DLG,DLG_FILE(:DLG_FILE_LEN))
	   CALL LSL_ADDMSG(OK)
C 
30	   GOTO 1000
C
	ENDIF
C
C ......................................................................
C
1000	IF (OPEN_DLG) OPEN_DLG=SS$_NORMAL        ! normal completion?
	RETURN
	END
