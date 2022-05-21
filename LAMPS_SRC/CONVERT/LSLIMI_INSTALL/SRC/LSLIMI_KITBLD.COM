$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 2000-01-06 15:18:12.000000000 +0000
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
$! This command file generates a kit suitable for installation with VMSINSTAL
$! Mod 1468. Modified to include AXP images.		ST 22-Feb-1995
$!
$ LSLPRODUCT="LSLIMI"
$ LSLVERSION="1601"
$ LSLFILES="KITINSTAL.COM,"-
+"LSL$PUBLIC_ROOT:[CONVERT.COM]LSLIMI_MENU.COM,"-
+"LSLIMI_LSLINI.COM,LSLIMI_MENU_INI.COM,"-
+"[CONVERT.EXE]*IMAP*.EXE,*OSTF*.EXE,*NTF*.EXE,"-
+"[CONVERT.LOOKUP]OS.*IMAP*_PAR,"-
+"[MAPPING.LIB]*SHR.EXE,*SHR_TV.EXE,"-
+"[LSLSYSTEM.LIB]LSLSHR.EXE,LSLSHR_TV.EXE"
$!
$ WRITE SYS$OUTPUT ""
$ WRITE SYS$OUTPUT "	LSL KITBLD for ",LSLPRODUCT," Version ",LSLVERSION
$ COPY 'LSLPRODUCT'_KITINSTAL.COM HERE:KITINSTAL.COM
$ PURGE KITINSTAL.COM
$ @LSLKITBLD 'LSLPRODUCT''LSLVERSION' "" 'LSLFILES'
