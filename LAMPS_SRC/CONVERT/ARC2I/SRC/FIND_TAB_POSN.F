C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-01-28 10:34:14.000000000 +0000
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
	INTEGER*4 FUNCTION FIND_TAB_POSN( TABLE,ATT,ATTLEN )
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	16-Jan-1991
C
C Description:
C
C	Function FIND_TAB_POSN called from GET_ACS in ARC2I
C	Returns the position in ATTR_TAB of the attribute given by its
C	name argument ATT.
C	Two names are allowed to exist in the table. The first being for the
C	.AAT table and the second being for the .PAT table. This is denoted
C	in the by the AAT/PAT entry in the parameter table
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
C
C Common blocks
C
	INCLUDE	'HERE:TABLES.CMN'		! Parameter file tables
C
C Arguments
C
	CHARACTER*(*)	ATT			! The name of attribute to find
	INTEGER*4	ATTLEN			! The length of the above
	INTEGER*4	TABLE			! Table number (.AAT=1) (.PAT=2)
C
C Local Variables
C
	INTEGER*4	I			! Loop counter
	INTEGER*4	SIZ			! Size of name
	LOGICAL		FOUND_NAME		! 
C
C-------------------------------------------------------------------------------
C
	FIND_TAB_POSN = -1
	FOUND_NAME = .FALSE.
C
C Search through parameter tab for occurrence of ATT
C
	DO 100 I = 1,ATTR_PTR
	   IF ( ATTR_NAM(I)(1:16) .EQ. ATT(1:16) ) THEN
	      FOUND_NAME = .TRUE.
	      IF (ATTR_TAB(ATTR_EXPTAB,I).EQ.TABLE) THEN
	         FIND_TAB_POSN = I
	         GOTO 9000
	      ENDIF
	   ENDIF
100	CONTINUE
C
	IF (FOUND_NAME) THEN
C
C Name found but not specifed with correct table
C
	   IF ( TABLE.EQ.1 ) THEN
	      CALL LSL_PUTMSG( ARC2I__UNDEFATT,ATT(1:ATTLEN),'.AAT' )
	   ELSEIF ( TABLE.EQ.2) THEN
	      CALL LSL_PUTMSG( ARC2I__UNDEFATT,ATT(1:ATTLEN),'.PAT' )
	   ENDIF
	ENDIF
C
9000	RETURN
	END
