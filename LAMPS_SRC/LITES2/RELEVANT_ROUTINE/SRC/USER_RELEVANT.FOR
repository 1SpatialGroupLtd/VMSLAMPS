C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-06-02 11:28:32.000000000 +0100
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
	SUBROUTINE USER_RELEVANT(PACK,ISRELEVANT)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	22-May-1989
C
C Description
C
C	LITES2 cartographic editor user written selection routine.
C	Example.
C
	IMPLICIT NONE
C
C Must be linked as a shareable image with universal symbol
C USER_RELEVANT. Assign the logical name LSL$LITES2RELEVANT to 
C the image before LITES2 is started up
C e.g.
C	$ DEFINE LSL$LITES2RELEVANT HERE:USER_RELEVANT.EXE
C	$ FORTRAN USER_RELEVANT
C	$ LINK/SHARE USER_RELEVANT,SYS$INPUT:/OPT
C	UNIVERSAL=USER_RELEVANT
C	$ ...
C
C Definitions of an external pack
C
	INTEGER		PAKLEN
	PARAMETER	(PAKLEN = 11)	! number of longwords
C
C Offsets (array subscripts) within it
C
	INTEGER		PAKLNK,PAKPNF,PAKPST,PAKFSN,PAKFC,PAKSEG
	INTEGER		PAKVRT,PAKOVL,PAKGT,PAKMAP,PAKFLG
C
	PARAMETER	(PAKLNK = 1)	! link to previous pack
	PARAMETER	(PAKPNF = 2)	! pointer to start of feature
	PARAMETER	(PAKPST = 3)	! pointer to ST
	PARAMETER	(PAKFSN = 4)	! FSN
	PARAMETER	(PAKFC  = 5)	! Feature Code
	PARAMETER	(PAKSEG = 6)	! segment number
	PARAMETER	(PAKVRT = 7)	! offset of vertex
	PARAMETER	(PAKOVL = 8)	! overlay number
	PARAMETER	(PAKGT  = 9)	! graphical type
	PARAMETER	(PAKMAP = 10)	! map
	PARAMETER	(PAKFLG = 11)	! flags
C
C arguments
	INTEGER*4	PACK(PAKLEN)
	LOGICAL		ISRELEVANT
C
C ==============================================================
C ==============================================================
C
C user written code goes here
C
C for example
C --------------------------------------------------------------
C
C assume success
	ISRELEVANT = .TRUE.
C
C only select odd numbered features
	IF (.NOT.PACK(PAKFSN)) ISRELEVANT = .FALSE.
C
C --------------------------------------------------------------
C
C ==============================================================
C ==============================================================
C
	RETURN
	END

