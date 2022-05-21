C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-01-13 18:18:28.000000000 +0000
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
	SUBROUTINE USRPAC(ACTYPE,ACIVAL,ACTXTL,ACTXT,RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Example user routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	ACTYPE		! type of AC
	INTEGER*4	ACIVAL		! AC value
					! note: to read a real AC value,
					! a copy of this will have to
					! be equivalenced to a real
	INTEGER*4	ACTXTL		! number of characters in ACTXT
	CHARACTER*(*)	ACTXT		! text (maximum of 80 chars)
	INTEGER*4	RETCOD		! return code
					! = 0 abort, no call USRRET
					! = 1 for write another AC if
					!     there are any, or else
					!     start writing coords
					! = 2 for start writing coords
					! = 4 for abort, call USRRET
C
C	All these arguments are writable
C
C working storage
C
	INCLUDE		'USRKEEP.CMN'
	INCLUDE 	'USRFEAT.CMN'
C
C
	NHACS=NHACS+1
C
	IF (NHACS.GT.USR_NACS) THEN	! no more ACs to send 
	   RETCOD=2
	ELSE
C
C	fill in this AC
C
	   ACTYPE=TYPE(NHACS)
	   ACIVAL=VALUE(NHACS)
	   ACTXTL=TXTL(NHACS)
	   IF (TXTL(NHACS).GT.0) ACTXT=TXT(NHACS)(1:TXTL(NHACS))
	   RETCOD=1
	ENDIF
C
	RETURN
	END
