C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-10-28 11:52:38.000000000 +0000
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
	SUBROUTINE PUT_FTR(OFC)
C
CDEC$	IDENT	'12SE91'
C
	IMPLICIT NONE
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England
C Author S. Hancock
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
	INCLUDE 'LSL$ICASE:CMDLIN.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
C
	INTEGER*2	OFC
C
	INTEGER*4	I,J,K,L,M
	INTEGER*2	NPTS
	INTEGER*2	IENDS
	INTEGER*2	IFSN
	INTEGER*2	JFSN
	INTEGER*2	FSTAT(4)
C
	DATA FSTAT/0,0,0,0/
	DATA IFSN/0/
C
C------------------------------------------------------------------------------
C
	CALL IFFSEL(OUTLUN)
C
C Update RAnge info before writing out points.
C
	DO 50 I=1,OPTR
	   CALL CHECK_RANGE(ZOUT(1,I),ZOUT(2,I))
50	CONTINUE
C
	IFSN=IFSN+1
	JFSN=0
	CALL IFFNF(IFSN,JFSN)
	FSTAT(1)=OFC
	CALL IFFFS(FSTAT)
	M=(OPTR/200)*200
	IENDS=0
	DO 100 I=1,M,200
	NPTS=200     !put outside loop
	CALL IFFST(ZOUT(1,I),NPTS,IENDS)
	IENDS=1
100	CONTINUE
	IF(M.NE.OPTR)THEN
	   NPTS=OPTR-M
	   CALL IFFST(ZOUT(1,M+1),NPTS,IENDS)
	ENDIF
	CALL IFFEF
	CALL IFFSEL(INLUN)
C
	RETURN
	END
