C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-02-16 18:01:44.000000000 +0000
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
	LOGICAL FUNCTION RDANNO
C
CDEC$	IDENT	'16FE93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Pinched from RDANNO and modified	ST		16-Feb-1993
C
C Description
C
C	Reads an annotation description table entry
C	Returns FALSE if something goes wrong with a command line, 
C	TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'HERE:ARC2IMSG.PAR'	    ! message definitions
C
C Common Blocks
C
	INCLUDE 'HERE:TABLES.CMN'	! translation tables
	INCLUDE	'LSL$CMNFRT:FRTACD.CMN'	! FRT ACD common block
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
C
C Local Variables
C
	INTEGER*4		 RESULT		! command read result
C
C External declaration
C
	INTEGER*4	LEVSYMCMD_CMD_TABLE
	EXTERNAL	LEVSYMCMD_CMD_TABLE
C
C------------------------------------------------------------------------------
C
C Assume that everything goes well
C
	RDANNO = .TRUE.
C
C and get ready for a new attribute description
C
	ANNO_PTR = ANNO_PTR + 1
C
C Despatch according to secondary command
C
	GOTO (100) SECMDN
	CALL LSL_PUTMSG(ARC2I__UNKCMD,SECNST)	! unknown command
	GOTO 9999
C
C ANNO FC - we have already read the code so check that it is in range 
C
100	IF ( INTARG(1).LT.0 .OR. INTARG(1).GT.MAX_WORD ) THEN
	   CALL LSL_PUTMSG(ARC2I__BADFCODE,INTARG(1))
	   GOTO 9999
	ENDIF
C
C Now save the appropriate things
C
	ANNO_TAB(ANNO_FC,ANNO_PTR) = INTARG(1)
C
C See if LEVEL command was given
C
	ANNO_TAB(ANNO_SYM,ANNO_PTR) = -1
	ANNO_TAB(ANNO_LEV,ANNO_PTR) = -1
	RESULT = RDCOMM(LEVSYMCMD_CMD_TABLE)		! try for LEVEL cmd
	IF (RESULT .GT. 0) THEN
	   ANNO_TAB(RESULT+1,ANNO_PTR) = INTARG(1)
	   RESULT = RDCOMM(LEVSYMCMD_CMD_TABLE)		! try for SYMBOL cmd
	   IF (RESULT .GT. 0) THEN
	      ANNO_TAB(RESULT+1,ANNO_PTR) = INTARG(1)
	   ENDIF
	   GOTO 9000
	ENDIF
C
	CALL LSL_PUTMSG(ARC2I__MISSCMD,CMDNST)	! unknown command
	GOTO 9999
C
C Errors
C
9999	RDANNO = .FALSE.		! failure
	ANNO_PTR = ANNO_PTR - 1		! no need to unset anything else
C
C Return
C
9000	RETURN
	END
