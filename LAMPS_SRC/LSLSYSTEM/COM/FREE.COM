$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-01-17 14:27:56.000000000 +0000
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
$	ver:='f$verify(0)'
$!
$! FREE.COM - command file for telling free disk space
$! Authors PGH/RF, mod by TJI 29-Jan-88 for cluster
$!                 mod by  DM 10-Oct-89 for big disks
$!                 mod by PGH 25-Nov-92 for non-zero ALLOCLASS
$!                 mod by CCB 17-Jan-96 for bigger disks
$	set noon
$	count=0
$	line="Free MB:"
$	unit=0
$next_disc:
$	disc=f$trnlnm("LSL$DISK''unit'")-"_"-"_"
$	if disc.eqs."" then goto external_discs
$	   gosub disc_space
$	   unit=unit+1
$	   goto next_disc
$!
$external_discs:
$	unit=0
$next_discx:
$	disc=f$trnlnm("LSL$DISKX''unit'")-"_"-"_"
$	if disc.eqs."" then goto finished
$	   gosub disc_space
$	   unit=unit+1
$	   goto next_discx
$!
$finished:
$	write sys$output line
$	if ver then set verify
$	exit
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$disc_space:
$	if .not.f$getdvi(disc,"exists") then return
$	if .not.f$getdvi(disc,"avl") then return
$	if .not.f$getdvi(disc,"host_avail") then return
$	if .not.f$getdvi(disc,"mnt") then return
$	disc=f$getdvi(disc,"fulldevnam")-"_"
$	free=f$getdvi(disc,"freeblocks")
$	if .not.$status then exit
$	mb=(free+102)/2048	! approx rounded mb
$	dmb=(free-(mb*2048)+102)/205
$	total_size=f$getdvi(disc,"maxblock")
$	usage=(((free/200*200)/(total_size/200))+1)/2
$	count=count+1
$	if count.gt.1 then line=line+";"
$	temp=" "+disc+" ''mb'.''dmb' (''usage'%)"
$	if f$length(line+temp).ge.80 then goto output_line
$	   line=line+temp
$	   return
$output_line:
$	   write sys$output line
$	   line="        "+temp
$	   return
