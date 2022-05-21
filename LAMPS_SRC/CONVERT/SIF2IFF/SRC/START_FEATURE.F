C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-08-04 15:48:10.000000000 +0100
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
	SUBROUTINE	START_FEATURE
C
CDEC$	IDENT	'31JA90'
C
C
C	Copyright (C)Laser-Scan Ltd., Cambridge
C	Created			12-Jan-1990			J.M. Cadogan
C
C Description:
C
C	Start a new feature
C
	IMPLICIT	NONE
C
C parameter files
C
	INCLUDE	'LSL$CMNIFF:CB.STR'	! record structure definition
C
C common blocks
C
	INCLUDE 'CMN:IFF_FEATURE.CMN'
	INCLUDE 'CMN:IFF_POINTS.CMN'
	INCLUDE 'HERE:SIF2IFF.CMN'
C
C workspace
C
	INTEGER*2	ISTAT(4)	! for the FS entry
C
C...............................................................................
C
	FSN = FSN + 1					!next feature
	ISQ = 0						!let lsllib allocat ISQ
 	CALL IFFNF( FSN, ISQ )				! start the feature
C
C	........................................................................
C	calculate all the bits of the FS entry
C
	ISTAT(1) = FC
	ISTAT(2) = 0
	ISTAT(3) = 0
C
C	for texts, assume we have the digitised position
C
	IF ( IS_TEXT ) THEN
	   CALL LIB$INSV( JUSTIF,   0, 4, ISTAT(3) )
	   CALL LIB$INSV( STYLE,    4, 2, ISTAT(3) )
	   CALL LIB$INSV( CATEGORY, 6, 6, ISTAT(3) )
	   ISTAT(3) = ISTAT(3).OR.'8000'X   		! bits 14-15 = 2(text)
	ELSEIF ( IS_SYMBOL ) THEN
	   ISTAT(3) = ISTAT(3).OR.'4000'X   		! bits 14-15 = 1(symbol)
	ENDIF
C
	CALL IFFFS( ISTAT )				!write FS entry
C
C	........................................................................
C	if we have any AC's to output, do them here - heights only.
C
	IF (HAD_AC) CALL IFFAC(3,ACVAL)
C
C	........................................................................
C	BUG FIX. SIF2IFF  often generates very large TH entries which overflow
C	integer*2 bounds. This gives unexpected values in the IFF file and
C	should be checked for bounds.
C
	IF (HEIGHT.GT.MAX_TH) THEN
	  HEIGHT = MAX_TH
	ELSEIF (HEIGHT.LT.MIN_TH) THEN
	  HEIGHT = MIN_TH
	ENDIF

 	IF ( IS_TEXT ) CALL IFFTH( HEIGHT )
C
C	........................................................................
C	
	PEN_UP = .TRUE.					!pen up for the first ST
	DONE_ZS = .FALSE.				!No STs output yet
	DONE_ST = .FALSE.				!no ZSs output yet
C
C...............................................................................
C
	DONE_START_FEATURE = .TRUE.			!return status
	RETURN
	END
