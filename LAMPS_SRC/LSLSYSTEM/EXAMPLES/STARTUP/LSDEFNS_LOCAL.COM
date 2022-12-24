$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-07-13 08:57:46.000000000 +0100
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
$! LSDEFNS_LOCAL.COM - define node-specific LSL logical names.
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Sets up node-specific logical names for LSL software.
$! This file is only used on a VAXcluster satellite, to redirect logicals
$! such as LSL$LOCAL_ROOT to a local disk. It is to be placed in the
$! node-specific system manager directory SYS$SPECIFIC:[SYSMGR] for each
$! satellite
$!
$! Uncomment and modify any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$!
$!!!	DEASSIGN/SYSTEM LSL$LOCAL_ROOT	! to avoid message when replaced
$!!!	DEFINE/SYSTEM/TRANS=(CONCEALED,TERMINAL) LSL$LOCAL_ROOT -
$!!!		MYNODE$DKB200:[LSLLOCAL.]
$!
$	EXIT

