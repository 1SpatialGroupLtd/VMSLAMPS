C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-03-05 13:16:12.000000000 +0000
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
	SUBROUTINE CREATE_CASINGS(SEG1,SEG2,SEG3,SEG4,ST_ADDR,FC)
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Oct-1991
C
C Description:
C       Routine to create road casings. Calls PROCESS to generate an offset on
C	each side of the line and intersects it with the adjacent junction
C	arm. At present, spurious result occur when short line segment are
C	present at junctions. This is because an intersection is made between
C	the first (or last) segment of the joining line which may be smaller
C	than the offset width.
C
C
	IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
	INCLUDE 'LSL$ICASE:IFFVARS.CMN'
C
C Arguments
C
	INTEGER*4	SEG1(2)    ! addr of arm joining start of line
	INTEGER*4	SEG2(2)    ! addr of arm joining end of line
	INTEGER*4	SEG3(2)    ! addr of arm joining start of reversed line
	INTEGER*4	SEG4(2)    ! addr of arm joining end of reversed line
	INTEGER*4	ST_ADDR    ! address of current line.
	INTEGER*2	FC         ! FC of current line
C
C Functions called
C
	LOGICAL*4	GET_FTR
C
C Local Variables
C
	INTEGER*4	I          ! general loop
	REAL*4		TEMP       ! temporary for reversing line
	REAL*4		WID        ! width of current line
	LOGICAL*4	OK
C
C------------------------------------------------------------------------------
C
C Reset global pointers of input and output buffers
C
	OPTR=0
	IPTR=0
C
C Obtain width of casings for line to be processed
C
	WID=CASEWIDTH(FC)
C
C Get original line (fills ZIN buffer)
C
	OK=GET_FTR(IPTR,ST_ADDR)
	IF (.NOT.OK) GOTO 999
C
C Generate offset to right of line using SEG1 and SEG2 (fills ZOUT buffer)
C
	CALL PROCESS(SEG1,SEG2,ST_ADDR,WID,1)    ! 1 means use casing width
C
C output feature (writes ZOUT buffer)
C
	CALL PUT_FTR(CASECODE(FC))
C
C Reverse line (reverses ZIN buffer)
C
	DO 250 I=1,(IPTR)/2
	   TEMP=ZIN(1,I)
	   ZIN(1,I)=ZIN(1,IPTR+1-I)
	   ZIN(1,IPTR+1-I)=TEMP
	   TEMP=ZIN(2,I)
	   ZIN(2,I)=ZIN(2,IPTR+1-I)
	   ZIN(2,IPTR+1-I)=TEMP
250	CONTINUE
C
C Start filling ZIN buffer from beginning (ie overwrite last offset)
C
	OPTR=0
C
C Generate offset to right of reversed line using SEG3 and SEG4 (fills ZOUT)
C
	CALL PROCESS(SEG3,SEG4,ST_ADDR,WID,1)    ! 1 means use casing width
C
C output feature (writes ZOUT buffer)
C
	CALL PUT_FTR(CASECODE(FC))
C
999	RETURN
	END


