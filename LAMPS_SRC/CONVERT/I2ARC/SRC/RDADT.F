C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-03-06 13:45:00.000000000 +0000
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
	LOGICAL FUNCTION RDADT
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Pinched from ARC2I and modified         ST	 8-Jan-1991
C	Implemented				RJH	 2-Jun-1989
C	Created					RJH	24-Sep-1987
C
C Description
C
C	Reads an attribute description table entry
C
C	Expects the secondary command number just read to be in 
C		SECMDN    in /CMDCOM/
C	    and (if the command was ADT CODE) the AC code to be in 
C		INTARG(1) in /CMDCOM/
C
C	Returns FALSE if something goes wrong with a command line, 
C	TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'HERE:I2ARCMSG.PAR'	    ! message definitions
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
	LOGICAL		ACDFND		! find attribute code
	LOGICAL		ACDFND_NAME	! find attribute name
	LOGICAL		RDNAM		! read attribute name
!	LOGICAL		RDADTTAB	! read table field from paramter file
C
C Local Variables
C
	CHARACTER*(ACD_NAME_MAX) THIS_NAME	! an attribute name
	INTEGER*4		 L		! its length
	INTEGER*4		 RESULT		! command read result
C
C External declaration
C
	INTEGER*4	FLDCMD_CMD_TABLE
	EXTERNAL	FLDCMD_CMD_TABLE
C
C-------------------------------------------------------------------------------
C
C Assume that everything goes well
C
	RDADT = .TRUE.
C
C and get ready for a new attribute description
C
	ATTR_PTR = ATTR_PTR + 1
C
C Despatch according to secondary command
C
	GOTO (100,200) SECMDN
	CALL LSL_PUTMSG(I2ARC__UNKCMD,SECNST)	! unknown command
	GOTO 9999
C
C ADT CODE - we have already read the code so check that it is in range 
C
100	IF ( INTARG(1).LT.0 .OR. INTARG(1).GT.MAX_WORD ) THEN
	   CALL LSL_PUTMSG(I2ARC__BADATTCODE,INTARG(1))
	   GOTO 9999
	ENDIF
C
C and get its details
C
	IF (ACDFND(INTARG(1),.FALSE.)) THEN
	   CALL LSL_PUTMSG(I2ARC__DEFAULTACD,INTARG(1))
	ENDIF
C
	GOTO 300
C
C ADT NAME - read in the attribute name
C
200	IF (.NOT. RDNAM(THIS_NAME,L)) GOTO 9999
C
C and get its details
C
	IF (ACDFND_NAME(THIS_NAME(1:L))) THEN
	   CALL LSL_PUTMSG(I2ARC__BADATTNAME,THIS_NAME(1:L))
	   GOTO 9999
	ENDIF
C
C Now save the appropriate things
C
300	ATTR_TAB(ATTR_COD,ATTR_PTR) = ACD_CODE
	ATTR_TAB(ATTR_TYP,ATTR_PTR) = ACD_DATA_TYPE
C
C Read the command describing the field in the IFF entry
C
	RESULT = RDCOMM(FLDCMD_CMD_TABLE)
	IF (RESULT .LE. 0) GOTO 9999
C
	GOTO (400) RESULT			! and despatch
	CALL LSL_PUTMSG(I2ARC__UNKCMD,CMDNST)	! unknown command
	GOTO 9999
C
400	GOTO (410,420) SECMDN			! despatch again
	CALL LSL_PUTMSG(I2ARC__UNKCMD,SECNST)	! unknown command
	GOTO 9999
C
C AC VALUE - just set the field indicator
C
410	ATTR_TAB(ATTR_FLD,ATTR_PTR) = AC_VAL
	GOTO 600
C
C AC TEXT - set the field indicator, and leave the type unset
C
420	ATTR_TAB(ATTR_FLD,ATTR_PTR) = AC_TEXT
	ATTR_TAB(ATTR_TYP,ATTR_PTR) = UNSET_VAL
	GOTO 600
C
C Read in the EXPORT attribute name
C
600	IF (.NOT. RDNAM(ATTR_NAM(ATTR_PTR),L)) GOTO 9999
C
!	IF (.NOT. RDADTTAB() ) GOTO 9999
C
C and finish
C
	GOTO 9000			! success
C
C Errors
C
9999	RDADT = .FALSE.			! failure
	ATTR_PTR = ATTR_PTR - 1		! no need to unset anything else
C
C Return
C
9000	RETURN
	END
