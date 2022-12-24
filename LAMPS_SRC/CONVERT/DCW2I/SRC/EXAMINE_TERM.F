C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-05-22 16:16:04.000000000 +0100
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
	LOGICAL FUNCTION EXAMINE_TERM()
C
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created from DTMCEATE module TRIANG.SRC		ST	13-May-1992
C
C Description:
C
C	Function to examine SYS$OUTPUT to see if it is assigned to a terminal
C	If it is we must determine whether it is a CRT or not.
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE '($DVIDEF)/NOLIST'
	INCLUDE	'($DCDEF)/NOLIST'
	INCLUDE	'($SSDEF)/NOLIST'
C
C Local workspace
C
	INTEGER		VALUE		! for GETDVI
	LOGICAL		LIB$GETDVI	! get term characteristics etc.
	LOGICAL		IS_TERM
C
C ......................................................................
C
C Initialise
C
	IS_TERM=.FALSE.
C
C See if output is to a terminal
C
	EXAMINE_TERM=LIB$GETDVI(DVI$_DEVCLASS,,'SYS$OUTPUT',VALUE,,)
	IF (EXAMINE_TERM) THEN			 ! success?
	   IF (VALUE.EQ.DC$_TERM) IS_TERM=.TRUE. ! it is a terminal?
	ELSE
	   CALL LSL_PUTMSG(EXAMINE_TERM)
	   GOTO 10
	ENDIF
C
C If we have a terminal, is it a CRT?
C
	IF (IS_TERM) THEN	
	  EXAMINE_TERM=LIB$GETDVI(DVI$_TT_SCOPE,,'SYS$OUTPUT',VALUE,,)
	  IF (.NOT.EXAMINE_TERM) THEN
	     CALL LSL_PUTMSG(EXAMINE_TERM)
	  ENDIF	
	ENDIF
10	IF (EXAMINE_TERM) EXAMINE_TERM=SS$_NORMAL
	RETURN
	END
