$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-12-12 19:54:58.000000000 +0000
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
$	set noverify            
$	on control_y then goto end
$	on error     then goto end
$!
$! command file: OSMH - a command file to compile the OSMH routines
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England
$!
$! Author TJ Ibbs, 12 October 1987
$!
$! *************************************************************************
$!
$	wsb = "write sys$output """""
$!
$	inquire crelib "Create a new library               "
$!
$  	inquire debug  "Compile with debug                 "
$	if debug.eqs."" then P1 = "N"
$!
$	wsb
$	inquire bin "ICL binary days                    "
$	inquire my  "    month/year                     "
$	inquire chr "ICL 6bit characters                "
$	inquire hav "ICL  half words                    "
$	inquire bit "ICL  bit fields                    "
$	inquire upg "Upgrade Map Header                 "
$	wsb
$!
$	if      crelib then libc = "library/insert  osmh"
$	if .not.crelib then libc = "library/replace osmh"
$!
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if debug then dbg = "/debug/noopt"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$	if crelib then library/create osmh
$!
$	set verify
$	if .not.bin then goto nobin
$	   adc osmh_binday/co = osmh_to_binday,osmh_from_binday
$	   fort/extend'dbg' osmh_binday
$	   pvv osmh_binday
$	   purge osmh_binday.obj
$	   delete adc.ide;*
$	   'pd' osmh_binday.for'ver'
$	   'libc' osmh_binday
$!
$nobin:	if .not.my  then goto nomy
$	   adc osmh_my/co = osmh_putmy,osmh_getmy
$	   fort/extend'dbg' osmh_my
$	   pvv osmh_my
$	   purge osmh_my.obj
$	   delete adc.ide;*
$	   'pd' osmh_my.for'ver'
$	   'libc' osmh_my
$!
$nomy:	if .not.chr then goto nochr
$	   adc osmh_char/co = osmh_putchar,osmh_getchar
$	   fort/extend'dbg' osmh_char
$	   pvv osmh_char
$	   purge osmh_char.obj
$	   delete adc.ide;*
$	   'pd' osmh_char.for'ver'
$	   'libc' osmh_char
$!
$nochr:	if .not.hav then goto nohav
$	   adc osmh_halves/co = osmh_puthalves,osmh_gethalves
$	   fort/extend'dbg' osmh_halves
$	   pvv osmh_halves
$	   purge osmh_halves.obj
$	   delete adc.ide;*
$	   'pd' osmh_halves.for'ver'
$	   'libc' osmh_halves
$!
$nohav:	if .not.bit then goto nobit
$	   adc osmh_bits/co = osmh_putbits,osmh_getbits
$	   fort/extend'dbg' osmh_bits
$	   pvv osmh_bits
$	   purge osmh_bits.obj
$	   delete adc.ide;*
$	   'pd' osmh_bits.for'ver'
$	   'libc' osmh_bits
$!
$nobit:	if .not.upg then goto noupg
$	   adc osmh_upgrade/co = osmh_upgrade,osmh_cid_zero
$	   fort/extend'dbg' osmh_upgrade
$	   pvv osmh_upgrade
$	   purge osmh_upgrade.obj
$	   delete adc.ide;*
$	   'pd' osmh_upgrade.for'ver'
$	   'libc' osmh_upgrade
$!
$noupg:
$end:
$	set noverify
