C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-08-04 14:50:42.000000000 +0100
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
	PROGRAM 	SIF2IFF
C
CDEC$	IDENT	'02JL91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					3-Jan-1990	J.M.Cadogan
C
C Description:
C
C	CONVERT SIF2IFF UTILITY - Convert SIF (ASCII) to IFF
C
	IMPLICIT	NONE
C
C Parameter files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'
	INCLUDE 'CMN:LUN.PAR'
C
C Common Blocks
C
	INCLUDE 'CMN:FILES.CMN'
	INCLUDE 'CMN:FLAGS.CMN'
C
C Functions
C
	LOGICAL		RDPAR			! read FDF parameters
	LOGICAL		IFFCREATE		! create IFF file
	LOGICAL		CMDLIN			! get command line
C
C Workspace
C
	LOGICAL		OK			! function call status
C
C..............................................................................
C
	CALL LSL_INIT			! Initialise LSLLIB
	CALL INI_FEATURE		! Initialise IFF feature variables
	CALL INI_FDF			! Initialise FDF lookup tables
	CALL INI_SIF2IFF		! Initialise globals
C
C	........................................................................
C	Get command line
C
	IF (CMDLIN()) THEN
	   IF (HAD_LOG) CALL REPORT(1)
C
C	........................................................................
C	Read parameter file to create FDF lookup arrays
C	If the CCG qualifier is used then RDPAR reads CCSM lookup table.
C
	   IF (RDPAR()) THEN
	      IF (IFFCREATE(IFFLUN,IFFFIL(:IFFLEN),,,HAD_LOG)) THEN
	         CALL CONDAT				!read and convert SIF
	         CALL CLOSE_IFF				!close IFF file
	         CALL WRITEF(' ')
	      ENDIF
	   ENDIF
	ENDIF
C
C	........................................................................
CCC	If the ccg qualifier is used then write the lut if necessary.
C	NOT IMPLEMENTED IN THIS VERSION
C
CCC	IF (HAD_CCG) CALL WRITE_LUT
C
C..............................................................................
C And thats it.
C
	CALL LSL_EXIT
	END
