C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-07-10 17:13:58.000000000 +0100
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
        LOGICAL*4 FUNCTION USE_FC(FC)
C
CDEC$	IDENT	'10JL90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Check if FC at hand is to be used
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
C
C Local variables
C
	INTEGER*2	FC			! feature code at hand
	INTEGER*2	LOOP			! loop counter
C
	USE_FC = .TRUE.
C
C
C
      	IF (NUM_FC .NE. 0) THEN   		! if we have a FC list
C
C Check if current FC is in the list
C
	    DO LOOP = 1,NUM_FC
		IF ( FC_LIST(LOOP) .EQ. FC) GO TO 999	! FC found
	    ENDDO
C
C No current FC is not in the list, set return to FALSE
C
	    USE_FC = .FALSE.
C
	ENDIF
C
C
C Return
C
  999 	CONTINUE
	RETURN
C
        END
