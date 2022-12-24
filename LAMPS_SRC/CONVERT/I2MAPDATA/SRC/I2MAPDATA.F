C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-12 11:11:42.000000000 +0100
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
	PROGRAM I2MAPDATA
C
CDEC$	IDENT	'12OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	29-Aug-1994
C
C	CONVERT I2MAPDATA Utility - IFF to AA MAP Format Convertor
C
C Description
C
C	Converts from IFF to AA ASCII MAP format.
C
	IMPLICIT	NONE
C
C Functions called
C
	INTEGER*4	OBEY		! decode command line
	INTEGER*4	RDFRT		! read FRT file
	INTEGER*4	RDPAR		! read and validate parameter file
	INTEGER*4	OPEN_IFF	! open IFF file
	INTEGER*4	OPEN_MD		! open MAPDATA file
	INTEGER*4	CLOSE_IFF	! close IFF file
	INTEGER*4	CLOSE_MD	! close MAPDATA file
C
C Local Variables
C
	INTEGER*4	OK		! status return code
C
C Initialise things
C
	CALL LSL_INIT(.TRUE.)		! initialise LSLLIB
	CALL CONTROL_INIT		! initialise control variables
C
C Decode the command line
C
	OK = OBEY()
	IF (.NOT. OK) GOTO 999
C
C Read the FRT and parameter files
C
	OK = RDFRT()			! read FRT file
	IF (.NOT. OK) GOTO 999
C
	OK = RDPAR()			! read and validate parameter file
	IF (.NOT. OK) GOTO 999
C
C Open the data files
C
	OK = OPEN_IFF()			! open IFF input file
	IF (.NOT. OK) GOTO 999
C
	OK = OPEN_MD()			! open MAPDATA output file
	IF (.NOT. OK) THEN
	   CALL CLOSE_IFF		! close IFF input file
	   GOTO 999
	ENDIF
C
C Do the conversion
C
	CALL PROCESS
C
C Close the data files
C
	CALL CLOSE_MD			! close MAPDATA output file
	CALL CLOSE_IFF			! close IFF input file
C
C Set the return status and finish up
C
 999	CALL LSL_EXIT
	END
