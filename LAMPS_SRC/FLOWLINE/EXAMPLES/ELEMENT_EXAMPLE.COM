$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-10-07 13:48:04.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$!	ELEMENT_EXAMPLE.COM
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
$!	Author : MWS Reid	6th October 1988
$!
$!	An example element command file.
$!
$! Set up filename symbols required for the procedure. These are 
$! created from job-wide symbols set up in the job command file.
$!
$	DIG_IFF == DF_POINT_PREFIX + DFAD_FILE + DF_POINT_SUFFIX
$	RAW_IFF  == DIG_IFF + DF_RAW_PLA_SUFFIX 
$	ISTART_TEMP == DF_WORK_PREFIX + DFAD_FILE + DF_RAW_PLA_SUFFIX + DF_POINT_SUFFIX
$	LTRAK = ""
$	LAY_NUM = 3
$!
$! Execute procedure command procedure
$!
$ 	@'FLN_PROCEDURE_COMPROC'
$!
$! Exit
$!
