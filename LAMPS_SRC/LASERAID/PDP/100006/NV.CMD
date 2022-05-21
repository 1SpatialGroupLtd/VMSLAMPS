;
; * This file is part of the LAMPS distribution, released as a software
; * preservation project to archive digital history for future historians.
; * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
; *
; * Timestamp of this file for the 2002 release was: 1980-02-21 11:56:04.000000000 +0000
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
.ENABLE SUBSTITUTION
.SETS $BLANK ""
.SETN $N 0
.BA:.INC $N
.ASKS FILE FILE '$N'
.SETS FIL'$N' "'FILE'"
.IF FILE = $BLANK .GOTO MA
NED 'FILE'
.ASK T PURGE
.ASK LIST'$N' LIST
.IFT T PIP 'FILE'/PU
.GOTO BA

.MA:.DEC $N
.SETN LIM $N
.SETN $N 0
.MM:.INC $N
.IF $N > LIM .GOTO ZA
.SETS S FIL'$N'
; '$N'.	'S'
.IFT LIST'$N' LST 'S'
.GOTO MM

.ZA:TIM
