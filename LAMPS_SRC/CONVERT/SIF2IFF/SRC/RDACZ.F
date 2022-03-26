	LOGICAL FUNCTION RDACZ
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF ACZ command
C
C Description
C
C	Read parameters of SIF ACZ command
C
C	Form of ACZ command is:
C
C		ACZ/LO=zlow,HI=zhigh
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
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! iff feature
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDINT		! read an integer
	LOGICAL		READ_SEP	! read a seperator
	LOGICAL		RDCHS		! read a character
	LOGICAL		CONT_LINE	! test for continuation line
C
C Local Variables
C
	INTEGER*2	LO		! ACZ low value
	INTEGER*2	HI		! ACZ high value
	INTEGER*4	RESULT		! command read result
	LOGICAL		HAD_LO		! low value flag
	LOGICAL		HAD_HI		! high value flag
	LOGICAL		OK		! function return status
	LOGICAL		EOLN		! end of line flag
	LOGICAL		NOINT		! integer return status
	BYTE		ICH		! ASCII character
C
C External declaration
C
	INTEGER*4	ACZCMD_CMD_TABLE
	EXTERNAL	ACZCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDACZ = .TRUE.
	HAD_LO = .FALSE.
	HAD_HI = .FALSE.
	HAD_AC = .FALSE.
C
C Now, read the command from the line
C
500	RESULT = RDCOMM(ACZCMD_CMD_TABLE)
C
C and check that there was one - if not no AC is output
C
	IF (RESULT .LE. 0) GOTO 9000
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
	GOTO (510,520) RESULT
C
C Unknown command
C
	CALL LSL_PUTMSG(SIF2IFF__UNKCMD,CMDNST)
	GOTO 9999
C
C LO -
C
510	NOINT = RDINT(LO)			! 
	IF (NOINT) THEN
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
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)
	   GOTO 9999
	ENDIF
	HAD_LO = .TRUE.
	GOTO 500
C
C HI -
C
520	NOINT = RDINT(HI)			! 
	IF (NOINT) THEN
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
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)
	   GOTO 9999
	ENDIF
	HAD_HI = .TRUE.
	GOTO 500
C
9999	RDACZ = .FALSE.
C
C Return
C
9000	IF (HAD_LO.AND.HAD_HI) THEN
C
C LO and HI should be equal but if not use the HI value.
C
	   IF (LO.NE.HI) CALL LSL_PUTMSG(SIF2IFF__BADACZ)
	   ACVAL = HI
	   HAD_AC = .TRUE.
	ELSE IF (HAD_HI) THEN
	   ACVAL = HI
	   HAD_AC = .TRUE.
	ELSE IF (HAD_LO) THEN
	   ACVAL = LO
	   HAD_AC = .TRUE.
	ENDIF
C	
	RETURN
	END
