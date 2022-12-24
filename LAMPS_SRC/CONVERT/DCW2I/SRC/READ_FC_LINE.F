C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-04 16:07:20.000000000 +0100
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
	LOGICAL FUNCTION READ_FC_LINE(LINE)
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	9-June-1992
C
C Description:
C
C	Function to read a line of the feature code file and store it away
C	Function returns .TRUE. if all is well, .FALSE. if an error
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'
C
C Functions
C
	LOGICAL		STORE_FC_INFO	! stuff the data away
	LOGICAL		RDCHS		! read next character
	LOGICAL		RDLONG		! read long int
	INTEGER*4	READSTR
C
C Local workspace
C
	INTEGER*4	LEN
	INTEGER*4	LINE
	INTEGER*4	CODE
	INTEGER*4	FCODE
	LOGICAL*4	OK
	CHARACTER*40	VPFTABLE
	CHARACTER*40	PNAME
	CHARACTER*40	SNAME
	INTEGER*4	PVAL
	INTEGER*4	SVAL
	LOGICAL*4	HAD_PNAME
	LOGICAL*4	HAD_SNAME
C
C ......................................................................
C
	READ_FC_LINE =.TRUE.		! assume success
C
C Read the Feature Code
C
	IF (RDLONG(CODE)) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTREAD,'Feature Code',LINE)
	   GOTO 500
	ENDIF
	IF (CODE.LT.0 .OR. CODE.GT.32767) THEN
	   CALL LSL_PUTMSG(DCW2I__OUTOFRANGE,'Feature code',CODE,LINE)
	   GOTO 500
	ENDIF
	FCODE = CODE
C
C Read VPF feature table
C
	LEN = READSTR(VPFTABLE,,ON_SPACE,,)
	IF (LEN.EQ.0) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTREAD,'VPF table name',LINE)
	   GOTO 500
	ENDIF
	LEN=LEN+1
	VPFTABLE(LEN:LEN)=CHAR(0)
	CALL STR$UPCASE(VPFTABLE,VPFTABLE)
C
C Read primary attribute name
C
	LEN = READSTR(PNAME,,ON_SPACE,,)
	HAD_PNAME = .NOT.(LEN.EQ.0)
	IF (HAD_PNAME) THEN
	   LEN=LEN+1
	   PNAME(LEN:LEN)=CHAR(0)
	   CALL STR$UPCASE(PNAME,PNAME)
	ENDIF
C
C Read primary attribute value
C
	IF (RDLONG(PVAL)) THEN
	   IF (HAD_PNAME) THEN
	      CALL LSL_PUTMSG(DCW2I__CANTREAD,'primary attribute value',LINE)
	      GOTO 500
	   ENDIF
	ENDIF
C
C Read secondary attribute name
C
	LEN = READSTR(SNAME,,ON_SPACE,,)
	HAD_SNAME = .NOT.(LEN.EQ.0)
	IF (HAD_SNAME) THEN
	   LEN=LEN+1
	   SNAME(LEN:LEN)=CHAR(0)
	   CALL STR$UPCASE(SNAME,SNAME)
	ENDIF
C
C Read secondary attribute value
C
	IF (RDLONG(SVAL)) THEN
	   IF (HAD_SNAME) THEN
	      CALL LSL_PUTMSG(DCW2I__CANTREAD,'secondary attribute value',LINE)
	      GOTO 500
	   ENDIF
	ENDIF
C
C Clear strings if nothing in them, so previous values don't carry over.
C
	IF (.NOT.HAD_PNAME) PNAME(1:1)=CHAR(0)
	IF (.NOT.HAD_SNAME) SNAME(1:1)=CHAR(0)
C
C Store it away in the linked list
C
	OK = STORE_FC_INFO(%REF(FCODE),
     &	                   %REF(VPFTABLE),
     &	                   %REF(PNAME),
     &	                   %REF(PVAL),
     &	                   %REF(SNAME),
     &	                   %REF(SVAL))
C
C OK, get next line 
C
	GOTO 999
C
C ......................................................................
C
500	READ_FC_LINE = .FALSE.
999	RETURN
	END
