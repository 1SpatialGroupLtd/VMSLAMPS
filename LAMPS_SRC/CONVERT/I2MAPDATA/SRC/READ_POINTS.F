C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-12 10:52:40.000000000 +0100
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
	SUBROUTINE READ_POINTS(IENDS)
C
***	IDENT	12OC94
***	MODULE	READ_POINTS
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C	Created					RJH	23-May-1988
C
C	IMP IWINDOW Program - Read in some points
C
C Description
C
C	Reads in points from the current ST entry
C	Returns true if it succeeds
C
	IMPLICIT NONE
C
C Included Parameter Files
C
C
	INCLUDE		'($SSDEF)/NOLIST'
C
C Common Blocks
C
	INCLUDE	'CMN:IFF.CMN'      		! IFF specific things
	INCLUDE 'CMN:CONTROL.CMN'		! control variables
C
C Arguments to return
C
	INTEGER*2	IENDS			! pen up/pen down
C
C Local Variables
C
	INTEGER		I			! counter
	INTEGER		ATTC(3) 		! attribute codes
	INTEGER		NATT	  		! no. of flag attributes
C
C------------------------------------------------------------------------------
C
C Read in the CB header and data
C
	CALL EIHRCB_HEAD(CBH)	! header
	CALL EIHRCB_DATA(CBD)	! data
C
C Set some things up
C
	NPTS  = CBH.NROW
	IENDS = CBH.FLAGS
C
C Copy over the X, Y and Z coordinates
C
	ATTC(1) = IFF_C_X
	ATTC(2) = IFF_C_Y
	ATTC(3) = IFF_C_Z
	CALL IFS_CB_READ(CBH,CBD,XYZ,3,ATTC,1,NPTS)
C
C Set up column headers for flag point attributes other than 
C coordinates, which we keep separate
C
	ATTC(1) = CURVE_AC_CODE
	ATTC(2) = PRIO_AC_CODE
	ATTC(3) = 0
	CALL IFS_CB_READ(CBH,CBD,FLAGS,2,ATTC,1,NPTS)
C
C Return
C
	RETURN
	END
C
