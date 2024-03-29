$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-11-07 17:01:12.000000000 +0000
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
$!
$!	Move Laserplot/Felib to LSL$SOURCE_ROOT
$	ver:='f$verify(0)'
$	IF P1 .NES. "" THEN GOTO LOGNAMS
$!
$	PAN	==	"$MAC"
$	DPAN	==	"$LSL$EXE:PAN"
$	SLAVE	==	"@LSL$COM:SLAVE"
$	LISTEN	==	"$LSL$EXE:LISTEN"
$	MLO	==	"$LSL$EXE:MLOAD"
$	NUTS	==	"$LSL$EXE:NUTS"
$	TALK	==	"$LSL$EXE:TALK"
$	EGS	==	"@LSL$COM:EGS"
$	NOS	==	"@LSL$COM:NOS"
$	CROM	==	"$LSL$EXE:CROM"
$	CROM2	==	"$LSL$EXE:CROM2"
$	FROM	==	"$LSL$EXE:FROM"
$	FROM1	==	"$LSL$EXE:FROM1"
$	FROM2	==	"$LSL$EXE:FROM2"
$	FUSE	==	"@LSL$COM:FUSER"
$	MOD	==	"$LSL$EXE:MOD"
$	HACLOAD	==	"$LSL$EXE:HACLOAD"
$!
$ LOGNAMS:
$	LSLDISK="LSL$SOURCE_ROOT:"
$	if f$logical("lsl$tk").eqs."" then -
		ASSIGN	'F$LOGICAL("TT")'	LSL$TK
$!
$	if f$logical("PN")  .eqs. "" then -
		DEFINE	PN	'LSLDISK'[PAN]
$	if f$logical("PL")  .eqs. "" then -
		DEFINE	PL	'LSLDISK'[PAN.LIB]
$	if f$logical("PB")  .eqs. "" then -
		DEFINE	PB	'LSLDISK'[PAN.BOOT]
$	if f$logical("PH")  .eqs. "" then -
		DEFINE	PH	'LSLDISK'[PAN.HIACC]
$!
$	if f$logical("MF")  .eqs. "" then -
		DEFINE	MF	'LSLDISK'[MLP.FONT]
$	if f$logical("MO")  .eqs.  "" then -
		DEFINE	MO	'LSLDISK'[MLP.OLD]
$	if f$logical("MOBJ")  .eqs.  "" then -
		DEFINE	MOBJ	'LSLDISK'[MLP.OBJECT]
$	if f$logical("MEXE").eqs. "" then -
		DEFINE	MEXE	'LSLDISK'[MLP.EXE]
$!
$	if f$logical("LSL$MEXE").eqs. "" then -
		DEFINE	LSL$MEXE	'F$LOGICAL("MEXE")'
$!
$	if f$logical("MSRC")  .eqs. "" then -
		DEFINE	MSRC	'LSLDISK'[MLP.SOURCE]
$	if f$logical("MSC") .eqs. "" then -
		DEFINE	MSC	'LSLDISK'[MLP.SOURCE.CALCOMP]
$	if f$logical("MSC6").eqs. "" then -
		DEFINE	MSC6	'LSLDISK'[MLP.SOURCE.CALCOMP.906]
$	if f$logical("MSC9").eqs. "" then -
		DEFINE	MSC9	'LSLDISK'[MLP.SOURCE.CALCOMP.960]
$	if f$logical("MSD") .eqs. "" then -
		DEFINE	MSD	'LSLDISK'[MLP.SOURCE.DEVT]
$	if f$logical("MSDB") .eqs. "" then -
		DEFINE	MSDB	'LSLDISK'[MLP.SOURCE.DEVT.BILL]
$	if f$logical("MSDD") .eqs. "" then -
		DEFINE	MSDD	'LSLDISK'[MLP.SOURCE.DEVT.DILL]
$	if f$logical("MSDJ") .eqs. "" then -
		DEFINE	MSDJ	'LSLDISK'[MLP.SOURCE.DEVT.JOHN]
$	if f$logical("MSDL") .eqs. "" then -
		DEFINE	MSDL	'LSLDISK'[MLP.SOURCE.DEVT.LESLEY]
$	if f$logical("MSDA") .eqs. "" then -
		DEFINE	MSDA	'LSLDISK'[MLP.SOURCE.DEVT.ANDY]
$	if f$logical("MSLA") .eqs. "" then -
		DEFINE	MSLA	'LSLDISK'[MLP.SOURCE.LASERPLOT.A6_PLOTTER]
$	if f$logical("MSL") .eqs. "" then -
		DEFINE	MSL	'LSLDISK'[MLP.SOURCE.LASERPLOT]
$	if f$logical("MTST") .eqs. "" then -
		DEFINE	MTST	'LSLDISK'[MLP.TEST]

$!
$!
$	if f$logical("MUART") .eqs. "" then -
		DEFINE	MUART	LSL$SOURCE_ROOT:[MUART]
$	if f$logical("MUWOSP")  .eqs. "" then -
		DEFINE	MUWOSP	LSL$SOURCE_ROOT:[MUART.WOSP]
$	if f$logical("MUWOLF")  .eqs. "" then -
		DEFINE	MUWOLF	LSL$SOURCE_ROOT:[MUART.WOLF]
$	if f$logical("MUO") .eqs. "" then -
		DEFINE  MUO	LSL$SOURCE_ROOT:[MUART.OLD]
$	if f$logical("MUTE")  .eqs. "" then -
		DEFINE  MUTE	LSL$SOURCE_ROOT:[MUART.TEST]
$	if f$logical("MUEXE")  .eqs. "" then -
		DEFINE  MUEXE	LSL$SOURCE_ROOT:[MUART.EXE]
$	if f$logical("MUS")  .eqs. "" then -
		DEFINE	MUS	LSL$SOURCE_ROOT:[MUART.SRC]
$	if f$logical("MUSD") .eqs. "" then -
		DEFINE	MUSD	LSL$SOURCE_ROOT:[MUART.SRC.DEVT]
$	if f$logical("MUSL") .eqs. "" then -
		DEFINE	MUSL	LSL$SOURCE_ROOT:[MUART.SRC.LCD]
$	if f$logical("MUSL2").eqs. "" then -
		DEFINE	MUSL2	LSL$SOURCE_ROOT:[MUART.SRC.LCD.2]
$	if f$logical("MUSL25").eqs. "" then -
		DEFINE	MUSL25	LSL$SOURCE_ROOT:[MUART.SRC.LCD.25]
$	if f$logical("MUSL3").eqs. "" then -
		DEFINE	MUSL3	LSL$SOURCE_ROOT:[MUART.SRC.LCD.3]
$	if f$logical("MUSL31").eqs. "" then -
		DEFINE	MUSL31	LSL$SOURCE_ROOT:[MUART.SRC.LCD.31]
$	if f$logical("MUSL35").eqs. "" then -
		DEFINE	MUSL35	LSL$SOURCE_ROOT:[MUART.SRC.LCD.35]
$	if f$logical("MUSL3C").eqs. "" then -
		DEFINE	MUSL3C LSL$SOURCE_ROOT:[MUART.SRC.LCD.3C]
$	if f$logical("MUSL3S").eqs. "" then -
		DEFINE	MUSL3S	LSL$SOURCE_ROOT:[MUART.SRC.LCD.3S]
$	if f$logical("MUSLD") .eqs. "" then -
		DEFINE	MUSLD	LSL$SOURCE_ROOT:[MUART.SRC.LCD.DEVT]
$!
$	if f$logical("RD")  .eqs. "" then -
		DEFINE	RD	'LSLDISK'[RARDE]
$	if f$logical("RS")  .eqs. "" then -
		DEFINE	RS	'LSLDISK'[RARDE.SOURCE]
$	if f$logical("RO")  .eqs. "" then -
		DEFINE	RO	'LSLDISK'[RARDE.OBJECT]
$	if f$logical("RSS") .eqs. "" then -
		DEFINE	RSS	'LSLDISK'[RARDE.SOURCE.STEP]
$!
$	if f$logical("FE")  .eqs. "" then -
		DEFINE	FE	LSL$SOURCE_ROOT:[LASERPLOT.FELIB]
$	if f$logical("FS")  .eqs. "" then -
		DEFINE	FS	LSL$SOURCE_ROOT:[LASERPLOT.FELIB.SRC]
$	if f$logical("FC")  .eqs. "" then -
		DEFINE	FC	LSL$SOURCE_ROOT:[LASERPLOT.FELIB.SRC]
$	if f$logical("FM")  .eqs. "" then -
		DEFINE	FM	LSL$SOURCE_ROOT:[LASERPLOT.FELIB.MPLIB]
$	if f$logical("FR")  .eqs. "" then -
		DEFINE	FR	LSL$SOURCE_ROOT:[LASERPLOT.FELIB.RPLIB]
$	if f$logical("FD")  .eqs. "" then -
		DEFINE	FD	LSL$SOURCE_ROOT:[LASERPLOT.FELIB.DGLIB]
$	if f$logical("FL")  .eqs. "" then -
		DEFINE	FL	LSL$SOURCE_ROOT:[LASERPLOT.FELIB.LPLIB]
$	if f$logical("FU")  .eqs. "" then -
		DEFINE	FU	LSL$SOURCE_ROOT:[LASERPLOT.UTIL]
$!
$	if f$logical("AD")  .eqs. "" then -
		DEFINE	AD	'LSLDISK'[ACTP.DAX]
$	if f$logical("AMA") .eqs. "" then -
		DEFINE	AMA	'LSLDISK'[ACTP.MICROA]
$	if f$logical("AMB") .eqs. "" then -
		DEFINE	AMB	'LSLDISK'[ACTP.MICROB]
$	if f$logical("AMS") .eqs. "" then -
		DEFINE	AMS	'LSLDISK'[ACTP.SHRMEM]
$	if f$logical("AH")  .eqs. "" then -
		DEFINE	AH	'LSLDISK'[ACTP.HOST]
$	if f$logical("ASQ") .eqs. "" then -
		DEFINE	ASQ	'LSLDISK'[ACTP.SQUASHED]
$!
$	if ver then set verify
