C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-06 16:17:16.000000000 +0100
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
        INTEGER*4  FUNCTION OPEN_FILES()
C
CDEC$	IDENT	'06OC89'
C
C 	Copyright Laser-Scan Ltd., Cambridge, England
C
C	Created.				FJB  11-Aug-1989
C
C Get input and output files
C
	IMPLICIT NONE
C
C System parameters
C
 	INTEGER*4	SS$_NORMAL ! normal successful completion
	EXTERNAL	SS$_NORMAL
C
C Functions:
C
	INTEGER*4	OPEN_IFF	! open IFF file for readonly
	INTEGER*4	OPEN_FRT	! open FRT file containing ACD table
	INTEGER*4	OPEN_DLG	! open DLG file for write
C
C Workspace:
C
C
C ......................................................................
C
C
	OPEN_FILES=%LOC(SS$_NORMAL)
C
C Open IFF input file
C
	OPEN_FILES = OPEN_IFF()
	IF(OPEN_FILES)THEN
C
C Open FRT lookup table
C
	   OPEN_FILES = OPEN_FRT()
	   IF(OPEN_FILES)THEN
C
C Open DLG file
C
	      OPEN_FILES = OPEN_DLG()
C
	   ENDIF
C
	ENDIF
C
C ......................................................................
C
	IF (OPEN_FILES) OPEN_FILES=%LOC(SS$_NORMAL) ! normal completion?
	RETURN
	END
