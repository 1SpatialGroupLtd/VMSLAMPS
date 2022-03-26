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
