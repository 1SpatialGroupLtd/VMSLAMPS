        INTEGER*4  FUNCTION OPEN_FRT()
C
CDEC$	IDENT	'06OC89'
C
C 	Copyright Laser-Scan Ltd., Cambridge, England
C
C	Created.				FJB  25-Aug-1989
C
C Get input FRT file and open on lun FRTLUN.
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN'
C
C
C System parameters
C
 	INTEGER*4	SS$_NORMAL ! normal successful completion
	EXTERNAL	SS$_NORMAL
C
C Functions:
C
	INTEGER*4	FRTINI		! open FRT file for readonly
C
C Workspace:
C
C
C ......................................................................
C
C
	OPEN_FRT=%LOC(SS$_NORMAL)
C
C Initialise FRT file
	IF(FRTINI(FRT_FILE(1:FRT_FILE_LEN)))THEN
	   OPEN_FRT=I2DLG__BADFRT
	   CALL LSL_PUTMSG(OPEN_FRT,FRT_FILE(1:FRT_FILE_LEN))
	   GOTO 10
	ENDIF
C
C ......................................................................
C
10	IF (OPEN_FRT) OPEN_FRT=%LOC(SS$_NORMAL)     ! normal completion?
	RETURN
	END
