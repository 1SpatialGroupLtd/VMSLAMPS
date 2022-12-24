C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-01-28 13:52:30.000000000 +0000
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
	SUBROUTINE 	WRITE_LUT
C
CDEC$	IDENT	'15NO89'
C
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			9-Nov-1989			A.P.Brown
C
C Description:
C
C	Write the new LUT for FC to CCSM conversion
C
	IMPLICIT	NONE
C
	INCLUDE 'CMN:LUN.PAR'
C
	INCLUDE 'LSL$CMNLSL:EXPC.CMN'		! LSLLIB expand buffer
	INCLUDE 'CMN:FILES.CMN'
	INCLUDE 'CMN:LUT.CMN'
C
	INTEGER		STATUS
	INTEGER		I
	INTEGER*2	LENGTH		! Number of bytes in record A
	PARAMETER	( LENGTH=32 )
C
	LOGICAL		FLWOPN
	LOGICAL		FLWLIN
	LOGICAL		FLWCLO
	INTEGER*2	EXPAND
	LOGICAL		RDINT
	LOGICAL		READSTR
C
	INTEGER*2	LEN
C
C-------------------------------------------------------------------------------
C
	STATUS = FLWOPN( NEWLUTLUN,NEWLUTFIL )
	IF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG( STATUS )
	   STOP '%SIF2IFF-F-ABORT exiting with error status'
	ENDIF
C
C
	DO 100 I = 1, NUMFC
	   LEN = EXPAND( '%^W%I3   %S   !',
     &                   FC_CCSM_LUT(I).FC,
     &                   FC_CCSM_LUT(I).CCSM )
	   STATUS = FLWLIN( EXPBUF )
100	CONTINUE
C
	STATUS = FLWCLO(NEWLUTLUN)
C
	RETURN
	END
