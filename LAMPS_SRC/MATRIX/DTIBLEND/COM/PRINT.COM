$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-06-08 18:08:48.000000000 +0100
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
$ ver_stat=f$verify(0)
$ type sys$input

+----------------------------------------------------------------------------+
|                                                                            |
|  P R I N T   C O M M A N D    P R O C E D U R E   F O R   D T I B L E N D  |
|                                                                            |
+----------------------------------------------------------------------------+

$ 	date=""
$ 	inq/nop everything "Print everything? [default NO] "
$ 	if everything then goto noquest
$ 	write sys$output "OK, incremental print required ..."
$ 	inq/nop date "Print all updated sources since when? [default TODAY] "
$ noquest:
$ 	options=""
$ 	if date.eqs."" then date="TODAY"
$ 	if .not.everything then options="/since="+date
$ set verify
$ 	print'options' *.src;,*.cmn;,*.mar;,*.mes;,*.par;,*.opt;,dtiblend.com;
$ if ver_stat.ne.1 then set noverify
