C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-07-08 12:32:10.000000000 +0100
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
	LOGICAL FUNCTION FILE_EXISTS(PATH)
C
CDEC$	IDENT	'22MY92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	22-May-1992
C
C Description:
C
C       Routine to check for the existance of a file. If is does exists, it
C       immediately closes it again. Otherwise the function returns false.
C
	IMPLICIT NONE
C
C Functions
C
	INTEGER*4	FLRCLO			! close file
	INTEGER*4	FLROPN			! open file
C
C Local workspace
C
	CHARACTER*(*)	PATH			! working path name
C
C ......................................................................
C
	FILE_EXISTS = FLROPN(1,PATH,,)
C
	IF (FILE_EXISTS) CALL FLRCLO(1)
C
C ......................................................................
C
999	RETURN
	END
