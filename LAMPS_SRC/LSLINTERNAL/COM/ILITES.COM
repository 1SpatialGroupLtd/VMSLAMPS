$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-02-14 16:36:40.000000000 +0000
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
$! command file for setting up things so that we can generate
$! a converged LITES version
$!
$! We expect P1 to be either C (colour), H (HRD ie SOL), or absent
$!
$ set noon
$ if P1.eqs."" .or. P1.eqs."C" .or. P1.eqs."H" then goto GOTP1
$ write sys$output "Unknown option ",P1
$ write sys$output "Options are C for Colour or H for HRD/FASTRAK/LASERTRAK"
$ exit
$!
$GOTP1:
$ VERS = ""
$ if P1.eqs."C" then VERS = "Colour "
$ if P1.eqs."H" then VERS = "HRD "
$ write sys$output "***   Version is converged ",VERS,"LITES"
$!
$! sort out which disk we're on
$!
$ DISC = f$logical("DEVT$DISK")-"_"-"_"
$ if DISC .eqs. "" then DISC = f$logical("LSL$DISK")
$!
$ ASSIGN 'DISC'<LITES.COM> COM
$ ASSIGN 'DISC'<LITES.SRC> SRC
$ ASSIGN 'DISC'<LITES.CMN> CMN
$ ASSIGN 'DISC'<LITES.MAR> MAR
$ ASSIGN 'DISC'<LITES.'P1'OBJ> OBJ
$ ASSIGN 'DISC'<LITES.'P1'EXE> EXE
$ ASSIGN 'DISC'<LITES.COM> LISTQ
$!
$ XXX := 'SOLINI'
$ IF XXX.NES."" THEN SOLINI
$!
$ TLITES  == "@COM:TLITES"	! to generate truth files
$ MLITES  == "@COM:MLITES"	! to MAKE the command file
$ LITESNV == "@COM:LITESNV"	! to edit a file
$ SEARCHEDT == "@COM:SEARCHEDT"	! search then edit files
