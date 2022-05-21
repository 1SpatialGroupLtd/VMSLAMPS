$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-10-24 13:42:04.000000000 +0000
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
$! LSLIMI_MENU_INI.COM - a command file to set up some menu options for the 
$!			 DEC/British Gas OSTF/NTF to INFORMAP transfer demo
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author R J Hulme, 6 October 1988
$!
$! Modifications
$! ............................................................................
$! 24-Oct-1988	R J Hulme (Laser-Scan Labs)
$! renamed from IMENU_INI.COM
$! ............................................................................
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! values used in managing our input/output
$!
$	IMENU$v_drive           == "MUA0:"	! tape drive name
$	IMENU$v_file		== "TEST"	! file name
$	IMENU$v_is_tape         == "FALSE"	! don't use tape drive
$	IMENU$v_schema          == "DEMO"	! schema name
$!
$! INITIAL value for parameter file
$!
$ 	IMENU$v_params          == "DEMO"	! parameter file
$!
$! and some NTF specific values
$!
$	IMENU$v_ntf_recipient	== "Laser-Scan Labs"	! to whom the data goes
$	IMENU$v_ntf_donor	== "Laser-Scan Labs"	! NTF donor - ourselves
$!
