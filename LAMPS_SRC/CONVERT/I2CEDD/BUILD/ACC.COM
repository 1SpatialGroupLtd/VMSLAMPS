$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-08-26 11:47:18.000000000 +0100
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
$	savver = f$verify(1)
$!
$	def/user sys$input sys$command
$	i2cedd/diag/frt=cedd -
		lsl$if:iffcedd_accept_input.iff -
		lsl$if:iffcedd_accept_text.txt
$!
$	def/user sys$input sys$command
$	cedd2i/diag/frt=cedd -
		lsl$if:iffcedd_accept_text.txt -
		lsl$if:iffcedd_accept_output.iff
$!
$	idifference iffcedd_accept_input iffcedd_accept_output_0001
$!
$	savver = f$verify(savver)
