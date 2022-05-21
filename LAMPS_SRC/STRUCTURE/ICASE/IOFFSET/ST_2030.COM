$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-10-04 17:46:46.000000000 +0100
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
$!
$	ilink=="$lsl$alpha_root:[structure.exe]ilink"
$!	@lsl$com:structureini
$!
$	ioffset=="$lsl$source_root:[structure.icase.ioffset]ioffset"
$!
$	si lsl$source_root:[structure.icase.ioffset]
$!
$	ilink/break	2030_st.iff 2030_st.ifj
$	ilink/struct	2030_st.ifj 2030_st.ifj
$	ilink/sortarms	2030_st.ifj 2030_st.ifj
$!
$	ioffset /par=lsl$source_root:[structure.icase.ioffset]st.par -
		2030_st.ifj -
		2030_st_cased.iff
$!
$	purge 	2030_st.*
$!
