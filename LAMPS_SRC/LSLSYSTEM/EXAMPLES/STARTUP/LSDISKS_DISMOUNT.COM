$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-07-12 11:10:50.000000000 +0100
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
$! LSDISKS_DISMOUNT.COM - dismount LSL disks. Called from SYSHUTDWN.COM.
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Dismount any cluster-mounted local disks on satellites.
$!
$! This procedure is provided as an aid to VMS system management on
$! LSL LAMPS Mapping/GIS turnkey systems. It is not a necessary part of 
$! the LSL environment, and will not automatically be invoked. It is up to
$! the local VMS System Manager to decide on its applicability. It can help
$! where disks attached locally to satellites are mounted cluster-wide, and
$! the satellites may be removed from the cluster for standalone operation.
$! It should not be invoked during a quick reboot of a boot node or file server.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSDISKS_DISMOUNT.COM - "Dismounting local disks"
$!
$! DCL filched from SHUTDOWN.COM
$!
$sysdev = f$getdvi("SYS$SYSDEVICE","FULLDEVNAM")
$define/user sys$output sys$specific:[sysexe]shutdown.tmp
$show device/mounted
$open/error=69 shutdown$temp_file sys$specific:[sysexe]shutdown.tmp
$62: read/end_of_file=69/error=69 shutdown$temp_file line
$if f$loc(":",line) .eq. f$len(line) then goto 62
$if .not. f$getdvi(f$elem(0,":",line),"EXISTS") then goto 62
$dev = f$getdvi(f$elem(0,":",line),"FULLDEVNAM")
$if f$getdvi(dev,"DEVCLASS") .ne. 1 .or. f$getdvi(dev,"REMOTE_DEVICE") .or. -
.not. f$getdvi(dev,"MNT") .or. dev .eqs. sysdev then goto 62
$ws "Dismounting disk ''dev from cluster"
$dismount/nounload/cluster/abort 'dev
$goto 62
$69: close /nolog shutdown$temp_file
$if f$search("sys$specific:[sysexe]shutdown.tmp") .nes. "" then -
delete sys$specific:[sysexe]shutdown.tmp;*
$!
$	EXIT
