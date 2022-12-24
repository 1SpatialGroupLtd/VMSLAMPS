C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-06-13 17:43:06.000000000 +0100
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
	SUBROUTINE USRDO(RETCOD)
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
C	Volume calculation routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	RETCOD		! return code
					! = 0 abort, dont call USRRET
					! = 4 for abort, call USRRET
					! = 5 to create a new feature
					!     (and keep old one if there
					!      was one)
					! = 6 to create a new feature
					!     and delete old one
C
C RETCOD should be set to the required value in this routine
C
C functions
	LOGICAL		DO_POLY		! process bounding polygon
	LOGICAL		DO_PREP		! prepare to do profile
	LOGICAL		DO_PROF		! accept a profile
	LOGICAL		DO_VOL		! calculate volume
	LOGICAL		DO_NEAR		! get nearest profile
C
C working storage
C
	INCLUDE		'USRKEEP.CMN'
	INCLUDE 	'USRFEAT.CMN'
C
	IF (ERROR) THEN
	   RETCOD = 4		! go to USRRET
	   GOTO 9999
	ENDIF
C
	GOTO (9000,200,300,400,500,600), USR_ACTION
	GOTO 9000
C
C setting parameters and polygon
200	IF (.NOT.DO_POLY()) ERROR = .TRUE.
	RETCOD = 4		! go to USRRET
	GOTO 9999
C
C preparing a profile
300	IF (.NOT.DO_PREP()) ERROR = .TRUE.
	RETCOD = 4		! go to USRRET
	GOTO 9999
C
C accepting a profile
400	IF (.NOT.DO_PROF()) THEN
	   ERROR = .TRUE.
	   RETCOD = 4		! go to USRRET
	ELSE
	   RETCOD = 6		! go to USRSTO (deleting old feature)
	ENDIF
	GOTO 9999
C
C calculate the volume
500	IF (.NOT.DO_VOL()) ERROR = .TRUE.
	RETCOD = 4		! go to USRRET
	GOTO 9999
C
C get nearest profile
600	IF (.NOT.DO_NEAR()) ERROR = .TRUE.
	RETCOD = 4		! go to USRRET
	GOTO 9999
C
C invalid action
C
9000	CALL WRITEF('Unknown action %N for user routine USRDO')
	CALL TTWSTR('User routine being aborted')
	RETCOD=0
C
9999	RETURN
	END
