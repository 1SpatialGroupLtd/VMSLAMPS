C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-06-13 17:53:26.000000000 +0100
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
	LOGICAL FUNCTION DO_NEAR
C
CDEC$	IDENT	'13JN91'
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Clarke Brunt			CCB	15-May-1991
C
C Description
C
C	LITES2 cartographic editor user command routines
C	Get profile nearest cursor
C
        IMPLICIT NONE
C
C functions
	INCLUDE		'USRKEEP.CMN'
	INCLUDE 	'USRFEAT.CMN'
C
	IF (PROFANG.NE.0.0) CALL FILL_ROTATE(
     &				-PROFANG,USR_CURSOR(1),USR_CURSOR(2))
	IF (PYMAX-PYMIN.EQ.0.0) THEN	! avoid zero divide
	   NEARP = 0
	ELSE
	   NEARP = NINT((USR_CURSOR(2)-PYMIN)/(PYMAX-PYMIN)*(NPROF+1))
	ENDIF
C
	IF (NPROF.LE.0.OR.NEARP.LE.0.OR.NEARP.GT.NPROF) THEN
	   CALL TTWSTR('Cursor is not near any profile')
	   DO_NEAR = .FALSE.
	   GOTO 9999
	ENDIF
C
	DO_NEAR = .TRUE.
C
9999	RETURN
	END
