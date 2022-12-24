C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-01-28 13:45:40.000000000 +0000
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
	SUBROUTINE 	ID_CCSM( IDENT,USER1,USER2,CCSM )
C
CDEC$	IDENT	'15NO89'
C
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			9-Nov-1989			A.P.Brown
C
C Description:
C
C	Decode the ident field ID=ident,user1,user2 to return a CCSM code
C
	IMPLICIT	NONE
C
	CHARACTER*12	CCSM		! Return CCSM code
	INTEGER		IDENT		
	INTEGER		USER1
	INTEGER		USER2
C
	INTEGER		CCSM_2
	INTEGER		CCSM_3
	CHARACTER*6	CCSMC_2
	CHARACTER*4	CCSMC_3
C
C-------------------------------------------------------------------------------
C
	CCSM(1:12) = '            '
C
	CCSM(1:1) = CHAR( IDENT .AND. '00FF'X )
	CCSM(2:2) = CHAR( (IDENT .AND. 'FF00'X)/'0100'X )
C
	CCSM_2    = ( USER1 .AND. 'FFFF'X ) + 100000
	CCSM_3    = ( USER2 .AND. '7FF'X ) + 1000
	WRITE ( CCSMC_2,'(I6)' ) CCSM_2
	WRITE ( CCSMC_3,'(I4)' ) CCSM_3
C
	CCSM(4:8) = CCSMC_2(2:6)
	CCSM(10:12) = CCSMC_3(2:4)
C
	RETURN
	END
