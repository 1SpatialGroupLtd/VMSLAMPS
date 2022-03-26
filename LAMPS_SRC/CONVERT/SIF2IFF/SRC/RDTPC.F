	LOGICAL FUNCTION RDTPC
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF TPC command
C
C Description
C
C	Read parameters of SIF TPC or TLC commands
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! IFF variables
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDLONG		! read an integer
	LOGICAL		READ_SEP	! read a seperator
	LOGICAL		RDCHS		! read a character
	LOGICAL		CONT_LINE	! test for continuation line
C
C Local Variables
C
	INTEGER*4	IDUMMY		! dummy integer
	INTEGER*4	RESULT		! command read result
	LOGICAL		OK		! function return status
	LOGICAL		HAD_JUST	! justification flag
	LOGICAL		EOLN		! end of line flag
	LOGICAL		NOLONG		! integer return status
	BYTE		ICH		! ASCII character
C
C External declaration
C
	INTEGER*4	TPCCMD_CMD_TABLE
	EXTERNAL	TPCCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDTPC = .TRUE.
	HAD_JUST = .FALSE.
	PARLIN = 1			     ! default number of lines in para
C
C Now, read the command from the line
C
500	RESULT = RDCOMM(TPCCMD_CMD_TABLE)
C
C and check that there was one
C
	IF (RESULT .LE. 0) GOTO 9999
C
C Look for '=' seperator - send warning mess if not found
C
	OK = READ_SEP('=')
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(SIF2IFF__SEPNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
C
C test for continuation line
	IF (.NOT.CONT_LINE()) GOTO 9999
C
C Despatch according to command
C
	GOTO (510,520,530,540) RESULT
C
C Unknown command
C
	CALL LSL_PUTMSG(SIF2IFF__UNKCMD,CMDNST)
	GOTO 9999
C
C CO - ignore count
C
510	NOLONG = RDLONG(IDUMMY)
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	! warning if no integer
	   GOTO 9999
	ENDIF
	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 9000
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)	!warning if no ','
	   GOTO 9999
	ENDIF
	GOTO 500
C
C NU - nunber of lines in para
C
520	NOLONG = RDLONG(PARLIN)	
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	! warning if no integer
	   GOTO 9999
	ENDIF
	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 9000
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)	!warning if no ','
	   GOTO 9999
	ENDIF
	GOTO 500
C
C JU - justification
C
530	NOLONG = RDLONG(JUSTIF)	
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	! warning if no integer
	   GOTO 9999
	ENDIF
	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 9000
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)	!warning if no ','
	   GOTO 9999
	ENDIF
	HAD_JUST = .TRUE.
	GOTO 500
C
C SP -
C
540	NOLONG = RDLONG(IDUMMY)			! save line pattern value
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	! warning if no integer
	   GOTO 9999
	ENDIF
	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 9000
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)	!warning if no ','
	   GOTO 9999
	ENDIF
	GOTO 500
C
9999	RDTPC = .FALSE.
C
C Return
C
9000	CONTINUE
C
C Convert justification
C
	IF (JUSTIF.EQ.1) THEN
	   JUSTIF = 2
	ELSE IF (JUSTIF.EQ.2) THEN
	   JUSTIF = 1
	ELSE IF (JUSTIF.EQ.3) THEN
	   JUSTIF = 0
	ELSE IF (JUSTIF.EQ.4) THEN
	   JUSTIF = 5
	ELSE IF (JUSTIF.EQ.5) THEN
	   JUSTIF = 4
	ELSE IF (JUSTIF.EQ.6) THEN
	   JUSTIF = 3
	ELSE IF (JUSTIF.EQ.7) THEN
	   JUSTIF = 8
	ELSE IF (JUSTIF.EQ.8) THEN
	   JUSTIF = 7
	ELSE IF (JUSTIF.EQ.9) THEN
	   JUSTIF = 6
	ELSE 
	   JUSTIF = 0
	ENDIF
C
	RETURN
	END
