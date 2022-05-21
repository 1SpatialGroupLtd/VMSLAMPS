C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-06 15:37:34.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	INTEGER*4 FUNCTION RDLIN(LINE)
C
CDEC$	IDENT	'06OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created (based on AUTOTEXT READ_LINE)		ST	12-Sep-1994
C
C	CONVERT MAPDATA2I Utility - Decode line in parameter file
C
C Description
C
C	Decodes a line in the parameter file which relates IFF feature codes
C	to MAPDATA feature codes.
C
C	Returns the error code held in LSL_STATUS if something drastic goes
C	wrong, LSL__NORMAL otherwise. For ordinary errors, LSL_STATUS is
C	reduced to MD2I__LINEINPAR, so that we can attempt to continue with
C	the file.
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'LSL$CMNFRT:FRTCOM.CMN'		! FRT definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'	! LSLLIB string reading
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! message definitions
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
	INCLUDE 'CMN:TOLERANCES.CMN'		! for smoothing tolerances
	INCLUDE 'CMN:FILE.CMN'			! parameter tables
	INCLUDE	'CMN:IFF.CMN'      		! control variables
C
C Functions called
C
	INTEGER*4	RDCOMM			! read a command
	INTEGER*4	READSTR			! read a string
C
	LOGICAL		FRTFND			! find FC in FRT
	LOGICAL		GET_STRPAR		! get string parameter
	LOGICAL		CHECK_AC_CODE		! check AC code is valid
	LOGICAL		CHECK_FC		! check FC is valid
	LOGICAL		CHECK_MD_CODE		! check MAPDATA code is valid
	LOGICAL         SIGCHS
C
C Local Variables
C
	INTEGER*4		IN_ADR		! address of input buffer
	INTEGER*4		IN_LEN		! input line length
	CHARACTER*(DEF_TXTLIM)	IN_STR		! input line without comments
C
	INTEGER*4		THIS_LEN	! current string length
	CHARACTER*(NAME_MAX)	THIS_STR	! current string
C
	INTEGER*4		RESULT		! command read result
	INTEGER*4		ERRCOD		! LSLLIB error code
	LOGICAL			FOUNDFC		! we found the FC in FRT
C
C External declarations
C
	INTEGER*4	PARCMD_CMD_TABLE	! parameter command table
	EXTERNAL	PARCMD_CMD_TABLE
	INTEGER*4	CODE_CMD_TABLE		! parameter command table
	EXTERNAL	CODE_CMD_TABLE
C
C------------------------------------------------------------------------------
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
	GOTO (100,200,300,400,500,600,700,800,900,1000,
     &	     1010,1020,1030,1040,2000) RESULT
C
	CALL LSL_PUTMSG(MD2I__UNKCMD,CMDNST)	! unknown command
	GOTO 9999
C
C------------------------------------------------------------------------------
C CURVE_AC NAME - AC name for curve flags
C CURVE_AC CODE - AC code for curve flags
C
100	IF (HAD_CURVE_AC .OR. NEG_CURVE_AC) GOTO 10000	! don't do anything
C
	GOTO (110,120) SECMDN			! despatch on secondary command
C
	CALL LSL_PUTMSG(MD2I__UNKCMD,SECNST)	! unknown command
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
C------------------------------------------------------------------------------
C PRIORITY_AC NAME - AC name for priority flags
C PRIORITY_AC CODE - AC code for priority flags
C
200	IF (HAD_PRIO_AC .OR. NEG_PRIO_AC) GOTO 10000	! don't do anything
C
	GOTO (210,220) SECMDN			! despatch on secondary command
C
	CALL LSL_PUTMSG(MD2I__UNKCMD,SECNST)	! unknown command
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
C------------------------------------------------------------------------------
C TEXT_AC NAME - AC name for text flags
C TEXT_AC CODE - AC code for text flags
C
300	IF (HAD_TEXT_AC .OR. NEG_TEXT_AC) GOTO 10000	! don't do anything
C
	GOTO (310,320) SECMDN			! despatch on secondary command
C
	CALL LSL_PUTMSG(MD2I__UNKCMD,SECNST)	! unknown command
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
C------------------------------------------------------------------------------
C CORNER_POINT_SEPARATION - no action
C
400	IF (HAD_CORNER_SEP) GOTO 9999
	IF (REALAR(1).LT.0.0) THEN		! Check for sensible value
	   CALL LSL_PUTMSG(MD2I__BADVALUE,'CORNER POINT SEPARATION')
	   RDLIN = .FALSE.
	   GOTO 9999
	ELSE
	   SEPARATION_DIST = REALAR(1)
	   HAD_CORNER_SEP = .TRUE.
	ENDIF
	GOTO 10000
C
C------------------------------------------------------------------------------
C CURVE_SEPARATION
C
500	IF (HAD_CURVE_SEP) GOTO 9999
	IF (REALAR(1).LT.0.0) THEN
	   CALL LSL_PUTMSG(MD2I__BADVALUE,'CURVE_SEPARATION')
	   RDLIN = .FALSE.
	   GOTO 9999
	ELSE
	   CURVE_SEP = REALAR(1)
	ENDIF
	GOTO 10000
C
C------------------------------------------------------------------------------
C CURVE_ARC_TO_CHORD
C
600	IF (HAD_CURVE_ARC) GOTO 9999
	IF (REALAR(1).LT.0.0) THEN
	   CALL LSL_PUTMSG(MD2I__BADVALUE,'CURVE_CHORD')
	   RDLIN = .FALSE.
	   GOTO 9999
	ELSE
	   CURVE_ARC = REALAR(1)
	ENDIF
	GOTO 10000
C
C------------------------------------------------------------------------------
C CURVE_ANGULAR_DEVIATION
C
700	IF (HAD_CURVE_ANG) GOTO 9999
	IF (REALAR(1).LT.0.0) THEN
	   CALL LSL_PUTMSG(MD2I__BADVALUE,'CURVE_DEVIATION')
	   RDLIN = .FALSE.
	   GOTO 9999
	ELSE
	   CURVE_ANG = REALAR(1)
	ENDIF
	GOTO 10000
C
C------------------------------------------------------------------------------
C +/- ADD_OFFSET - whether or not to add origin offset
C
800	CONTINUE
	GOTO 10000
C
C------------------------------------------------------------------------------
C DIVIDE - IFF coordinate divisor
C
900	CONTINUE
	GOTO 10000
C
C------------------------------------------------------------------------------
C MULTIPLY - IFF coordinate multiplier
C
1000	IF (HAD_MULT) GOTO 9999
	IF (INTARG(1).EQ.0) THEN
	   CALL LSL_PUTMSG(MD2I__BADVALUE,'MULTIPLY')
	   RDLIN = .FALSE.
	   GOTO 9999
	ELSE
	   SCALE_FACTOR = INTARG(1)
	ENDIF
	GOTO 10000
C
C------------------------------------------------------------------------------
C SCALE - IFF MD Scale
C
1010	IF (HAD_SCALE) GOTO 9999
	IF (INTARG(1).LT.0) THEN		! Check for sensible value
	   CALL LSL_PUTMSG(MD2I__BADVALUE,'SCALE')
	   GOTO 5555
	ENDIF
	SCALE = INTARG(1)
	GOTO 10000
C
C------------------------------------------------------------------------------
C OFFSET - Origin offset value to subtract from coordinates
C
1020	IF (HAD_OFFSET) GOTO 9999
	XOFF = REALAR(1)	! Nothing to check. If rubbish was given, the
	YOFF = REALAR(2)	! values will be zero anyway.
	GOTO 10000
C
C------------------------------------------------------------------------------
C DEFAULT_LINE_FC - to be used if feature code not present in parameter file
C
1030	IF (HAD_DEF_LINE) GOTO 9999
	IF (.NOT. CHECK_FC(INTARG(1))) GOTO 5555 ! ignore an invalid FC
	DEF_LINE_FC = INTARG(1)
	GOTO 10000
C
C------------------------------------------------------------------------------
C DEFAULT_SYMBOL_FC - to be used if feature code not present in parameter file
C
1040	IF (HAD_DEF_SYM) GOTO 9999
	IF (.NOT. CHECK_FC(INTARG(1))) GOTO 5555 ! ignore an invalid FC
	DEF_SYM_FC = INTARG(1)
	GOTO 10000
C
C------------------------------------------------------------------------------
C
C CODE - FC definition
C
2000	IF (FC_CNT.GE.MAXENT) THEN			! if CODE table full,
	   CALL LSL_PUTMSG(MD2I__TOOMNYDEFS,MAXENT)	! ignore this line
	   GOTO 5555
	ENDIF
C
C Check the FC held in INTARG
C
	IF (.NOT. CHECK_FC(INTARG(1))) GOTO 5555	! ignore an invalid FC
C
C Get a string fromthe parameter file
C
	IF (.NOT. GET_STRPAR(THIS_STR,THIS_LEN,.FALSE.)) GOTO 5555
C
C Check the MapData feature code is of the correct form
C
	IF (.NOT. CHECK_MD_CODE(THIS_STR(1:THIS_LEN))) GOTO 5555
C
C Store the feature codes
C
	FC_CNT = FC_CNT + 1
	IFF_FC(1,FC_CNT)  = INTARG(1)
	IFF_FC(2,FC_CNT)  = 0
	MAPDATA_FC(FC_CNT) = THIS_STR(1:THIS_LEN)
C
C See if this IFF FC is found in the FRT
C
	FOUNDFC = .NOT.FRTFND(IFF_FC(1,FC_CNT),.FALSE.)
C
C Set up an auxiliary buffer to read the feature interpretation keyword
C
	IN_STR(1:DEF_TXTLIM) = IN_STR(DCPTR+1:DEF_TXTLIM)
	IF (SIGCHS(IN_STR).GT.0) THEN
	   IN_LEN = IN_LEN - DCPTR
	   IN_ADR = %LOC(IN_STR)
	   CALL SETAUX(%VAL(IN_ADR),IN_LEN)
	ELSE
	   IN_LEN = 0
	ENDIF
C
C There's no way to destinguish between the result of RDCOMM being
C garbage and being missing (ie UNDEFINED) so we kludge it based on
C the number of characters in the string
C
	IF (IN_LEN.LE.1) GOTO 2040
C
C Read the command from the line
C
	NOMESS = .FALSE.			! ensure messages are output
	RESULT = RDCOMM(CODE_CMD_TABLE)
	IF (RESULT .LE. 0) GOTO 5555
C
	GOTO (2010,2020,2030) RESULT
C
	CALL LSL_PUTMSG(MD2I__UNKCMD,CMDNST)	! unknown command
	GOTO 9999
C
C CURVE keyword given
C
2010	INTERP(FC_CNT) = INTERP_CURVE
C
C If the FC was defined then check it is the correct GT. If it's not defined
C then the default FC is used and it's not our problem if it's the wrong GT.
C
	IF (FOUNDFC .AND.FRTGT.NE.CURTYP) THEN
	   CALL LSL_PUTMSG(MD2I__FEATNOTCURV,THIS_STR(1:THIS_LEN))
	ENDIF
	GOTO 10000
C
C STRAIGHT keyword given
C
2020	INTERP(FC_CNT) = INTERP_STRAIGHT
C
C If the FC was defined then check it is the correct GT. If it's not defined
C then the default FC is used and it's not our problem if it's the wrong GT.
C
	IF (FOUNDFC .AND. FRTGT.NE.LINTYP .AND. FRTGT.NE.ARETYP) THEN
	   CALL LSL_PUTMSG(MD2I__FEATNOTSTR,THIS_STR(1:THIS_LEN))
	ENDIF
	GOTO 10000
C
C BREAK keyword given
C
2030	INTERP(FC_CNT) = INTERP_BREAK
C
C If the FC was defined then check it is the correct GT. If it's not defined
C then the default FC is used and it's not our problem if it's the wrong GT.
C
	IF (FOUNDFC .AND. FRTGT.NE.LINTYP) THEN
	   CALL LSL_PUTMSG(MD2I__FEATNOTSTR,THIS_STR(1:THIS_LEN))
	ENDIF
C
C Check the FC held in INTARG
C
	IF (.NOT. CHECK_FC(INTARG(1))) GOTO 5555	! ignore an invalid FC
C
	IFF_FC(2,FC_CNT) = INTARG(1)
C
C See if this IFF FC is found in the FRT
C
	FOUNDFC = .NOT.FRTFND(IFF_FC(2,FC_CNT),.FALSE.)
C
C
C Check the GT. It really should be 6.
C
	IF (FOUNDFC .AND.FRTGT.NE.CURTYP) THEN
	   CALL LSL_PUTMSG(MD2I__FEATNOTCURV,THIS_STR(1:THIS_LEN))
	ENDIF
C
	GOTO 10000
C
C no keyword given
C
2040	INTERP(FC_CNT) = INTERP_UNDEFINED
	GOTO 10000
C
C Error decoding line
C
5555	CALL LSL_ADDMSG(MD2I__LINEINPAR,LINE)
	LSL_STATUS = MD2I__LINEINPAR		! reduce error status
	GOTO 10000
C
C Failure
C
9999	RDLIN = LSL_STATUS
C
C------------------------------------------------------------------------------
C Return
C
10000	RETURN
	END
