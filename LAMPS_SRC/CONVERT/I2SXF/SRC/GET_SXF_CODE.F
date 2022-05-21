C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-06-20 11:35:46.000000000 +0100
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
        INTEGER*4 FUNCTION GET_SXF_CODE(FC)
C
CDEC$	IDENT	'20JN90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Find SXF code for FC at hand
C
C Description
C
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
	INCLUDE 'LSL$CMNI2SXF:TABLE.CMN'	! feature description table
C                                               
C Local variables
C
	INTEGER*2	FC			! feature code at hand
	INTEGER*2	LOOP			! local loop counter
C
C Assume failure
C
	GET_SXF_CODE = -1
C
C
	DO LOOP=1,TABLE_LEN
	   IF(FC_TABLE(LOOP) .EQ. FC) GO TO 100
	ENDDO
C
	GO TO 200  				! feature not found
C
  100	CONTINUE				! feature found
C
	GET_SXF_CODE = SXF_TABLE(LOOP)
C
  200	CONTINUE
C
C Return
C
	RETURN
        END
