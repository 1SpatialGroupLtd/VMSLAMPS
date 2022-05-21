$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-09-22 16:30:18.000000000 +0100
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
$	si lsl$source_root:[convert.i2digit]
$!
$!	i2digit=="$lsl$source_root:[convert.i2digit]i2digit"
$!
$!	i2digit	/part=atestttt -
$!		/para=test.par -
$!		/log -
$!		/noappend -
$!		/RESOLUTION 	=7-
$!		/SCALE_IFF	=777.7-
$!		/SCALE_SHEET	=77777.7-
$!		/OFFSET		=(777,777)-
$!		/BORDER		=70-
$!		/XMIN		=700.0-
$!		/XMAX		=17000.0-
$!		/YMIN		=700.0-
$!		/YMAX		=17000.0-
$!		test -
$!		mub1:
$	i2digit	/part=atestttt -
		/para=test.par -
		/log -
		/noappend -
		/RESOLUTION 	=20-
		/OFFSET		=(10,10)-
		/BORDER		=10-
		/XMIN		=0-
		/XMax		=300-
		/yMax		=300-
		/scale_factor  -
		abercontour -
		mub1:
$!
$	purge test.*
$!
