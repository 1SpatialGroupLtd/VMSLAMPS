C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-09 17:11:24.000000000 +0100
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
	SUBROUTINE CONTROL_INIT
C
CDEC$	IDENT	'09SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					RJH	 1-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Initialise Control Variables
C
C Description
C
C	Initialises the variables which control processing. These variables
C	are set after interpretation of the command line and reading of the
C	parameter file has been completed.
C
	IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'CMN:CONTROL.CMN'		! control variables
C
C First ensure all the flags are unset
C
	HAD_FRT      = .FALSE.
	HAD_LOG      = .FALSE.
	HAD_CURVE_AC = .FALSE.
	HAD_PRIO_AC  = .FALSE.
	HAD_TEXT_AC  = .FALSE.
	HAD_OFFSET   = .FALSE.
	HAD_DIVIDE   = .FALSE.
C
	NEG_CURVE_AC = .FALSE.
	NEG_PRIO_AC  = .FALSE.
	NEG_TEXT_AC  = .FALSE.
	NEG_OFFSET   = .FALSE.
C
	DEF_OFFSET   = .FALSE.
C
C Set AC codes to impossible values, and ensure names are blank
C
	CURVE_AC_CODE = -1
	PRIO_AC_CODE  = -1
	TEXT_AC_CODE  = -1
C
	CURVE_AC_NAME = ' '
	PRIO_AC_NAME  = ' '
	TEXT_AC_NAME  = ' '
C
	CURVE_AC_LEN = 0
	PRIO_AC_LEN  = 0
	TEXT_AC_LEN  = 0
C
C Set IFF coordinate divisor to the default value
C
	DIVISOR = 1
C
C Return
C
	RETURN
	END
