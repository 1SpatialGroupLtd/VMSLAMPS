C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-25 10:42:22.000000000 +0100
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
	LOGICAL FUNCTION OUTRECA
C
CDEC$	IDENT	'25OC89'
C
C	Copyright  		Laser-Scan Ltd., Cambridge, England.
C
C	Author 					RWR	27-Jan-1986
C
C	Modified				APB	25-Oct-1989
C	
C		Updated to use LSLLIB, DTILIB and standard messages
C
C Description:
C
C	Outputs first record of DEM
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE		'LSL$DTI2DEM:DEMA.CMN'
	INCLUDE		'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE		'LSL$CMNLSL:MTOVCM.CMN'
C
C Function
C
	LOGICAL		OUTREC
C
C-------------------------------------------------------------------------------
C
C Write data for record A into OUTSTR, using FORTRAN write
C
   10	FORMAT(A144,4I6,15D24.15,3I6,11D24.15,I6,3E12.6,2I6)
C
	WRITE(OUTSTR,10) DEMNAM,DEMLEVEL,DEMPATT,DEMREF,DEMZONE,
     &	                      DEMTCONSTS,DEMXYUN,DEMZUN,DEMPOL,
     &	                      DOMAIN,DEMZRNG,DEMDIR,DEMACC,DEMDELX,
     &	                      DEMDELY,DEMDELZ,DEMNCOL
C
C Now output it
C
	OUTRECA=OUTREC(.FALSE.)
C
  100	CONTINUE
	RETURN
	END
