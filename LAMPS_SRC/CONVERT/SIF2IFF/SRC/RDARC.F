C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-07-02 12:41:02.000000000 +0100
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
	LOGICAL FUNCTION RDARC
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF ARC command
C
C Description
C
C	Read parameters of SIF ARC command
C
C	Returns FALSE for error in SIF command line
C
C	Forms of the ARC command:
C
C		1. ARC/CC,DE=dimele,CE=xc,yc,P1=x1,y1,P2=x2,y2,
C						MA=t11,t21,t12,t22
C		2. ARC/CL,CE=xc,yc,P1=x1,y1,P2=x2,y2,
C						MA=t11,t21,t12,t22
C		3. ARC/P1=x1,y1,P2=x2,y2,P3=x3,y3,
C						MA=t11,t21,t12,t22
C		4. ARC/DE=dimele,P1=x1,y1,P2=x2,y2,P3=x3,y3,
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
	INCLUDE 'CMN:SIF2IFF.CMN'
	INCLUDE 'CMN:FLAGS.CMN'
	INCLUDE 'CMN:IFF_FEATURE.CMN'
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDLONG		! read an integer
	LOGICAL		RDREAL		! read a real 
	LOGICAL		FINDFC		! find a feature code
	LOGICAL		READ_SEP	! read a seperator
	LOGICAL		RDCHS		! read a character
	LOGICAL		CONT_LINE	! test for continuation line
	LOGICAL		READSTR		! read a string
	LOGICAL		SKIP_CONTLIN	! skip over continuation lines
C
C Local Variables
C
	CHARACTER*80	DUMSTR		! dummy character string
	INTEGER*4	LEN		! string length
	INTEGER*4	N		! digit in P1, P2 or P3
	INTEGER*4	RESULT		! command read result
	LOGICAL		EOLN		! end of line flag
	LOGICAL		OK		! function return status
	LOGICAL		NOLONG		! flag returned integer
	LOGICAL		NOREAL		! flag returned real
	LOGICAL		ARC_TYPE1	! type of ARC command
	LOGICAL		ARC_TYPE2	! type of ARC command
	LOGICAL		ARC_TYPE3	! type of ARC command
	INTEGER		P1X,P1Y,P1Z,P2X	! points on arc
	INTEGER		P2Y,P2Z,P3X,P3Y	! points on arc
	INTEGER		P3Z		! points on arc
	INTEGER		CX,CY,CZ	! arc centre
	REAL		X,Y,Z		! REAL coords
	REAL		RDUMMY		! dummy real 
	BYTE		ICH		! byte character
	LOGICAL		HAD_CC		! true if CC keyword had
	LOGICAL		HAD_CL		! true if CL keyword had
C
C External declaration
C
	INTEGER*4	ARCCMD_CMD_TABLE
	EXTERNAL	ARCCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDARC = .TRUE.
C
	IS_ARC = .TRUE.			
	ARC_TYPE1 = .FALSE.
	ARC_TYPE2 = .FALSE.
	ARC_TYPE3 = .FALSE.
	HAD_CC = .FALSE.
	HAD_CL = .FALSE.
C
C Now, read the command from the line
C
500	RESULT = RDCOMM(ARCCMD_CMD_TABLE)
C
C and check that there was one.
C
	IF (RESULT .LE. 0) GOTO 9999
C
C The digits in the P1,P2 AND P3 parameters must be read seperateley as
C RDCOMM does not allow digits in commands.
C
	IF (RESULT.EQ.6) THEN
	   OK = RDLONG(N)
	   IF (N.EQ.2) RESULT = 7
	   IF (N.EQ.3) RESULT = 8
	ENDIF
C
C Look for ',' or '=' seperator - send warning mess if not found
C
	OK = READ_SEP(',')
	IF (.NOT.OK) THEN
	   CALL BSCH
	   OK = READ_SEP('=')
	   IF (.NOT.OK) THEN
	      CALL LSL_PUTMSG(SIF2IFF__SEPNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	ENDIF
C
C test for continuation line
	IF (.NOT.CONT_LINE()) GOTO 9999
C
C Despatch according to command
C
	GOTO (510,520,530,540,550,560,570,580) RESULT
C
C Unknown command -
C
	CALL LSL_PUTMSG(SIF2IFF__UNKCMD,CMDNST)
	GOTO 9999
C
C CC - counter clockwise
C
510     ARCDIR = -1
	HAD_CC = .TRUE.
	ARC_TYPE1 = .TRUE.
	GOTO 500	
C
C CE - arc centre
C
520	NOLONG = RDLONG(CX)
	OK = READ_SEP(',')
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	NOLONG = RDLONG(CY)
	OK = READ_SEP(',')
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	IF (DIMEN.EQ.3) THEN				! 3D
	   NOLONG = RDLONG(CZ)
	   IF (NOLONG) THEN
	      CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	   OK = READ_SEP(',')
	   IF (.NOT.CONT_LINE()) GOTO 9999
	ENDIF
	GOTO 500	
C
C CL - clockwise
C
530     ARCDIR = 1
	HAD_CL = .TRUE.
	ARC_TYPE2 = .TRUE.
	GOTO 500	
C
C MA - ignore matrix
C
540	GOTO 600
C
C DE - dimension element - ignore
C
550	LEN = READSTR(DUMSTR,',',ON_CHAR)
	GOTO 500
C
C P1 - point on arc
C
560     NOLONG = RDLONG(P1X)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	NOLONG = RDLONG(P1Y)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	IF (DIMEN.EQ.3) THEN				! 3D
	   NOLONG = RDLONG(P1Z)
	   IF (NOLONG) THEN
	      CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	   OK = READ_SEP(',')
	   IF (.NOT.CONT_LINE()) GOTO 9999
	ENDIF
	IF (.NOT.CONT_LINE()) GOTO 9999
	GOTO 500	
C
C P2 - point on arc
C
570     NOLONG = RDLONG(P2X)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	NOLONG = RDLONG(P2Y)
	OK = READ_SEP(',')
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	IF (DIMEN.EQ.3) THEN
	   NOLONG = RDLONG(P2Z)
	   IF (NOLONG) THEN
	      CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	   OK = READ_SEP(',')
	   IF (.NOT.CONT_LINE()) GOTO 9999
	ENDIF
	IF (ARC_TYPE1.OR.ARC_TYPE2) GOTO 600	! all we need for type 1 or 2
	GOTO 500
C
C P3 - 
C
580	NOLONG = RDLONG(P3X)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	NOLONG = RDLONG(P3Y)
	OK = READ_SEP(',')
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	IF (DIMEN.EQ.3) THEN
	   IF (.NOT.CONT_LINE()) GOTO 9999
	   NOLONG = RDLONG(P3Z)
	   IF (NOLONG) THEN
	      CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	ENDIF
	IF (.NOT.OK) THEN
	   EOLN = RDCHS(ICH)
	   IF (.NOT.(EOLN)) THEN
	      CALL LSL_PUTMSG(SIF2IFF__EOLEXP)	!warning mess
	      GOTO 9999
	   ENDIF
	ENDIF
	ARC_TYPE3 = .TRUE.
	ARCDIR = 0
	GOTO 600
C
600	CONTINUE
C
	IF (.NOT.HAD_CC.AND..NOT.HAD_CL.AND..NOT.ARC_TYPE3) THEN
	   ARCDIR = -1
	ENDIF
C First find feature code. If not found then output warning mess
C and ignore the feature, skipping any continuation lines
C
	IF (.NOT.FINDFC()) THEN
	   OK = SKIP_CONTLIN()
	   GOTO 9999
	ENDIF
C
C Start the feature
C
	CALL START_FEATURE
C
C If coord out of specified range output error message
C
	IF (HAD_RANGE.OR.HAD_CCG) THEN
	   IF (P1X.LT.XMIN.OR.P1Y.LT.YMIN
     &	      .OR.P1X.GT.XMAX.OR.P1Y.GT.YMAX) THEN
	      CALL LSL_PUTMSG(SIF2IFF__COORDOUTRA,FSN)
	   ENDIF
	ENDIF
	X = (REAL(P1X)-REAL(XMIN))/REAL(UNITS)
	Y = (REAL(P1Y)-REAL(YMIN))/REAL(UNITS)
	IF (DIMEN.EQ.3) Z = (REAL(P1Z)-REAL(ZMIN))/REAL(UNITS)
C
C store coords in buffer
C
	CALL COORD(X,Y,Z)
C
	IF (ARC_TYPE1.OR.ARC_TYPE2) THEN
C
C If coord out of specified range output error message
C
	   IF (HAD_RANGE.OR.HAD_CCG) THEN
	      IF (CX.LT.XMIN.OR.CY.LT.YMIN
     &	         .OR.CX.GT.XMAX.OR.CY.GT.YMAX) THEN
	         CALL LSL_PUTMSG(SIF2IFF__COORDOUTRA,FSN)
	      ENDIF
	   ENDIF
	   X = (REAL(CX)-REAL(XMIN))/REAL(UNITS)
	   Y = (REAL(CY)-REAL(YMIN))/REAL(UNITS)
	   IF (DIMEN.EQ.3) Z = (REAL(CZ)-REAL(ZMIN))/REAL(UNITS)
	   CALL COORD(X,Y,Z)
	ENDIF
C
C If coord out of specified range output error message
C
	IF (HAD_RANGE.OR.HAD_CCG) THEN
	   IF (P2X.LT.XMIN.OR.P2Y.LT.YMIN
     &	      .OR.P2X.GT.XMAX.OR.P2Y.GT.YMAX) THEN
	      CALL LSL_PUTMSG(SIF2IFF__COORDOUTRA,FSN)
	   ENDIF
	ENDIF
	X = (REAL(P2X)-REAL(XMIN))/REAL(UNITS)
	Y = (REAL(P2Y)-REAL(YMIN))/REAL(UNITS)
	IF (DIMEN.EQ.3) Z = (REAL(P2Z)-REAL(ZMIN))/REAL(UNITS)
	CALL COORD(X,Y,Z)
C
	IF (ARC_TYPE3) THEN
C
C If coord out of specified range output error message
C
	   IF (HAD_RANGE.OR.HAD_CCG) THEN
	      IF (P3X.LT.XMIN.OR.P3Y.LT.YMIN
     &	         .OR.P3X.GT.XMAX.OR.P3Y.GT.YMAX) THEN
	         CALL LSL_PUTMSG(SIF2IFF__COORDOUTRA,FSN)
	      ENDIF
	   ENDIF
	   X = (REAL(P3X)-REAL(XMIN))/REAL(UNITS)
	   Y = (REAL(P3Y)-REAL(YMIN))/REAL(UNITS)
	   IF (DIMEN.EQ.3) Z = (REAL(P3Z)-REAL(ZMIN))/REAL(UNITS)
	   CALL COORD(X,Y,Z)
	ENDIF
C
C Write the feature
C
	IF (.NOT.HAD_BST) THEN
	   CALL WRITE_FEATURE
	ENDIF
C
	GOTO 9000

9999	RDARC = .FALSE.
C
C Return
C
9000	IS_ARC = .FALSE.
	ARCDIR = -999
	RETURN
	END
