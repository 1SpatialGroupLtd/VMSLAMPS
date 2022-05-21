C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-01-13 18:02:00.000000000 +0000
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
	SUBROUTINE USRSTO(FSN,FC,MAP,LAYER,TXTF,NOPTS,NAC,
     &	                  ROTAT,THICK,RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Dummy routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	FSN		! feature serial number to use
					! (set to -1 for unknown)
	INTEGER*4	FC(4)		! feature status to use
					! (set FC(I) to -1 for unknown)
	INTEGER*4	MAP		! map to put feature in
					! (set to -1 for unknown)
	INTEGER*4	LAYER		! layer to use
					! (set to -1 for unknown)
	LOGICAL		TXTF		! .TRUE. if FC =-1 and want
					! to create a text feature
	INTEGER*4	NOPTS		! number of points in feature
	INTEGER*4	NAC		! number of ACs in feature
	REAL		ROTAT		! rotation if text or oriented
					! symbol (in radians)
	INTEGER*4	THICK		! size of text
	INTEGER*4	RETCOD		! return code
					! = 0 abort, dont call completion
					!     routine
					! = 1 for ask for data
					! = 4 abort, call completion
					!     routine
C
C all the arguments in this subroutine are writable
C
C in this version, don't do anything
C
	RETCOD=0
C
	RETURN
	END
