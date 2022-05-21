C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-05-17 15:20:44.000000000 +0100
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
	LOGICAL FUNCTION DO_VOL
C
CDEC$	IDENT	'17MY91'
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
	INCLUDE		'USRKEEP.CMN'
	INCLUDE 	'USRFEAT.CMN'
C
C workspace
	INTEGER		I
	LOGICAL		ODD
C
C check all profiles measured
	DO 10 I=1,NPROF
	   IF (.NOT.PDONE(I)) THEN
	      CALL TTWSTR('One or more profiles have not been measured yet')
	      CALL WRITEF('   for example, profile %N',I)
	      DO_VOL = .FALSE.
	      GOTO 9999
	   ENDIF
10	CONTINUE
C
C integrate the volume using Prismoidal rule (i.e. Simpson's)
C see Ron's book - Practical Field Surveying..., page 558
C
	VOLUME = 0D0
	ODD = .TRUE.
	DO 20 I=1,NPROF
	   IF (ODD) THEN
	      VOLUME = VOLUME + 4*AREA(I)
	   ELSE
	      VOLUME = VOLUME + 2*AREA(I)
	   ENDIF
	   ODD = .NOT.ODD
20	CONTINUE
	VOLUME = VOLUME*((PYMAX-PYMIN)/(NPROF+1))/3.0D0
C
	DO_VOL = .TRUE.
C
9999	RETURN
	END
