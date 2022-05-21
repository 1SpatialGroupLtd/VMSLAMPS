;
; * This file is part of the LAMPS distribution, released as a software
; * preservation project to archive digital history for future historians.
; * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
; *
; * Timestamp of this file for the 2002 release was: 1980-02-21 11:55:50.000000000 +0000
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
.ASK HELP HELP
.IFF HELP .GOTO 50
; LAX (the laseraid exerciser) uses modules from laseraid
; these can be produced by saying @LA & answering YES to the
; following questions:
;	MAIN
;	* IO
;	* * MACIO
;	* * COMMS
;	FAX
;	
.50:.SETF GROW
.SETF GR99
.SETF ACTP
.IFNDF ACTP .ASK ACTP ACTP
.ASK MAIN MAIN
.IFT ACTP .ASK GROW GROW(11) ETC.
.IFT ACTP .ASK GR99 GROW(9900)
.ASK TKB TKB
.SETF TITS
.SETF NUTS
.IFT TKB .ASK TITS * TITS
.IFT TKB .IFF TITS .IFT ACTP .ASK NUTS * NUTS
.SETF T
.SETS SCRTS "SCRTS"
.IFT TKB .ASK T * NEW SSG
.IFT T .SETS SCRTS "SCRTSN"
.ASK BATCH BATCH
.IFF BATCH .SETS BAT "@"
.IFT BATCH .SETS BAT "BAT "
.OPEN [100,6]LAX.BAT
.DATA SET /UIC=[100,5]
.DATA .OPEN [100,5]TRUTH.LAX
.IFT ACTP .DATA .DATA ACTP = 1
.IFF ACTP .DATA .DATA ACTP = 0
.DATA .CLOSE
.DATA PIP [100,5]TRUTH.LAX/PU
.IFF MAIN .GOTO 100
.ENABLE DATA
PIP LXMAIN.OBJ;*/DE
ADC LXMAIN=TRUTH.LAX/TR,LINFIT,PEER,[100,6]LXMAIN,SETDIR,CHKINF
F4P LXMAIN = LXMAIN/TR:NAMES
PIP LXMAIN.FTN;*/DE
MAC LAXCOM=[100,5]SOLTB,TRUTH.LAX,[100,6]LAXCOM
PIP LXMAIN.OBJ/AP=LAXCOM.OBJ
PIP LAXCOM.OBJ;*/DE
.DISABLE DATA
.100:.IFF GROW .GOTO 150
.ENABLE DATA
PIP LAXGRO.OBJ;*/DE
ADC LAXGRO=[100,6]GROW.NEW,GROLD,SETCHN,DRWSCN,DRWPTS,DRWCHN,NEBIT
F4P LAXGRO=LAXGRO
PIP LAXGRO.FTN;*/DE
.DISABLE DATA
.150:.IFF GR99 .GOTO 170
.ENABLE DATA
PIP LAX99.OBJ;*,LAXGR9.OBJ;*/DE
MAC LAX99 = [100,6]LAX99
ADC LAXGR9=[100,6]GROW99,NEALL
F4P LAXGR9=LAXGR9
PIP LAXGR9.FTN;*/DE
.DISABLE DATA
.170:.IFF TKB .GOTO 200
.DATA TKB @[100,6]LAX.TKB
.DATA LMP [100,1]LAX.MAP/M
.DATA .IFINS LAX REM LAX
.DATA INS [100,1]LAX
.DATA PIP [100,1]LAX.TSK,[100,1]LAX.MAP/PU
.CLOSE
.OPEN [100,6]LAX.TKB
.ENABLE DATA
[100,1]LAX/FP,[100,1]LAX/-SP=LXMAIN
IO,FAX,FFCOM
[100,22]'SCRTS'
.DISABLE DATA
.IFT ACTP .DATA LAXGRO,LAX99,LAXGR9
.IFT TITS .DATA [1,1]TITS/DA
.IFT NUTS .DATA [1,1]NUTS/DA
.ENABLE DATA
[1,1]MYEXIT
[1,1]LDLIB/LB:CH0E
[1,1]IFF4PLIB/LB
[1,1]LDLIB/LB
[1,1]LSLIB/LB
[1,1]F4PLIB/DL
/
TASK=...LAX
ACTFIL = 0
.DISABLE DATA
.IFF ACTP .DATA UNITS = 5
.IFT ACTP .DATA UNITS = 6
.IFT ACTP .DATA ASG = TT6:1:6
.200:.CLOSE
PIP [100,6]LAX.BAT,LAX.TKB/PU
'BAT'[100,6]LAX.BAT
