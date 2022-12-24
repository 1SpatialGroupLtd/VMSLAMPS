C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-10-31 16:06:24.000000000 +0000
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
	SUBROUTINE PROCESS(SEGA,SEGB,ST_ADDR,WID,NUM)
C
CDEC$	IDENT	'25OC91'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Oct-1991
C
C Description:
C	Routine to generate an offset on the right on the current line held in
C	the ZIN	buffer. When doing the other side of the line the ZIN buffer
C	will already have been reversed in the calling routine.
C
C
	IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
	INCLUDE 'LSL$ICASE:IFFVARS.CMN'
	INCLUDE 'LSL$ICASE:CMDLIN.CMN'
C
C Arguments
C
	INTEGER*4	SEGA(2)    ! addr of arm joining start of line
	INTEGER*4	SEGB(2)    ! addr of arm joining end of line
	INTEGER*4	ST_ADDR    ! address of current line.
	REAL*4  	WID        ! width of current line.
	INTEGER*4	NUM        ! generate offset with area or case width
C                                  ! 1 = casing width, 2 = road fill width
C Local Variables
C
	REAL*4		WIDA,WIDB  ! width of joining segments
	REAL*4		XJUN,YJUN  ! coord of 2nd point in joining line
	REAL*4		D1,D2
	REAL*4		X1,Y1
	REAL*4		X2,Y2
	REAL*4		X3,Y3
	REAL*4		ZL(2)
	INTEGER*4	NPTS
	INTEGER*4	NOFF
	INTEGER*4	NP
	INTEGER*4	I,J,K
	INTEGER*2	IECODE		! entry code
	INTEGER*2	IELEN		! length of IECODE
	INTEGER*2	IENDS		! pen up/down marker
C
C------------------------------------------------------------------------------
C
C	CALL WRITEF('Right of seg %^W%I is seg with addr %X',NF,SEGA(1))
C	CALL WRITEF('Right of seg %^W%I is seg with addr %X',NF,SEGB(1))
C
	CALL GET_WIDTH(SEGA(1),WIDA,NUM)
	CALL GET_WIDTH(SEGB(1),WIDB,NUM)
C
C	CALL WRITEF('Width of FC with ST %X is %F',SEGA(1),WIDA)
C	CALL WRITEF('Width of FC with ST %X is %F',SEGB(1),WIDB)
C
	OPTR=OPTR+1
C
C Find ST of line joining beginning of current line
C
	CALL IFFPKE(IECODE,IELEN,SEGA(1))
	CALL EIHRS( NPTS, IENDS)
C
C If address of joining end = current ST address then we have an open end
C
	IF (SEGA(1).EQ.ST_ADDR) THEN     ! open end. Simpler.
	   D1=WID
	   D2=D1
	   X1=ZIN(1,1)
	   Y1=ZIN(2,1)
	   X2=ZIN(1,2)
	   Y2=ZIN(2,2)
	   NOFF=2
	   CALL OFFSET(1,NOFF,D1,D2,X1,Y1,X2,Y2,X3,Y3,0.0,0.0,ZOUT(1,OPTR),NP)
	ELSE
	   IF (SEGA(2).EQ.1) THEN
C	      CALL CHECK_PTS(WID,NPTS,XJUN,YJUN,.TRUE.,.TRUE.)
	      CALL EIHRR(XJUN,1,5)
	      CALL EIHRR(YJUN,1,7)
	   ELSE
C             CALL CHECK_PTS(WID,NPTS,XJUN,YJUN,.TRUE.,.FALSE.)
	      CALL EIHRR(XJUN,1,NPTS*4-7)
	      CALL EIHRR(YJUN,1,NPTS*4-5)
	   ENDIF
C
C Fill ZL with points to be used in next call to OFFSET
C
	   D1=WIDA
	   D2=D1
	   X1=XJUN
	   Y1=YJUN
	   X2=ZIN(1,1)
	   Y2=ZIN(2,1)
	   NOFF=2
	   CALL OFFSET(0,NOFF,D1,D2,X1,Y1,X2,Y2,X3,Y3,0.0,0.0,ZL,NP)
C
C Find intersection point at junction arm
C
	   D1=WIDA
	   D2=WID
	   X1=XJUN
	   Y1=YJUN
	   X2=ZIN(1,1)
	   Y2=ZIN(2,1)
	   X3=ZIN(1,2)
	   Y3=ZIN(2,2)
	   NOFF=3
C	   CALL CHECK_PTS(WID,X3,Y3,X2,Y2,X1,Y1)
	   CALL OFFSET(2,NOFF,D1,D2,X1,Y1,X2,Y2,X3,Y3,ZL(1),ZL(2),
     &		       ZOUT(1,OPTR),NP)
	ENDIF
C
C fudge awkward cases
C
200	IF(NP.EQ.0)THEN
	   ZOUT(1,OPTR)=ZL(1)
	   ZOUT(2,OPTR)=ZL(2)
	ELSE IF(NP.GT.1)THEN
	   ZOUT(1,OPTR)=ZOUT(1,NP)
	   ZOUT(2,OPTR)=ZOUT(2,NP)
	ENDIF
C       
C Process interior points
C       
	DO 40 I=2,IPTR-1
	   X1=ZIN(1,I-1)
	   Y1=ZIN(2,I-1)
	   X2=ZIN(1,I)
	   Y2=ZIN(2,I)
	   X3=ZIN(1,I+1)
	   Y3=ZIN(2,I+1)
	   D1=D2
	   D2=WID
	   NOFF=3
	   CALL OFFSET(0,NOFF,D1,D2,X1,Y1,X2,Y2,X3,Y3,
     &		       ZOUT(1,OPTR),ZOUT(2,OPTR),ZOUT(1,OPTR+1),NP)
	   OPTR=OPTR+NP
40	CONTINUE
C
C Get segment joining other end
C
	CALL IFFPKE(IECODE,IELEN,SEGB(1))
	CALL EIHRS( NPTS, IENDS)
C
	IF (SEGB(2).EQ.1) THEN
C	   CALL FIND_PTS(WID,NPTS,XJUN,YJUN,.FALSE.,.TRUE.)
	   CALL EIHRR(XJUN,1,5)
	   CALL EIHRR(YJUN,1,7)
	ELSE
C	   CALL FIND_PTS(WID,NPTS,XJUN,YJUN,.FALSE.,.FALSE.)
	   CALL EIHRR(XJUN,1,NPTS*4-7)
	   CALL EIHRR(YJUN,1,NPTS*4-5)
	ENDIF
C
	IF (SEGB(1).EQ.ST_ADDR) THEN
	   NOFF=-2                         ! open end. Only two points reqd
	ELSE
	   NOFF=3
	ENDIF
C
C process last point
C
	X1=ZIN(1,IPTR-1)
	Y1=ZIN(2,IPTR-1)
	X2=ZIN(1,IPTR)
	Y2=ZIN(2,IPTR)
	X3=XJUN
	Y3=YJUN
	D1=D2
	D2=WIDB
C	IF (NOFF.EQ.3) CALL CHECK_PTS(WID,X1,Y1,X2,Y2,X3,Y3)
	CALL OFFSET(1,NOFF,D1,D2,X1,Y1,X2,Y2,X3,Y3,
     &		   ZOUT(1,OPTR),ZOUT(2,OPTR),ZOUT(1,OPTR+1),NP)
	OPTR=OPTR+NP
C
	RETURN
	END
