$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-06-08 15:18:20.000000000 +0100
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
$! Andrew Verrill, 7 Jun 90
$! Test real version of istdst.
$!
$ i2*tdst==	"$lsl$source_root:[convert.i2tdst]i2tdst"
$ i2	lsl$data_root:[lsl.dst]malaysia.ilf-
 	lsl$data_root:[lsl.dst]malaysia.dst-
 /frt=	lsl$data_root:[lsl.dst]laserscan_plot.frt-
 /bnt=	lsl$data_root:[lsl.dst]malay.bnt
