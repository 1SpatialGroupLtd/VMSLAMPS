;
; * This file is part of the LAMPS distribution, released as a software
; * preservation project to archive digital history for future historians.
; * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
; *
; * Timestamp of this file for the 2002 release was: 1980-07-04 16:51:24.000000000 +0100
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
	.ASK L LTT
	.ASK S STTOUT
.;
	SET /UIC=[100,5]
	.IFF L .GOTO 200
	ADC LTT = [100,6]LTT
	F4P LTT = LTT
	PIP LTT.FTN;/DE
	TKB @[100,6]LTT.TKB
	.IFINS LTT REM LTT
	.IFNINS LTT INS LTT
.;
.200:	.IFF S .GOTO 300
	ADC STT=[100,6]STT,STTOUT
	F4P STT=STT
	PIP STT.FTN;/DE
	TKB @[100,6]STT.TKB
	.IFINS STT REM STT
	.IFNINS STT INS STT
.;
.300:	PIP LTT.*,STT.*/PU
	TIME
