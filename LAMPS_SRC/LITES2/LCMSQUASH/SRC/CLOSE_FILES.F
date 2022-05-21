C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-01 12:30:32.000000000 +0100
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
	SUBROUTINE CLOSE_FILES
C
CDEC$	IDENT	'01OC92'
C
C	created 	SG	01-04-92
C
C	Copyright Laser-Scan Ltd, Cambridge, England.
C
C description
C	The function closes the input and output files
C	we are not concerned with its return value.
C	
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'HERE:COMMANDS.CMN'
	INCLUDE 'HERE:FILENAME.CMN'
	INCLUDE 'HERE:LUNS.PAR'
C
C Functions called
	INTEGER*4	FLRCLO			!close read-only text file
	INTEGER*4	FLWDEL			!close and delete text file
	INTEGER*4	FLWCLO			!close read/write text file
C
C local variables
	INTEGER*4	RETCOD
C
C ......................................................................
C
	CALL FLRCLO(IN_LUN,RETCOD)

	IF (WIPE_OUTPUT) THEN
	  CALL FLWDEL(OUT_LUN,RETCOD)
	  IF (LIST) CALL FLWDEL(LIST_LUN,RETCOD) 
	  IF (EXPLODE) CALL FLWDEL(EXPL_LUN,RETCOD) 
	ELSE
	  CALL FLWCLO(OUT_LUN,RETCOD)
	  IF (LIST) CALL FLWCLO(LIST_LUN,RETCOD) 
	  IF (EXPLODE) CALL FLWCLO(EXPL_LUN,RETCOD) 
	ENDIF
C
C ......................................................................
C
	RETURN
	END
