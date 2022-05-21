$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-07-21 10:57:56.000000000 +0100
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
$ SET NOON
$ SET VERIFY
$ SRCPRINT="PRINT/QUEUE=ANSI_P$LSLLPA/PARAM=(SIDE=2,NUMBER=4)/HEADER/PRIO=50"
$ MAPPRINT="PRINT/QUEUE=ANSI_L$LSLLPA/PARAM=(SIDE=2,NUMBER=4)/PRIO=50"
$!
$ SRCPRINT [.COM]*.UPD/NAME=FPP_UPD
$!
$ SRCPRINT [.COM]*.COM/NAME=FPP_COM
$ SRCPRINT [.MAR]*.MAR/NAME=FPP_MAR
$ SRCPRINT [.SRC]*.SRC/NAME=FPP_SRC
$ SRCPRINT [.MES]*.MES,*.PAR/NAME=FPP_MES
$ SRCPRINT [.DEV]*POSTSCRIPT*.*/NAME=FPP_DEV
$!
$ SRCPRINT [.CMN]*.CMN,*.PAR/NAME=FPP_CMN
$ MAPPRINT [.OBJ]FPPSHR.MAP,GKSPOSTSCRIPTSHR.MAP,FPPPOSTSCRIPT.MAP/NAME=FPP_MAP
$ SET NOVERIFY
