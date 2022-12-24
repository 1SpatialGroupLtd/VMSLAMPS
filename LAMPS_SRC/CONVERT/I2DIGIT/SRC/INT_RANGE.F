C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-01-07 16:36:30.000000000 +0000
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
	INTEGER*4 FUNCTION INT_RANGE(N,RMIN,RMAX,EXCEPTION,ROW,COL)
C
CDEC$	IDENT	'10DE91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	10-Dec-1991
C
C Description:
C       A routine to check that the values held in a particular entry
C       of the parameter file is in the correct range. In most cased the
C       value can have an exception. (ie -1 means undefined).
C
        IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common Blocks
C
	INCLUDE 'GENERAL.CMN'			! for UNDEFINED
C
	INTEGER*4	ROW,COL
	INTEGER*4	N,RMIN,RMAX,EXCEPTION
C
C------------------------------------------------------------------------------
C
	INT_RANGE = (N.EQ.EXCEPTION.OR.
     &		     N.EQ.UNDEFINED.OR.
     &		    (N.GE.RMIN.AND.N.LE.RMAX))
C
	IF (.NOT.INT_RANGE) CALL LSL_PUTMSG(I2DIGIT__ERRINPAR,COL,ROW)
C
	RETURN
	END
