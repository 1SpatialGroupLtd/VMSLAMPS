;
; * This file is part of the LAMPS distribution, released as a software
; * preservation project to archive digital history for future historians.
; * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
; *
; * Timestamp of this file for the 2002 release was: 1983-12-09 11:11:16.000000000 +0000
; *
; * This program is free software: you can redistribute it and/or modify
; * it under the terms of the GNU General Public License as published by
; * the Free Software Foundation, version 3.
; *
; * This program is distributed in the hope that it will be useful, but
; * WITHOUT ANY WARRANTY; without even the implied warranty of
; * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
; * General Public License for more details.
; *
; * You should have received a copy of the GNU General Public License
; * along with this program. If not, see http://www.gnu.org/licenses/.
;
.ask TEK TEKCI
.ask PIC picl,cspeed,chtest
.ask CUR curve
.ask TCI Build TEKCI
.ask LCI Build LTEKCI
.ask L14CI Build L14CI
.iff TEK .goto NOTEK
adc tekci.ftn=tekci
f4p tekci=tekci
pvr tekci
pip tekci.ftn;*,adc.ide;*/de
.NOTEK: .iff PIC .goto NOPIC
adc picl.ftn=picl,cspeed,chtest
f4p picl=picl
pvr picl
pip picl.ftn;*,adc.ide;*/de
.NOPIC: .iff CUR .goto NOCUR
mac curve=tkhd02,curve
.NOCUR: .iff TCI .goto notci
TKB @tekci.tkb
pip tekci.*/pu
.NOTCI: .iff LCI .goto nolci
TKB @ltekci.tkb
pip ltekci.*/pu
.NOLCI: .iff L14CI .goto nolnk
TKB @l14ci.tkb
pip l14ci.*/pu
.NOLNK: pip *.obj/pu
