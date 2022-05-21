$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-06-28 12:46:08.000000000 +0100
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
$	LINK/DEBUG/SHARE=EXAMPLE_ROUTINE SYS$INPUT:/OPT
USRLIB/INCLUDE=(USRDO,USRGAC,USRINI,USRPAC,USRRET,-
USRSTO,USRGCB,USRGTX,USRPCB,USRPTX,USRERR,USRDEF)/LIB
UNIVERSAL = USRDO,USRGAC,USRINI,USRPAC,USRRET,USRSTO
UNIVERSAL = USRERR,USRPTX,USRGCB,USRGTX,USRPCB,USRDEF
PSECT_ATTR=USRKEEP,NOSHR
PSECT_ATTR=USRKEEPC,NOSHR
PSECT_ATTR=USRFEAT,NOSHR
PSECT_ATTR=USRFEATC,NOSHR
$!
