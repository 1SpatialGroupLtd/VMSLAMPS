C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-19 16:47:22.000000000 +0100
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
	OPTIONS /I4
	INTEGER FUNCTION OBEY_ERRET(SIGARGS,MECHARGS)
C
CDEC$	IDENT	'19SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England
C
CMOD	Special version, renamed OBEY_ERRET, for	RJH  19-Sep-1994
CMOD	   I2MAPDATA; references a local common block,
CMOD	   LOCAL_REPORT
C	Created (as DCL_ERRET)				 TJH 22-OCT-1985
C
C To be declared as an exception handler. Unwinds to the subroutine 
C that declared us, pretending that the subroutine that was called 
C has returned with an error.
C
	IMPLICIT NONE
C
C Common block to carry LOCAL_REPORT through into this condition handler
	LOGICAL*4	LOCAL_REPORT	! report error locally?
	COMMON /OBEY_REPORT/ LOCAL_REPORT	
C
C arguments:
	INTEGER SIGARGS(*),MECHARGS(*)
C
C parameters:
	INCLUDE '($SSDEF)'
C
C ......................................................................
C
	IF (LOCAL_REPORT) THEN
	   SIGARGS(1)=SIGARGS(1)-2 ! subtract PC/PSL from signal array
	   CALL SYS$PUTMSG(SIGARGS,,,)	
	   SIGARGS(1)=SIGARGS(1)+2 ! replace PC/PSL in signal array
	ENDIF
	OBEY_ERRET=SS$_CONTINUE
	RETURN
	END
