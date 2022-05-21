C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-01-07 17:36:36.000000000 +0000
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
	LOGICAL FUNCTION OPEN_FILES
C
CDEC$	IDENT	'11DE91'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	11-Dec-1991
C
C Description:
C	Open input IFF and temporary work files
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'		! For access to IERCD
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! Needed for FILES.CMN
	INCLUDE 'FILES.CMN'			! File LUNs, etc
	INCLUDE 'GENERAL.CMN'			! General variables
	INCLUDE 'COMMANDS.CMN'			! Command line switches
C
C Functions
C
	INTEGER*4	FLWOPB			! open file for block write
C
C Local variables
C
	INTEGER*4	IERR
C
C------------------------------------------------------------------------------
C
C Open input IFF file read only
C
	CALL IFFERM(.FALSE.)              ! turn off error messages
	CALL IFFOPN(IFFLUN,IFFFILE,0)
	CALL IFFERM(.TRUE.)               ! turn on error messages
	IFF_OPEN = IERCD.EQ.0
	IF (.NOT.IFF_OPEN) THEN
	   CALL LSL_PUTMSG(I2DIGIT__ERROPN,IFFFILE(1:IFFLEN))
	   CALL IFFERR
	   GOTO 999
	ENDIF
	IF (HAD_LOG) CALL WRITEF('IFF file       : %S',IFFFILE(1:IFFLEN))
C
C Open TMP file
C
	TMP_OPEN = FLWOPB(TMPLUN,TMPFILE(1:TMPLEN),IERR)
	IF (.NOT.TMP_OPEN) THEN
	   CALL LSL_PUTMSG(I2DIGIT__ERROPNTMP)
	   GOTO 999
	ENDIF
C
999	OPEN_FILES = IFF_OPEN .AND. TMP_OPEN
C
	RETURN
	END




