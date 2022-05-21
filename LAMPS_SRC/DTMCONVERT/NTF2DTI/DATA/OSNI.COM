$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-01-21 17:04:22.000000000 +0000
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
$ set nover
$!
$! command file to convert OSNI NTF jiffy format to DTI via dtifromtext
$! and dticombine to convert to metres
$! data should be fixed length 80 char records, with no header records
$!
$! test test alpha:matrix
$ @lsl$com:matrixini q
$!
$   close df
$   close wf
$   close if
$!
$ open/read  df 'p1'
$ ws == "write sys$output"
$!
$   i = 0
$!
$ read_line:
$!
$   read/end_of_file=end  df data_line
$!
$!   ws "''data_line'"
$!
$   i = i + 1
$   if i .ne. 68 then goto read_line
$!
$   j = 0
$!
$! i = 68, get file size
$!
$ get_file_size:
$!
$   j = j + 1
$!
$ if j.lt.2350  then goto skip1
$!
$ if j.gt.2500  then goto end
$!
$ open/write if new_'j'.index
$ open/write wf new_'j'.dat
$!
$   xorig = f$extract(4, 4, data_line)
$   yorig = f$extract(8, 4, data_line)
$!
$ ws "''xorig', ''yorig'"
$!
$   xsize = f$extract(12, 4, data_line)
$   ysize = f$extract(16, 4, data_line)
$!
$ ws "''xsize', ''ysize'"
$!
$   write if "''xorig'000 ''yorig'000 ''xsize' ''ysize' 50 50"
$   close if
$!
$ skip1:
$!
$   read/end_of_file=end  df data_line
$!   ws "''data_line'"
$   read/end_of_file=end  df data_line
$!   ws "''data_line'"
$!
$   i = 0
$!
$ read:
$!
$   i = i + 1
$!   ws "''i'"
$!
$   read/end_of_file=end  df data_line
$   line = f$extract(2, 77, data_line)
$!
$! ws "''line'"
$!
$   if i.eq.108 then goto dtif
$!
$ if j.lt.2350 then goto skip2
$!
$   write wf line
$!
$ skip2:
$!
$   if i.ne.108 then goto read
$!
$ dtif:
$!
$   close wf
$!
$   ws "''j'"
$!
$   if j.lt.2350 then goto skip
$!
$   dtifromtext/real/ind=new_'j'.index  new_'j'.dat  here:osni'xorig''yorig'
$!
$! use dticombine to convert to metres
$!
$ open/write dtc dtc.com
$!
$ write dtc "$dticombine"
$ write dtc "	filea   here:osni''xorig'''yorig'"
$ write dtc "	fileout here:osni_''xorig'''yorig'"
$ write dtc "	real = a/10.0"
$ write dtc "	go"
$!
$ close dtc
$!
$ @dtc.com
$ del dtc.com;
$!
$ skip:
$!
$! get next file
$!
$   goto get_file_size
$!
$ end:
$!
$   close wf
$   close df
$   exit
$!
