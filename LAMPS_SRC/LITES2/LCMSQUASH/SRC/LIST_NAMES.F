C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-08 12:02:04.000000000 +0100
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
	SUBROUTINE LIST_NAMES()
C
CDEC$	IDENT	'08OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		11-06-92
C
	IMPLICIT NONE
C
C  lists the elements in the BAD_TREE_PTR
C..............................................................................
C
	INCLUDE		'HERE:LCM.CMN'
C
C..............................................................................
C	the NAMES that were not declared
C
	CALL OUTPUT(' ')
	CALL OUTPUT('-------------------------------------------------------'//
     &			'-----------')
	CALL OUTPUT('                             DIAGNOSTICS')
	CALL OUTPUT('-------------------------------------------------------'//
     &			'-----------')
	CALL OUTPUT ('The following variable or macro names were not declared.')
	CALL OUTPUT ('Some may be primary commands used without a %.')
	CALL OUTPUT ('If the some of the names are present in the lists ' //
     &			'following this')
	CALL OUTPUT (' one, then the names were used prior to declaration.')

	CALL fortran_tree_list(BAD_TREE_PTR)	

C	.......................................................................
C	the MACROS that were declared
C
	CALL OUTPUT('-------------------------------------------------------'//
     &			'-----------')
	CALL OUTPUT ('The following macro names were defined:')
	CALL fortran_tree_list(MACRO_TREE_PTR)
C
C	.......................................................................
C	the variables that were declared
C
	CALL OUTPUT('-------------------------------------------------------'//
     &			'-----------')
	CALL OUTPUT ('The following variable names were declared:')
	CALL fortran_tree_list(VAR_TREE_PTR)
C
C	.......................................................................
C
	CALL OUTPUT('-------------------------------------------------------'//
     &			'-----------')
C
C..............................................................................
C
	RETURN
	END
C
C
C
C
C
C
C
	SUBROUTINE OUTPUT(INSTR)
C
CDEC$	IDENT	'14JN92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		11-06-92
C
	IMPLICIT NONE
C
C output a line of text
C .....................................................................
C Arguments:
	CHARACTER*(*) INSTR
C
C Commons:
	INCLUDE 'HERE:LCM.CMN'
	INCLUDE 'HERE:FILENAME.CMN'
	INCLUDE 'HERE:LUNS.PAR'
	INCLUDE	'HERE:COMMANDS.CMN'
	INCLUDE 'HERE:LCMMSG.PAR'
C
C..............................................................................
C
	IF (LIST) THEN
	  CALL FLWSEL(LIST_LUN)
	  CALL FLWSTR(INSTR)
	ENDIF
C
	CALL LSL_PUTMSG(LCM__TXT,INSTR)
C
C..............................................................................
C
	RETURN
	END
C
