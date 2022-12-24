C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-03-05 12:16:14.000000000 +0000
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
	SUBROUTINE CREATE_FILLS(SEG1,SEG2,SEG3,SEG4,ST_ADDR,FC)
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Oct-1991
C
C Description:
C       Routine to create road fills. Calls PROCESS to generate an offset on
C	each side of the line and either splices the ends or creates a straight
C	end depending on the road priority
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
	INTEGER*4	I,PTR_SAV            ! general
	INTEGER*2	FC1,FC2,FC3,FC4      ! FCs of joining lines
	INTEGER*4	PRI,PR1,PR2,PR3,PR4  ! Priorities of above
	REAL*4		TEMP,WID             ! temp and current line width
	REAL*4		ZO1(2,4),ZO2(2,4)    ! buffers for triangular pieces
	LOGICAL*4	TRIANG1,TRIANG2      ! are triangs needed at each end
	LOGICAL*4	OK
C
C------------------------------------------------------------------------------
C
C Reset global pointers of input and output buffers and no triangs present
C
	OPTR=0
	IPTR=0
	TRIANG1=.FALSE.
	TRIANG2=.FALSE.
C
C Obtain priority and width of area for line to be processed
C
	WID=AREAWIDTH(FC)
	PRI=PRIORITY(FC)
C
C Get original line (fills ZIN buffer)
C
	OK=GET_FTR(IPTR,ST_ADDR)
	IF (.NOT.OK) GOTO 999
C
C Get the FCs for the end segments
C
	CALL GET_FC(SEG1(1),FC1)
	CALL GET_FC(SEG2(1),FC2)
	CALL GET_FC(SEG3(1),FC3)
	CALL GET_FC(SEG4(1),FC4)
C
C Use FC to get priority
C
	PR1 = PRIORITY(FC1)
	PR2 = PRIORITY(FC2)
	PR3 = PRIORITY(FC3)
	PR4 = PRIORITY(FC4)
C
C For debugging purposes
C
C	CALL WRITEF('FEAT %^W%I JOINS SEG WITH FC %I & PRI %^L%I',NF,FC1,PR1)
C	CALL WRITEF('FEAT %^W%I JOINS SEG WITH FC %I & PRI %^L%I',NF,FC2,PR2)
C	CALL WRITEF('FEAT %^W%I JOINS SEG WITH FC %I & PRI %^L%I',NF,FC3,PR3)
C	CALL WRITEF('FEAT %^W%I JOINS SEG WITH FC %I & PRI %^L%I',NF,FC4,PR4)
C
C Generate offset to right of line using SEG1 and SEG2 (fills ZOUT buffer)
C
	CALL PROCESS(SEG1,SEG2,ST_ADDR,WID,2)    ! 2 means use area width
C
	IF (PR2.EQ.PR3) THEN
	   IF (PRI.GE.PR2) THEN                  ! splice ends
	      IF (SEG2(1).NE.ST_ADDR) THEN
		 OPTR=OPTR+1
		 ZOUT(1,OPTR)=ZIN(1,IPTR)
		 ZOUT(2,OPTR)=ZIN(2,IPTR)
	      ENDIF
	   ELSE                          ! str end and create a triangular area
	      ZO1(1,1)=ZOUT(1,OPTR)
	      ZO1(2,1)=ZOUT(2,OPTR)
	      ZO1(1,2)=ZIN(1,IPTR)
	      ZO1(2,2)=ZIN(2,IPTR)
	      ZO1(1,4)=ZOUT(1,OPTR)
	      ZO1(2,4)=ZOUT(2,OPTR)
	      TRIANG1=.TRUE.
	      PTR_SAV=OPTR+1
	   ENDIF
	ELSE                                     ! splice ends
	   OPTR=OPTR+1
	   ZOUT(1,OPTR)=ZIN(1,IPTR)
	   ZOUT(2,OPTR)=ZIN(2,IPTR)
	ENDIF
C
C Reverse line (reverses ZIN buffer)
C
	DO 50 I=1,(IPTR)/2
	   TEMP=ZIN(1,I)
	   ZIN(1,I)=ZIN(1,IPTR+1-I)
	   ZIN(1,IPTR+1-I)=TEMP
	   TEMP=ZIN(2,I)
	   ZIN(2,I)=ZIN(2,IPTR+1-I)
	   ZIN(2,IPTR+1-I)=TEMP
50	CONTINUE
C
C Generate offset to right of reversed line using SEG3 and SEG4 (fills ZOUT)
C
	CALL PROCESS(SEG3,SEG4,ST_ADDR,WID,2)    ! 2 means use area width
C
C Since the line is reversed, ZIN(1,IPTR) is now the first point!
C
	IF (PR1.EQ.PR4) THEN
	   IF (PRI.GE.PR1) THEN                  ! splice ends
	      IF (SEG4(1).NE.ST_ADDR) THEN
		 OPTR=OPTR+1
		 ZOUT(1,OPTR)=ZIN(1,IPTR)
		 ZOUT(2,OPTR)=ZIN(2,IPTR)
	      ENDIF
	   ELSE                          ! str end and create a triangular area
	      TRIANG2=.TRUE.
	   ENDIF
	ELSE
	   OPTR=OPTR+1
	   ZOUT(1,OPTR)=ZIN(1,IPTR)
	   ZOUT(2,OPTR)=ZIN(2,IPTR)
	ENDIF
C
C Join up last point
C
	OPTR=OPTR+1
	ZOUT(1,OPTR)=ZOUT(1,1)
	ZOUT(2,OPTR)=ZOUT(2,1)
C
C output feature (writes ZOUT buffer)
C
	CALL PUT_FTR(AREACODE(FC))
C
C Finish off filling triangle buffers
C
	IF (TRIANG1) THEN
	   ZO1(1,3)=ZOUT(1,PTR_SAV)
	   ZO1(2,3)=ZOUT(2,PTR_SAV)
	ENDIF
C
	IF (TRIANG2) THEN
	   ZO2(1,1)=ZOUT(1,OPTR-1)
	   ZO2(2,1)=ZOUT(2,OPTR-1)
	   ZO2(1,2)=ZIN(1,IPTR)
	   ZO2(2,2)=ZIN(2,IPTR)
	   ZO2(1,3)=ZOUT(1,OPTR)  ! or ZO2(1,3)=ZOUT(1,1)  
	   ZO2(2,3)=ZOUT(2,OPTR)  ! or ZO2(2,3)=ZOUT(2,1)  
	   ZO2(1,4)=ZOUT(1,OPTR-1)
	   ZO2(2,4)=ZOUT(2,OPTR-1)
	   OPTR=4
C
C Copy Traingle 2 to ZOUT
C
	   DO 100 I=1,OPTR        ! overwriting ZOUT to pass to PUT_FTR
	      ZOUT(1,I)=ZO2(1,I)
	      ZOUT(2,I)=ZO2(2,I)
100	   CONTINUE
C
C Write triangular feature in same FC as either of joining arms.
C
	   CALL PUT_FTR(AREACODE(FC1))
	ENDIF
C
	IF (TRIANG1) THEN
C
C Copy Traingle 2 to ZOUT
C
	   OPTR=4
	   DO 200 I=1,OPTR
	      ZOUT(1,I)=ZO1(1,I)
	      ZOUT(2,I)=ZO1(2,I)
200	   CONTINUE
C
C Write triangular feature in same FC as either of joining arms.
C
	   CALL PUT_FTR(AREACODE(FC2))
	ENDIF
C
999	RETURN
	END
