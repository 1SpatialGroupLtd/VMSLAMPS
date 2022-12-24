C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-07-02 10:46:36.000000000 +0100
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
	LOGICAL FUNCTION RDCIR
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF CIR command
C
C Description
C
C	Read parameters of SIF CIR command
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
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
	LOGICAL		CONT_LINE	! test for continuation line
	LOGICAL		RDCHS
	LOGICAL		SKIP_CONTLIN	! skip over continuation lines
C
C Local Variables
C
	REAL		RDUMMY		! dummy real
	INTEGER*4	N		! 
	INTEGER*4	RESULT		! command read result
	LOGICAL		EOLN
	LOGICAL		OK		! function return status
	LOGICAL		NOREAL		! flag returned real
	LOGICAL		CIR_TYPE1	! type of CIR command
	LOGICAL		CIR_TYPE2	! type of CIR command
	REAL		P1X,P1Y,P1Z,P2X	! points on circle
	REAL		P2Y,P2Z,P3X,P3Y	! points on circle
	REAL		P3Z		! points on circle
	REAL		CX,CY,CZ	! circle centre
	REAL		RADIUS		! circle radius
	REAL		T1,T2		! temporary variables
	REAL		THETA		! angle
	BYTE 		ICH
C
C External declaration
C
	INTEGER*4	CIRCMD_CMD_TABLE
	EXTERNAL	CIRCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDCIR = .TRUE.
C
	IS_CIRCLE = .TRUE.			
	CIR_TYPE1 = .FALSE.
	CIR_TYPE2 = .FALSE.
C
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
C Now, read the command from the line
C
500	RESULT = RDCOMM(CIRCMD_CMD_TABLE)
C
C and check that there was one.
C
	IF (RESULT .LE. 0) GOTO 9999
	IF (RESULT.EQ.5) THEN
	   OK = RDLONG(N)
	   IF (N.EQ.2) RESULT = 6
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
	IF (.NOT.CONT_LINE()) GOTO 9999
C
C Despatch according to command
C
	GOTO (510,520,530,540,550,560) RESULT
C
C Unknown command - 
C
	   CALL LSL_PUTMSG(SIF2IFF__UNKCMD,CMDNST)	!warning mess
	   GOTO 9999
C
C CE -
C
510     NOREAL = RDREAL(CX)
	OK = READ_SEP(',')
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	NOREAL = RDREAL(CY)
	OK = READ_SEP(',')
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	IF (DIMEN.EQ.3) THEN
	   NOREAL = RDREAL(CZ)
	   IF (NOREAL) THEN
	      CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	   OK = READ_SEP(',')
	   IF (.NOT.CONT_LINE()) GOTO 9999
	ENDIF
C
C If coord out of specified range don't create feature
C
	   IF (HAD_RANGE.OR.HAD_CCG) THEN
	      IF (CX.LT.XMIN.OR.CY.LT.YMIN
     &	         .OR.CX.GT.XMAX.OR.CY.GT.YMAX) THEN
	         CALL LSL_PUTMSG(SIF2IFF__COORDOUTRA,FSN)
	      ENDIF
	   ENDIF
	CX = (CX-XMIN)/REAL(UNITS)
	CY = (CY-YMIN)/REAL(UNITS)
	IF (DIMEN.EQ.3) CZ = (CZ - ZMIN)/REAL(UNITS)
	IF (CIR_TYPE1) GOTO 600			!all we need if type 1
	GOTO 500	
C
C HO - ignore hole
C
520	GOTO 500
C
C MA - ignore matrix
C
530	GOTO 500
C
C RA - circle radius
C
540	NOREAL = RDREAL(RADIUS)
	OK = READ_SEP(',')
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__RADNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	IF (.NOT.CONT_LINE()) GOTO 9999
	RADIUS = RADIUS/REAL(UNITS)		! convert to UORs
	IF (RADIUS.EQ.0.0) GOTO 9000	! ignore circle with 0 radius
	CIR_TYPE1 = .TRUE.
	GOTO 500
C
C P1 - point on circle
C
550     NOREAL = RDREAL(P1X)
	OK = READ_SEP(',')
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	IF (.NOT.CONT_LINE()) GOTO 9999
	NOREAL = RDREAL(P1Y)
	OK = READ_SEP(',')
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (DIMEN.EQ.3) THEN
	   NOREAL = RDREAL(P1Z)
	   IF (NOREAL) THEN
	      CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	   OK = READ_SEP(',')
	   IF (.NOT.CONT_LINE()) GOTO 9999
	ENDIF
C
C If coord out of specified range don't create feature
C
	   IF (HAD_RANGE.OR.HAD_CCG) THEN
	      IF (P1X.LT.XMIN.OR.P1Y.LT.YMIN
     &	         .OR.P1X.GT.XMAX.OR.P1Y.GT.YMAX) THEN
	         CALL LSL_PUTMSG(SIF2IFF__COORDOUTRA,FSN)
	      ENDIF
	   ENDIF
	P1X = (P1X-XMIN)/REAL(UNITS)
	P1Y = (P1Y-YMIN)/REAL(UNITS)
	IF (DIMEN.EQ.3) P1Z = (P1Z - ZMIN)/REAL(UNITS)
	CIR_TYPE2 = .TRUE.
	GOTO 500	
C
C
C P2 - point on circle
C
560     NOREAL = RDREAL(P2X)
	OK = READ_SEP(',')
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	IF (.NOT.CONT_LINE()) GOTO 9999
	NOREAL = RDREAL(P2Y)
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	OK = READ_SEP(',')
	IF (DIMEN.EQ.3) THEN
	   IF (.NOT.CONT_LINE()) GOTO 9999	 ! test for continuation line
	   NOREAL = RDREAL(P1Z)
	   IF (NOREAL) THEN
	      CALL LSL_PUTMSG(SIF2IFF__COORDNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	ENDIF
	OK = READ_SEP(',')
	IF (.NOT.OK) THEN
	   EOLN = RDCHS(ICH)
	   IF (.NOT.(EOLN)) THEN
	      CALL LSL_PUTMSG(SIF2IFF__EOLEXP)	!warning mess
	      GOTO 9999
	   ENDIF
	ENDIF
C
C If coord out of specified range don't create feature
C
	   IF (HAD_RANGE.OR.HAD_CCG) THEN
	      IF (P2X.LT.XMIN.OR.P2Y.LT.YMIN
     &	         .OR.P2X.GT.XMAX.OR.P2Y.GT.YMAX) THEN
	         CALL LSL_PUTMSG(SIF2IFF__COORDOUTRA,FSN)
	      ENDIF
	   ENDIF
	P2X = (P2X-XMIN)/REAL(UNITS)
	P2Y = (P2Y-YMIN)/REAL(UNITS)
	IF (DIMEN.EQ.3) P2Z = (P2Z-ZMIN)/REAL(UNITS)
	GOTO 600				! all we need for type 2	
C
600	CONTINUE
C
C Calculate circle coords and store in buffer
C
	IF (CIR_TYPE2) THEN			! calc. point on edge
	   T1 = P1X - CX   
	   T2 = P1Y - CY
	   RADIUS = SQRT(T1*T1+T2*T2)
	ENDIF
C
	P1X = CX + RADIUS
	P1Y = CY
	P1Z = CZ
	P2X = CX
	P2Y = CY + RADIUS
	P2Z = CZ
	P3X = CX - RADIUS
	P3Y = CY
	P3Z = CZ
C
	CALL COORD(P1X,P1Y,P1Z)
	CALL COORD(P2X,P2Y,P2Z)
	CALL COORD(P3X,P3Y,P3Z)
C
C Write the feature
C
	IF (.NOT.HAD_BST) CALL WRITE_FEATURE
C
	GOTO 9000

9999	RDCIR = .FALSE.
	IF (DONE_START_FEATURE) CALL IFFDEL
	DONE_START_FEATURE = .FALSE.
C
C Return
C
9000	IS_CIRCLE = .FALSE.
	RETURN
	END
