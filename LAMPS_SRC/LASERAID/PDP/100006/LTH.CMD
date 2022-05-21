;
; * This file is part of the LAMPS distribution, released as a software
; * preservation project to archive digital history for future historians.
; * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
; *
; * Timestamp of this file for the 2002 release was: 1980-07-16 12:38:42.000000000 +0100
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
	.ENABLE GLOBAL
	.ENABLE SUBSTITUTION
	.ENABLE LOWERCASE
	.IFNDF $COMP .ASK $COMP compile
	.IFNDF $TASK .ASK $TASK task build
	.IFF $TASK .SETF $TITS
	.IFT $TASK .IFNDF $TITS .ASK $TITS * tits
	.IFNDF $BATCH .ASK $BATCH batch
.;
	.IFF $BATCH .GOTO 100
.; prepare batch file
	.OPEN [100,6]LTH.BAT
	.DATA .ENABLE GLOBAL
	.IFT $COMP .DATA .SETT $COMP
	.IFT $TASK .DATA .SETT $TASK
	.IFT $TITS .DATA .SETT $TITS
	.DATA .CHAIN [100,6]LTH
	.CLOSE
.; submit it & exit
	BAT [100,6]LTH.BAT
	BAT /LI
	/
.;
.; do the work
.100:	SET /UIC=[100,5]
	.IFF $COMP .GOTO 200
	ADC LTH = [100,6]LTH
	F4P LTH,LTH/-SP = LTH
	PIP LTH.FTN;/DE
.;
.200:	.IFF $TASK .GOTO 300
	.OPEN [100,6]LTH.TKB
	.DATA [100,1]LTH,[100,1]LTH/-SP=[100,5]LTH
	.IFT $TITS .DATA [1,1]TITS/DA
.ENABLE DATA
[1,1]LIOLIB/LB
[1,1]F4PLIB/DL
/
UNITS = 2
ACTFIL = 1
TASK = LTH...
//
.DISABLE DATA
	.CLOSE
	TKB @[100,6]LTH.TKB
	LMP [100,1]LTH.MAP
	.IFINS LTH... REM LTH...
	.IFNINS LTH... INS [100,1]LTH
.;
.300:	PIP [100,1]LTH.*,[100,5]LTH.*,[100,6]LTH.*/PU
	TIME
	SET /UIC=[100,6]
