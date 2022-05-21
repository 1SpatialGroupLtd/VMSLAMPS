C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-06 16:53:24.000000000 +0100
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
	PROGRAM LCMSQUASH
C
CDEC$	IDENT	'06OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		10-06-92
C
	IMPLICIT NONE
C
C Utility to compress LITES2 command macros into a more compact form.
C It does this by:
C	removing comments
C	compressing lines
C	shortening LITES2 commands to 4 characters
C
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
C
	INCLUDE  'HERE:FILENAME.CMN'
	INCLUDE  'HERE:COMMANDS.CMN'
	INCLUDE  'HERE:LUNS.PAR'
	INCLUDE  'HERE:LCM.CMN'
C
C Functions:
C
	LOGICAL		CMDLIN			! Read & decode command line
	LOGICAL		OPEN_FILES,CLOSE_FILES	! open and close files
	LOGICAL		PROCESS_INPUT		! process the input file
	INTEGER*4	init_tree		! C function
C
C Workspace:
C
	INTEGER		OK			! Function return
C
C .....................................................................
C Initialise
C
	CALL LSL_INIT				! initialise LSLLIB
	CALL SET_TXTLIM(MY_BUFSIZ)		! 255 chars/line max
	CALL SET_EXPMAX(MY_BUFSIZ)		! 255 chars/line max
C
C  	....................................................................
C	initialise local common blocks, and set up trees
C
	LCM_OUT_LEN = 0				! no output LCM generated yet
C
C  	....................................................................
C	C functions to generate trees
C
	MACRO_TREE_PTR = init_tree()		! tree
	VAR_TREE_PTR = init_tree()		! tree
	BAD_TREE_PTR = init_tree()		! tree
C
C  	....................................................................
C	main program chunk
C
	OK=CMDLIN()				! read command line
	IF (OK) THEN
	  OK = OPEN_FILES()			! open files for IO
	  IF (OK) THEN
	    CALL PROCESS_INPUT()		! process
	    CALL LIST_NAMES()			! summarise names encountered
	  ENDIF
	  OK= CLOSE_FILES()			! close open files
	ENDIF
C
C  	....................................................................
C	C functions to remove all trace of a tree (redundant, done by system)
C
	CALL kill_tree(MACRO_TREE_PTR)		! remove tree
	CALL kill_tree(VAR_TREE_PTR)		! remove tree
	CALL kill_tree(BAD_TREE_PTR)		! remove tree
C
C  ....................................................................
C  finished
C
	CALL LSL_EXIT(OK)
	END
