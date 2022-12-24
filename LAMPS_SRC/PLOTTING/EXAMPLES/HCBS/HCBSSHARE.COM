$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-02-22 14:57:16.000000000 +0000
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
$! command file for linking a shared image of Calcomp HCBS compatible routines
$! this version for BP survey's Versatek (COL2V0)
$!
$	set noon
$	set ver
$	macro HCBSTVEC
$	link/share=HCBSCOL2V0/MAP=HCBSCOL2V0 SYS$INPUT:/OPT
COL2V0/incl=(PLOT,PLOTS,NEWPEN,SYMBOL)/lib
CLUSTER=TRANSFER,,,HCBSTVEC
GSMATCH=LEQUAL,1,0
PSECT_ATTR=BSORT,NOSHR
PSECT_ATTR=CLRCOM,NOSHR
PSECT_ATTR=DVCOM,NOSHR
PSECT_ATTR=IOCOM,NOSHR
PSECT_ATTR=KLCOM,NOSHR
PSECT_ATTR=MSGCOM,NOSHR
PSECT_ATTR=PRMCOM,NOSHR
PSECT_ATTR=STKCOM,NOSHR
PSECT_ATTR=VERSPL,NOSHR
PSECT_ATTR=VRFCOM,NOSHR
$	purge HCBS*.*
$	set nover
