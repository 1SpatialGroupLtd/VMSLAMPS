$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-10-24 13:43:36.000000000 +0000
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
$	set noverify
$	on control then goto end
$	on error then goto end
$!
$	set verify
$	adc appendix = appendix
$	fort appendix
$	pvv appendix
$	delete	adc.ide;*
$	purge appendix.obj
$	delete  appendix.for;*
$!
$	adc md2dat = lsl$cmniff:md2dat
$	fort md2dat
$	pvv md2dat
$	delete adc.ide;*
$	purge md2dat.obj
$	delete md2dat.for;*
$!!!	link	appendix,md2dat,lsl$SOURCE_ROOT:[LSLMAINT.GCTPLIB]gctpdlib/lib,-
$!!!                     lsl$library:lsllib/lib
$	link	appendix,md2dat,lsl$library:gctplib/lib,-
                     lsl$library:lsllib/lib
$	delete md2dat.obj;*,appendix.obj;*
$	purge appendix.exe
$	run appendix
$	runoff appendix
$	purge appendix.rno
$	purge appendix.mem
$ end:	set noverify
