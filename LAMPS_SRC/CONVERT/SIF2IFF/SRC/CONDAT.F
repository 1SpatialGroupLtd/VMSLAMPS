C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-03-18 13:07:02.000000000 +0000
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
	SUBROUTINE	CONDAT
C
CDEC$	IDENT	'30JA90'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jan-1990	J.M.Cadogan
C
C Description:
C
C	CONVERT SIF2IFF UTILITY - Convert SIF data
C
	IMPLICIT	NONE
C
C Parameter files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'		! messages
	INCLUDE 'CMN:LUN.PAR'			! logical unit numbers
C
C Common Blocks
C
	INCLUDE 'CMN:FILES.CMN'
C
C Functions
C
	LOGICAL		RDSIF			! read SIF parameters
	LOGICAL		WRITE_START		! initial IFF info
C
C Workspace
C
	LOGICAL		OK			! function call status
C
C-------------------------------------------------------------------------------
C
C
C Write IFF file header info.
C
	OK = WRITE_START()
	IF (.NOT.OK) GOTO 999
C
C Read command string from SIF file
C
	OK = RDSIF()
	IF (.NOT.OK) THEN
	   CALL LSL_EXIT
	   GOTO 999
	ENDIF
C
C Write stuff to end the IFF file then close
C
	CALL WRITE_END
C
C And thats it.
C
999	RETURN
	END
