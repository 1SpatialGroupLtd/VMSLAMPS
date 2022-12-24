C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-03-06 12:50:48.000000000 +0000
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
	LOGICAL FUNCTION RDFRT(FRTFILE)
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	8-Feb-1991
C
C Description:
C
C	This function reads the parameter file which translates 
C	ARC/INFO attributes into IFF AC codes and visa-versa
C       It is put into its own small Fortran routine and called from I2ARC
C       because FRTINI needs to fill the common block so that other Fortran
C       routines can access it and so that C can access the FRTCOM.H which
C       maps onto it.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:I2ARCMSG.PAR'		! I2ARC messages
C
C Common blocks
C
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'		! FRT info
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'		! FRT ACD info
C
	CHARACTER*(*)	FRTFILE
C
C Functions called
C
	LOGICAL		FRTINI
C
C-------------------------------------------------------------------------------
C
C Assume that everything goes well
C
	RDFRT = .TRUE.
C
	IF (FRTINI(FRTFILE)) RDFRT = .FALSE.
C
C Return
C
	RETURN
	END
