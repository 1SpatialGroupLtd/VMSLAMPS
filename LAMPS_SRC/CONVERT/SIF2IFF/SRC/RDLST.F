C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-07-02 13:57:26.000000000 +0100
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
	LOGICAL FUNCTION RDLST
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF LST command
C
C Description
C
C	Read parameters of SIF LST command
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'    ! reading strings
C
C Common Blocks
C
	INCLUDE 'CMN:FLAGS.CMN'
	INCLUDE 'CMN:SIF2IFF.CMN'
	INCLUDE 'CMN:IFF_FEATURE.CMN'
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'	! text buffer
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDREAL		! read a real
	LOGICAL		FINDFC		! find a feature code
	LOGICAL		READSTR		! read a string
	LOGICAL		READ_SEP	! read a seperator
	LOGICAL		RDCHS		! read a character - skip spaces
	LOGICAL		RDCH		! read a character
	LOGICAL		GET_XYZ		! process coord string
	LOGICAL		SKIP_CONTLIN	! skip following continuation lines
	LOGICAL		CONT_LINE	! test for continuation line
C
C Local Variables
C
	INTEGER*4	LEN		! string length
	CHARACTER*80	DUMSTR		! dummy character string
	INTEGER*4	RESULT		! command read result
	LOGICAL		OK		! function return status
	LOGICAL		NOREAL		! flag returned real
	LOGICAL		EOLN		! end of line flag
	INTEGER		AXIS		! flag x or y axis
	REAL		RDUMMY		! dummy real
	REAL		X,Y,Z		! coords
	BYTE		ICH		! ASCII character
C
C External declaration
C
	INTEGER*4	LSTCMD_CMD_TABLE
	EXTERNAL	LSTCMD_CMD_TABLE
C
C Assume that everything goes well
C
	NOMESS = .TRUE.
	RDLST = .TRUE.
	IF (HAD_EST) THEN
	   GOTO 600	    !complex string ended so create feature
	ENDIF
C
	IS_LINE = .TRUE.
C
C Now, read the command from the line
C
500	RESULT = RDCOMM(LSTCMD_CMD_TABLE)
C
C and check that there was one. If not assume OP
C
	NOMESS = .FALSE.
	IF (RESULT .LE. 0) THEN
	   DCPTR = 5
	   GOTO 510
	ENDIF
C
C Look for ','  seperator - send warning mess if not found
C
	OK = READ_SEP(',')
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
C Unknown command - assume OP
C
	CONTINUE
C
C OP -
C
510     GOTO 600	
C
C SO -  closed shape
C
520	IS_AREA = .TRUE.
	IS_LINE = .FALSE.
	GOTO 600
C
C HO - NOT YET IMPLEMENTED
C
530	GOTO 600
C
C DE - dimension element - not applicable. OP could be next so
C get more of the line
C
540	LEN = READSTR(DUMSTR,',',ON_CHAR)
	GOTO 500
C
600	CONTINUE
C
	IF (HAD_PTN) THEN
	   LINPAT = 0
	   AREAPAT = 0
	ENDIF
C
C Find feature code. If not found then output warning mess
C and ignore the feature, skipping any continuation lines
C
	IF (.NOT.HAD_BST) THEN
	   IF (.NOT.FINDFC()) THEN
	      OK = SKIP_CONTLIN()
	      GOTO 9999
	   ENDIF
	ENDIF
C
C	Start the feature
C
	IF (.NOT.HAD_BST) THEN
	   CALL START_FEATURE
	ENDIF
C
C Read coords and store in buffer
C
555	IF (.NOT.GET_XYZ()) THEN
	   IF (DONE_START_FEATURE) CALL IFFDEL
	   DONE_START_FEATURE = .FALSE.
	   GOTO 9999
	ENDIF
C
	EOLN = RDCHS(ICH)
	CALL BSCH
	IF (.NOT.EOLN) GOTO 555
C
C Write the feature
C
	IF (.NOT.HAD_BST) CALL WRITE_FEATURE
C
	GOTO 9000

9999	RDLST = .FALSE.
C
C Return
C
9000	IS_LINE = .FALSE.
	IS_AREA = .FALSE.
	HAD_EST = .FALSE.
	RETURN
	END
