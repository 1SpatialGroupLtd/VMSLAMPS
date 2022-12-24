$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-06-08 16:09:58.000000000 +0100
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
$ SET VERIFY
$! deletes all data in dynamic flowline relations
$ MCR RDO
DATABASE FILE LSL$FLN_DATABASE:FLOWLINE
START_TRANSACTION READ_WRITE
FOR J IN JOB ERASE J END_FOR
FOR W IN WIRE_ACTIVE ERASE W END_FOR
FOR T IN TASK ERASE T END_FOR
FOR S IN SESSION ERASE S END_FOR
!FOR SH IN SESSION_HISTORY ERASE SH END_FOR
!FOR TH IN TASK_HISTORY ERASE TH END_FOR
COMMIT
EXIT
$ SET NOVERIFY
