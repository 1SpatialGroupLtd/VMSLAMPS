C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-08 11:52:48.000000000 +0100
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
	SUBROUTINE CHECK_REST(INSTR)
C
CDEC$	IDENT	'08OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		14-06-92
C
	IMPLICIT NONE
C
C check the rest of the line for variable substitution
C .....................................................................
C Change history
C
C .....................................................................
C CCB explanation - 07OC92
C The format of a substituted variable in LITES2 is as follows:
C
C Simple:	'[ ][$]name[']
C Array:	'[ ][$]name[ ][+/-][ ]integer[']
C
C LCMSQUASH doesn't know whether the variable is an array or not (maybe
C it could for those declared locally) so the syntax checking cannot be
C rigorous.
C
C Instead, we don't allow the +/- (I bet nobody ever used them, since -
C is illegal anyway) and we allow an integer to be treated as the
C subscript for any variable. All this only matters so that we realise
C what is a trailing quote, and what is a leading quote for another
C variable.
C .....................................................................
C
C Commons:
	INCLUDE 'HERE:COMMANDS.CMN'
	INCLUDE 'HERE:LCM.CMN'
C
C Arguments
	CHARACTER*(*)	INSTR
C
C workspace
	INTEGER		LENGTH
	INTEGER		P, P1, P2, P3
C
C Functions
	INTEGER		FIND_DELIM
	INTEGER		WORD_START
	INTEGER		NAME_END
	LOGICAL		IS_DIGIT
C
C..............................................................................
C
	P2 = 0
	LENGTH = LEN(INSTR)
C
C check if we have finished
10	IF (P2.GE.LENGTH) GOTO 1000
C
C look for a ', starting at current position
	P1 = FIND_DELIM('''', INSTR, P2+1)
	IF (P1.EQ.0) GOTO 1000		! not found
C
C found a ', is it at the end of the string
	IF (P1.EQ.LENGTH) THEN
	  CALL LCMWARN('Missing variable name: '//INSTR)
	  GOTO 1000
	ENDIF
C
C find the start of the variable name
	P = WORD_START (INSTR,P1+1)
	IF (P.EQ.0) THEN
	  CALL LCMWARN('Missing variable name: '//INSTR)
	  GOTO 1000
	ENDIF
C
C check if it is a system variable ($), then
C find the end of the name, or if it isn't a valid name at all
	IF (INSTR(P:P).EQ.'$') THEN
	  IF (P.EQ.LENGTH) THEN
	    CALL LCMWARN('Illegal variable name: '//INSTR(P:))
	    GOTO 1000
	  ENDIF
	  P2 = NAME_END (INSTR,P+1)
	ELSE
	  P2 = NAME_END (INSTR,P)
	ENDIF
	IF (P2.EQ.0) THEN
	  CALL LCMWARN('Illegal variable name: '//INSTR(P:))
	  GOTO 1000
	ENDIF
C
C good variable name, check for trailing '
	IF (P2.EQ.LENGTH) THEN
	  IF (CQUOTE) CALL LCMWARN(
     &			'Matching end-quote not found: '//INSTR(P1:P2))
	  CALL CHECK_NAME( INSTR(P:P2), VAR_TREE_PTR )
	  GOTO 1000
	ENDIF
C	   
	IF (INSTR(P2+1:P2+1).EQ.'''') THEN
	  CALL CHECK_NAME( INSTR(P:P2), VAR_TREE_PTR )
	  P2 = P2+1			! step over '
	  GOTO 10
	ENDIF
C
C we've got a variable name, but next char isn't a quote -
C check if it's a subscript
C
C first see if there is anything there at all
	P3 = WORD_START( INSTR, P2+1 )
	IF (P3.EQ.0) THEN
	  IF (CQUOTE) CALL LCMWARN(
     &			'Matching end-quote not found: '//INSTR(P1:P2))
	  CALL CHECK_NAME( INSTR(P:P2), VAR_TREE_PTR )
	  GOTO 1000
	ENDIF
C
C if it isn't a digit, then loop for next variable
	IF (.NOT.IS_DIGIT(INSTR(P3:P3))) THEN
	  IF (CQUOTE) CALL LCMWARN(
     &			'Matching end-quote not found: '//INSTR(P1:P2))
	  CALL CHECK_NAME( INSTR(P:P2), VAR_TREE_PTR )
	  P2 = P3-1
	  GOTO 10
	ENDIF
C
C it started with a digit, so skip any more digits
20	IF (P3.EQ.LENGTH) THEN
	  IF (CQUOTE) CALL LCMWARN(
     &			'Matching end-quote not found: '//INSTR(P1:P3))
	  CALL CHECK_NAME( INSTR(P:P2), VAR_TREE_PTR )
	  GOTO 1000
	ENDIF
	P3 = P3+1
	IF (IS_DIGIT(INSTR(P3:P3))) GOTO 20
C
C so now we have something which isn't a digit - is it the quote?
	IF (INSTR(P3:P3).NE.'''') THEN
	  P3 = P3-1
	  IF (CQUOTE) CALL LCMWARN(
     &			'Matching end-quote not found: '//INSTR(P1:P3))
	ENDIF
	CALL CHECK_NAME( INSTR(P:P2), VAR_TREE_PTR )
	P2 = P3
C
	GOTO 10
C
C..............................................................................
C
1000	RETURN
	END
