C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-08-04 13:38:06.000000000 +0100
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
	SUBROUTINE WRITE_FEATURE
C
CDEC$	IDENT	'31JA90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	12-Jan-1990
C
C	CONVERT SIF2IFF Utility - Write feature to IFF file
C
C Description
C
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	! message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! global variables
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! feature details
	INCLUDE 'CMN:TEXT.CMN'		! text data
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
C
C Local variables
C
	INTEGER	I 			! loop counter
	BYTE	TEXT_BUFF(MAX_BUF_SIZE)	! text buffer for IFFTX
C
C...............................................................................
C
	IF (.NOT.DONE_START_FEATURE) CALL START_FEATURE	!start the feature

	CALL FLUSH					!output coordinates

	IF (ORI_SYM.OR.IS_TEXT) CALL IFFRO( ANGLE )	!orientation

	IF (IS_TEXT) THEN				!text

	   IF (NCHS.GT.MAX_BUF_SIZE) NCHS=MAX_BUF_SIZE	!BUGFIX,prevent overflow

	   DO 200 I = 1, NCHS				!convert to byte array
	     READ ( TEXT(I:I),100 ) TEXT_BUFF(I)
100	     FORMAT( A )
200	   CONTINUE

	   CALL IFFTX( TEXT_BUFF, NCHS )		!write text out
	ENDIF

	CALL IFFEF					!end the feature
C
C...............................................................................
C Return
C
	RETURN
	END
