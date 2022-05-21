$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1983-12-09 12:07:40.000000000 +0000
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
$	inquire TEK "TEKCI"
$	inquire PIC "picl,cspeed,chtest"
$	inquire CUR "curve"
$	inquire TCI "Build TEKCI"
$	inquire LCI "Build LTEKCI"
$	inquire L14CI "Build L14CI"
$	set ver
$	if .not. TEK then goto NOTEK
$	adc tekci.ftn=tekci
$	f4p tekci=tekci
$	pvr tekci
$	del tekci.ftn;*,adc.ide;*
$ NOTEK: if .not. PIC then goto NOPIC
$	adc picl.ftn=picl,cspeed,chtest
$	f4p picl=picl
$	pvr picl
$	del picl.ftn;*,adc.ide;*
$ NOPIC: if .not. CUR then goto NOCUR
$	mcr mac curve=tkhd02,curve
$ NOCUR: if .not. TCI then goto notci
$	mcr TKB @tekci.tkb
$	pl tekci.*
$ NOTCI: if .not. LCI then goto nolci
$	mcr TKB @ltekci.tkb
$	pl ltekci.*
$ NOLCI: if .not. L14CI then goto nolnk
$	mcr TKB @l14ci.tkb
$	pl l14ci.*
$ NOLNK: pl *.obj
$	set nover
