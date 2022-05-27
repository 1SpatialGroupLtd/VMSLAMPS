$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-10 15:44:12.000000000 +0100
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
$! VEST_SETUP.COM - procedure to setup environment to VEST LSL programs.$! Called from specific package procedures, such as LSLSYSTEM_VEST.COM.$! if P1 contains D then diagnostics are set on$! if P1 contains C then code listing is set on$! if P1 contains F then flowgraph is set on$!-----------------------------------------------------------------------$	set noon$	vest_program=="@LSL$COM:VEST_PROGRAM"$	lsl_vest_code==""$	lsl_vest_diag==""$	lsl_vest_errf==""$	lsl_vest_flow==""$	lsl_vest_perf==""$	if p1.eqs."" then goto exit$	if f$locate("C",p1).lt.f$len(p1) then lsl_vest_code=="Y"$	if f$locate("D",p1).lt.f$len(p1) then lsl_vest_diag=="Y"$	if f$locate("E",p1).lt.f$len(p1) then lsl_vest_errf=="Y"$	if f$locate("F",p1).lt.f$len(p1) then lsl_vest_flow=="Y"$	if f$locate("P",p1).lt.f$len(p1) then lsl_vest_perf=="Y"$!-----------------------------------------------------------------------$exit:	exit