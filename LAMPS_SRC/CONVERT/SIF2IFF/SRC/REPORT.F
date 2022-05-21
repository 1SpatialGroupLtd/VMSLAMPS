C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-09-29 21:36:34.000000000 +0100
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
        SUBROUTINE REPORT
C
CDEC$	IDENT   '28SE90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	16-Jan-1990
C
C	CONVERT SIF2IFF Utility - Report on what we are doing
C
C Description
C
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'CMN:FILES.CMN'		! filenames
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'CMN:IFF_MAP.CMN'	! IFF map data
C
C Report on things we get straight from the command line
C
	CALL WRITEF(' ')
	CALL WRITEF('Parameter file         : %S',PARFIL(1:PARLEN))
C
	CALL WRITEF('SIF file               : %S',SIFFIL(1:SIFLEN))
C
	CALL WRITEF('IFF output file        : %S',IFFFIL(1:IFFLEN))
C
	IF (HAD_OFFSET) THEN
	   CALL WRITEF(' ')
	   IF (HAD_OFFSET) THEN
	      CALL WRITEF('Offsets                : %^D%G10.8, %G10.8',
     &	         XOFF,YOFF)
	   ENDIF
	   CALL WRITEF(' ')
	ELSE
	   CALL WRITEF(' ')
	ENDIF
C
C Return
C
	RETURN
        END
