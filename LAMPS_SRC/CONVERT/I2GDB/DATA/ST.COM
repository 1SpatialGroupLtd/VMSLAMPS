$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-07-29 18:19:36.000000000 +0100
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

$! TEST OUT I2GDB PROGRAM
$!
$! output revision level 1
$	define lsl$iff_output_revision 1
$!
$! define which version of the program to use
$!
$!	i2gdb == "$lsl$source_root:[convert.i2gdb]i2gdb"
$!
$! generate iff file for testing
$!
$	ifromtext/frt=here:st.frt -
		here:st.txt -
		here:st.iff
$!
$! run it
$!
$	i2gdb 	/frt=here:st.frt -
		/parameters=here:st.par -
		here:st.iff -
		here:st.gdb
