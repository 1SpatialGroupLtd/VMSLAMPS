	INTEGER*4 FUNCTION RDLIN(LINE)
C
CDEC$	IDENT	'04OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created (based on AUTOTEXT READ_LINE)		RJH	12-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Decode line in parameter file
C
C Description
C
C	Decodes a line in the parameter file which relates IFF feature codes
C	to MAPDATA feature codes.
C
C	Returns the error code held in LSL_STATUS if something drastic goes
C	wrong, LSL__NORMAL otherwise. For ordinary errors, LSL_STATUS is
C	reduced to I2MD__LINEINPAR, so that we can attempt to continue with
C	the file.
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'	! LSLLIB string reading
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Local Parameters
C
	BYTE		PLING			! comment delimiter
	PARAMETER	(PLING = '!')
C
C Arguments
C
	INTEGER*4	LINE			! current line number
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text input line
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'		! LSLLIB command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
	INCLUDE 'CMN:TABLES.CMN'		! parameter tables
	INCLUDE	'CMN:CONTROL.CMN'      		! control variables
C
C Functions called
C
	INTEGER*4	RDCOMM			! read a command
	INTEGER*4	READSTR			! read a string
C
	LOGICAL		GET_STRPAR		! get string parameter
	LOGICAL		CHECK_AC_CODE		! check AC code is valid
	LOGICAL		CHECK_FC		! check FC is valid
	LOGICAL		FIND_FC			! find FC in CODE table
	LOGICAL		CHECK_MD_CODE		! check MAPDATA code is valid
C
C Local Variables
C
	INTEGER*4		IN_ADR		! address of input buffer
	INTEGER*4		IN_LEN		! input line length
	CHARACTER*(DEF_TXTLIM)	IN_STR		! input line without comments
C
	INTEGER*4		THIS_LEN	! current string length
	CHARACTER*(STR_MAX)	THIS_STR	! current string
C
	INTEGER*4		RESULT		! command read result
	INTEGER*4		ERRCOD		! LSLLIB error code
C
C External declarations
C
	INTEGER*4	PARCMD_CMD_TABLE	! parameter command table
	EXTERNAL	PARCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDLIN = LSL__NORMAL
C
C Strip the comments off the input line
C
	IN_STR = ' '			! clear our input string
	CALL BSLN			! get to start of default input buffer
C
	IN_LEN = READSTR(IN_STR,PLING,ON_CHAR,.TRUE.,ERRCOD)
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(ERRCOD)
	   GOTO 5555
	ENDIF
C
	IF (IN_LEN .EQ. 0) GOTO 10000	! ignore an empty line
C
C Set up an auxiliary buffer
C
	IN_ADR = %LOC(IN_STR)
	CALL SETAUX(%VAL(IN_ADR),IN_LEN)
C
C Read the command from the line
C
	NOMESS = .FALSE.			! ensure messages are output
C
	RESULT = RDCOMM(PARCMD_CMD_TABLE)
	IF (RESULT .LE. 0) GOTO 5555
C
C Despatch according to command
C
	GOTO (100,200,300,400,500,600,700,800,900,
     &	      950,950,950,950,950,1000) RESULT
C
	CALL LSL_PUTMSG(I2MD__UNKCMD,CMDNST)	! unknown command
	GOTO 9999
C
C CURVE_AC NAME - AC name for curve flags
C CURVE_AC CODE - AC code for curve flags
C
 100	IF (HAD_CURVE_AC .OR. NEG_CURVE_AC) GOTO 10000	! don't do anything
C
	GOTO (110,120) SECMDN			! despatch on secondary command
C
	CALL LSL_PUTMSG(I2MD__UNKCMD,SECNST)	! unknown command
	GOTO 9999
C
 110	IF (.NOT. GET_STRPAR(CURVE_AC_NAME,CURVE_AC_LEN,.TRUE.)) GOTO 5555
	HAD_CURVE_AC = .TRUE.
	GOTO 10000
C
 120	IF (.NOT. CHECK_AC_CODE(INTARG(1))) GOTO 5555
	CURVE_AC_CODE = INTARG(1)
	HAD_CURVE_AC = .TRUE.
	GOTO 10000
C
C PRIORITY_AC NAME - AC name for priority flags
C PRIORITY_AC CODE - AC code for priority flags
C
 200	IF (HAD_PRIO_AC .OR. NEG_PRIO_AC) GOTO 10000	! don't do anything
C
	GOTO (210,220) SECMDN			! despatch on secondary command
C
	CALL LSL_PUTMSG(I2MD__UNKCMD,SECNST)	! unknown command
	GOTO 9999
C
 210	IF (.NOT. GET_STRPAR(PRIO_AC_NAME,PRIO_AC_LEN,.TRUE.)) GOTO 5555
	HAD_PRIO_AC = .TRUE.
	GOTO 10000
C
 220	IF (.NOT. CHECK_AC_CODE(INTARG(1))) GOTO 5555
	PRIO_AC_CODE = INTARG(1)
	HAD_PRIO_AC = .TRUE.
	GOTO 10000
C
C TEXT_AC NAME - AC name for text flags
C TEXT_AC CODE - AC code for text flags
C
 300	IF (HAD_TEXT_AC .OR. NEG_TEXT_AC) GOTO 10000	! don't do anything
C
	GOTO (310,320) SECMDN			! despatch on secondary command
C
	CALL LSL_PUTMSG(I2MD__UNKCMD,SECNST)	! unknown command
	GOTO 9999
C
 310	IF (.NOT. GET_STRPAR(TEXT_AC_NAME,TEXT_AC_LEN,.TRUE.)) GOTO 5555
	HAD_TEXT_AC = .TRUE.
	GOTO 10000
C
 320	IF (.NOT. CHECK_AC_CODE(INTARG(1))) GOTO 5555
	TEXT_AC_CODE = INTARG(1)
	HAD_TEXT_AC = .TRUE.
	GOTO 10000
C
C CORNER_POINT_SEPARATION - no action
C
 400	CONTINUE
	GOTO 10000
C
C CURVE_SEPARATION - no action
C
 500	CONTINUE
	GOTO 10000
C
C CURVE_CHORD - no action
C
 600	CONTINUE
	GOTO 10000
C
C CURVE_DEVIATION - no action
C
 700	CONTINUE
	GOTO 10000
C
C +/- ADD_OFFSET - whether or not to add origin offset
C
 800	IF ((HAD_OFFSET .AND. .NOT. DEF_OFFSET) .OR. NEG_OFFSET) GOTO 10000
C
	HAD_OFFSET = (.NOT. CMDNEG)
	NEG_OFFSET = CMDNEG
C
	GOTO 10000
C
C DIVIDE - IFF coordinate divisor
C
 900	IF (HAD_DIVIDE) GOTO 10000			! don't do anything
C
	HAD_DIVIDE = .TRUE.
	IF (CMDICT .GT. 0) DIVISOR = INTARG(1)
C
	GOTO 10000
C
C Various MAPDATA2I keywords - to be ignored
C
950	CONTINUE
C
	GOTO 10000

C
C CODE - FC definition
C
1000	CONTINUE
C
	IF (FC_NUM .GE. FC_MAX) THEN			! if CODE table full,
	   CALL LSL_PUTMSG(I2MD__MAXCODES,FC_MAX)	! ignore this line
	   GOTO 5555
	ENDIF
C
	IF (.NOT. CHECK_FC(INTARG(1))) GOTO 5555	! ignore an invalid FC
	IF (FIND_FC(INTARG(1))) THEN			! if already got FC,
	   CALL LSL_PUTMSG(I2MD__GOTFC,INTARG(1))	! ignore this line
	   GOTO 5555
	ENDIF
C
	IF (.NOT. GET_STRPAR(THIS_STR,THIS_LEN,.FALSE.)) GOTO 5555
	IF (.NOT. CHECK_MD_CODE(THIS_STR(1:THIS_LEN))) GOTO 5555
C
	FC_NUM = FC_NUM + 1			! increment entry total
	FC_TAB(FC_FC,FC_NUM) = INTARG(1)	! set FC
	FC_TAB(FC_LEN,FC_NUM) = THIS_LEN	! set MAPDATA code length
	FC_STR(FC_NUM) = THIS_STR(1:THIS_LEN)	! set MAPDATA code string
C
	GOTO 10000
C
C Error decoding line
C
5555	CALL LSL_ADDMSG(I2MD__LINEINPAR,LINE)
	LSL_STATUS = I2MD__LINEINPAR		! reduce error status
	GOTO 10000
C
C Failure
C
9999	RDLIN = LSL_STATUS
C
C Return
C
10000	RETURN
	END
