C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-01-30 17:29:54.000000000 +0000
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
	LOGICAL FUNCTION READ_SEP(CH)
C
CDEC$	IDENT	'30JA90'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jan-1990	J.M.Cadogan
C
C Description:
C
C	CONVERT SIF2IFF UTILITY - read a seperator in a SIF file
C
	IMPLICIT	NONE
C
C Parameter files
C
C
C Common Blocks
C
C
C Functions
C
	LOGICAL		RDCH			! read character
C
C Arguements
C
	CHARACTER	CH			! required seperator
C
C Workspace
C
	BYTE		ISEP			! ASCII code of CH
	BYTE		ICH			! ASCII code of found char.
	LOGICAL		EOLN			! end of line flag
C
C-------------------------------------------------------------------------------
C
C Assume success
C
	READ_SEP = .TRUE.
C
C Get ASCII code of seperator
C
	ISEP = ICHAR(CH)
C
C Read next char
C
	EOLN = RDCH(ICH)
C
C Not got required separator - return failure
C
	IF (ICH.NE.ISEP) READ_SEP = .FALSE.
C
	RETURN
	END
