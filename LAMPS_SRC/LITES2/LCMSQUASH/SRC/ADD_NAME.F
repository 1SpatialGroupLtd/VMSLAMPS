C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-06 16:53:20.000000000 +0100
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
	SUBROUTINE ADD_NAME(NAME, TREE_PTR)
C
CDEC$	IDENT	'06OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		11-06-92
C
	IMPLICIT NONE
C
C
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
	INCLUDE 'HERE:LCM.CMN'
	INCLUDE 'HERE:FILENAME.CMN'
	INCLUDE 'HERE:LUNS.PAR'
C
C Arguments
	CHARACTER*(*)	NAME
	INTEGER*4	TREE_PTR	
C
C workspace
	INTEGER		PTR
	INTEGER		RETVAL
C
C Functions
	INTEGER		fortran_tree_add_item		!C FUNCTION
	INTEGER		NAME_END			!end of alphabetic word
C
C..............................................................................
C
	PTR = NAME_END(NAME,1)				!trim to proper name

	IF (PTR.EQ.0) THEN				!unrecognised character
	  IF (NAME(1:1).NE.'$') THEN			!system var
	    CALL LCMWARN('Bad char '''//NAME(1:1)//''' in: '//NAME)
	  ENDIF
	ELSE
C
C	  ......................................................................
C	  add to tree. If unsuccessful, name was allready in tree.
C
	  RETVAL = fortran_tree_add_item(TREE_PTR, NAME(1:PTR)) !C function
C
	  IF (RETVAL.EQ.0) THEN 
	    CALL LCMWARN('Name already declared: "'//NAME(1:PTR)//'"')
	  ENDIF
	ENDIF
C
C..............................................................................
C
	RETURN
	END
