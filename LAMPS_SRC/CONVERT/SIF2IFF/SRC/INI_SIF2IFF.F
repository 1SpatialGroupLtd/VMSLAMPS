C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-03-16 17:55:06.000000000 +0000
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
        SUBROUTINE INI_SIF2IFF
C
CDEC$	IDENT   '16MR92'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	14-Jan-1990
C
C	CONVERT SIF2IFF Utility - Initialisation of globals
C
C Description
C
C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:FDF.PAR'	! message definitions
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	! message definitions
C
C Arguments
C
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
C
C Functions called
C
C
C Local Variables
C
	INTEGER		I		!loop counter
C
C----------------------------------------------------------------------------
C
	UNITS = 1000		! SIF UORS per metre default value
	LINWGT = 0		! SIF line weight
	LINSTY = 0		! SIF line style
	LINCOL = 0		! SIF line colour
	LINPAT = 0		! SIF line pattern
	DIMEN = 2		! 2D or 3D default value
	FONT = 0		! SIF text font
	LINE = 0		! file line counter
	ARCDIR = -999		! arc direction
	AREAPAT = 0		! area pattern
	PATTYPE = 0		! line or area pattern type
	PATNAM = 'NOPAT'	! line or area pattern name
	XMIN = 0
	XMAX = 0
	YMIN = 0
	YMAX = 0
	ZMIN = 0
	ZMAX = 0
C
C initialise list of unsupported commands and counter
C
	UNSUP  = '   '
	IUNSUP = 0
	DO 10 I = 1,30
	   UNSUPLIST(I) = '   '
10	CONTINUE
C
	HAD_TXT_TH = .FALSE.
	HAD_TXT_AN = .FALSE.
	HAD_POINTSIZE = .FALSE.
C

	NOLINEMESS = .FALSE.
C
C Return
C
	RETURN
        END
