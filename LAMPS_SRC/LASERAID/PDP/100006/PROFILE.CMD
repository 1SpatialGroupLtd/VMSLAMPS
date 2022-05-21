;
; * This file is part of the LAMPS distribution, released as a software
; * preservation project to archive digital history for future historians.
; * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
; *
; * Timestamp of this file for the 2002 release was: 1980-07-08 18:54:52.000000000 +0100
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
.ASK C COMPILE
.ASK T TASK BUILD
.IFT T .ASK M MAP
.IFF C .GOTO 100
MAC PROFILE=PROFILE
ADC PROF=PROTEST,PROTYP
F4P PROF=PROF
.100:.IFF T .GOTO 200
TKB PROF/FP,PROF/-SP=PROF,PROFILE,[1,1]TITS/DA,[1,1]F4PLIB/LB
LMP PROF.MAP
.IFT M MC PROF.MAP
.200:
