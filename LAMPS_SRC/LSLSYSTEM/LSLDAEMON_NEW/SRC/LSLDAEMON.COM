$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-01-12 13:58:02.000000000 +0000
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
$! LSLDAEMON.COM - command procedure to start LSL idle process daemon (detached)
$! Note that LSLDAEMON expects a configuration file SYS$MANAGER:LSLDAEMON.CONFIG
$! containing time interval and number of warnings (default 20 mins,2 warnings).
$!
$ Run lsl$exe:LSLDAEMON -
/input=nl: /output=nl: /error=sys$manager:LSLDAEMON_error.log -
/maximum_working_set=256 /working_set=100 -
/privileges=(nosame,sysprv,world,oper,tmpmbx) -
/process_name="LSLDAEMON" /uic=[1,4] 
$ Exit
