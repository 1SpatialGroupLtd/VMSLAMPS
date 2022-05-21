$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-10-11 11:01:02.000000000 +0100
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
$! File to create the FLOWLINE database all the fields and relations
$!
$ oper = f$getjpi("","USERNAME")
$ work = f$trnlnm("lsl$fln_workstation")
$ if work.eqs.""
$ then
$   write sys$output "LSL$FLN_WORKSTATION is not defined"
$   exit
$ endif
$!
$! write temporary command file to authorise operator and workstation
$ open/write cmdfil sys$scratch:flowline_db_authorise.rdo
$ wc = "write cmdfil"
$ wc "store o in operator using"
$ wc " o.operator_id = ""''oper'"""
$ wc "end_store"
$ wc "store w in workstation using" 
$ wc " w.workstation_id = ""''work'"""
$ wc "end_store"
$ close cmdfil
$!
$ set verify
$run sys$system:rdo
define database "lsl$fln_database:flowline".
sho database
@lsl$com:flowline_relations
@sys$scratch:flowline_db_authorise
commit
sho relations
finish
exit
$ set noverify
$ delete/noconfirm sys$scratch:flowline_db_authorise.rdo;*
$!
