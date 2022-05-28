$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-08-04 11:18:26.000000000 +0100
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
$	verifying = f$verify(0)
$	on error     then goto end_badly_asynch
$	on control_y then goto end_badly_asynch
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1987
$! Author TJ Ibbs, 22 July 1987
$!
$! This is a transition version of the old NEWMESSAGE command file,
$! used to create message parameter files. The old version (written
$! by TJ Hartnall, in November 1985) did a lot more in DCL. Now that
$! the NEWMSG program is more sophisticated, this command file only
$! has to tell the user what they SHOULD have done (instead of using
$! this), and then do it for them.
$!
$! *************************************************************************
$! @NEWMESSAGE  <infile> <facname> <facnum> <facpre> <log> <what>
$!
$! <infile>  - input message definition file
$! <facname> - the name of the facility
$! <facnum>  - the number of the facility (obtained from System Manager)
$! <facpre>  - the prefix to be used in messages for the facility.
$!             This is generally formed as <facname>__
$! <log>     - Y or N for whether to reflect names and texts
$! <what>    - some combination of F,M and C, meaning create Fortran, Macro
$!             and C files. Default is FM (or MF!)
$!
$! - Note that <what> used to be <share>, a Y/N argument that has now been
$!   removed. If <what> is found as Y or N, then assume the default FM
$!
$! In interactive mode, the user is prompted for the above parameters if they
$! do not appear on the command line.
$!
$! In batch mode, the parameters will be read from the input stream if they
$! do not appear on the command line. The last two parameters are optional
$! in this mode, the defaults being N and FM. The procedure will abort if any
$! of the other parameters are missing. 
$!
$! *************************************************************************
$! now for some definitions
$!
$	ws  = "write sys$output"
$	wsb = "write sys$output """""
$!
$! *************************************************************************
$! find out if we are interactive
$!
$	state = f$mode()
$	inter = 0
$	if state .eqs. "INTERACTIVE" then inter = 1
$!
$! *************************************************************************
$!
$! get the message definition filename
$!
$	if p1.eqs."" then inq/nop p1 -
			"What is the name of the message definition file? "
$	if p1.nes."" then goto got_defn_name
$	   ws "%NEWMESSAGE-F-NONAME, no message definition file given"
$	   goto end_badly
$!
$! parse the filename...
$!
$got_defn_name:
$	mesfile = f$parse( p1, "message.mes")
$!			... and determine its component parts
$	fnod =f$parse(mesfile,,,"node")
$       fdev =f$parse(mesfile,,,"device")
$       fdir =f$parse(mesfile,,,"directory")
$       fnam =f$parse(mesfile,,,"name")
$       fext =f$parse(mesfile,,,"type")
$       fver =f$parse(mesfile,,,"version")
$!
$	mesfile = ""
$!
$	t$file = f$parse( "xxx.xxx" )
$	if fnod.nes.f$parse(t$file,,,"node")      then mesfile = mesfile + fnod
$	if fdev.nes.f$parse(t$file,,,"device")    then mesfile = mesfile + fdev
$	if fdir.nes.f$parse(t$file,,,"directory") then mesfile = mesfile + fdir
$	if fnam.nes.f$parse(t$file,,,"name")      then mesfile = mesfile + fnam
$	if fext.nes.f$parse(t$file,,,"type")      then mesfile = mesfile + fext
$!
$! and determine the facility name, number and prefix required by the
$! user
$!
$	facname = p2
$	if facname .nes. "" then goto a20
$	   inq/nop facname "What is the facility name?   (eg LSLLIB) "
$	   if facname .nes. "" then goto a20
$	      ws "%NEWMESSAGE-F-NOFACNAME, facility name has not been given"
$	      goto end_badly
$!
$a20:	facnum = p3
$	if facnum .nes. "" then goto a30
$	   inq/nop facnum  "What is the facility number? (eg 1)      "
$	   if facnum .nes. "" then goto a30
$	      ws "%NEWMESSAGE-F-NOFACNUM, facility number has not been given"
$	      goto end_badly
$!
$a30:	facpre = p4
$	if facpre .nes. "" then goto got_fac
$	   inq/nop facpre  "What is the facility prefix? (eg LSL__)  "
$	   if facpre .nes. "" then goto got_fac
$	      ws "%NEWMESSAGE-F-NOFACPREFIX, facility prefix has not been given"
$	      goto end_badly
$!
$got_fac:
$!
$! are we interested in more debug info?
$!
$	log1 = p5
$	if log1 .nes. "" then goto got_deb
$	   if inter then -
	   inq/nop log1 "Do you want the message names and texts reflecting? "
$	   if log1 .eqs. "" then log1 = "NO"
$!
$got_deb:
$!
$! What are we preparing parameter files for?
$! - P6 used to be <share>, which was a Yes/No parameter. Thus if we find
$!   Yes or No then we treat it as FM (the default)
$!
$	code := 'p6
$	if code.nes."Y" .and. code.nes."YE" .and. code.nes."YES" .and. -
	   code.nes."N" .and. code.nes."NO" .and. code.nes."" -
		then goto got_code
$!
$	   if code.eqs."" then goto ask_code
$ 	      type sys$input:

The <share> argument to NEWMESSAGE has been removed. LSLLIB no longer
attempts to use the SET MESSAGE facility, as it is not possible to add
user defined messages alongside the system message tables. Thus the
.GENMSG* files are no longer produced.

Instead, the <what> argument occupies this position in the NEWMESSAGE
command line, specifying what types of parameter files are wanted, and
defaulting to FM (Fortran and Macro).

$!
$ask_code: if inter then -
	   inq/nop code "Parameter files for what? (F=Fortran,M=Macro,C=C) "
$	   if code.eqs."" then code = "FM"
$!
$got_code:
$!
$! decode the request for parameter files
$!
$	want_F = "N"
$	want_M = "N"
$	want_C = "N"
$!
$	not_there = f$len(code)			! the return if it's absent
$	if f$locate("F",code).ne.not_there then want_F = "Y"
$	if f$locate("M",code).ne.not_there then want_M = "Y"
$	if f$locate("C",code).ne.not_there then want_C = "Y"
$!
$! *************************************************************************
$! and compose the command line for NEWMSG
$!
$	line1 = "NEWMSG ''mesfile' /NUMBER=''facnum'/NAME=''facname'"
$	line1 = line1 + "/PREFIX=''facpre/PARAM=("
$!
$	if want_F then line1 = line1 + "FORTRAN"
$	if want_F .and. (want_M.or.want_C) then line1 = line1 + ","
$	if want_M then line1 = line1 + "MACRO32"
$	if want_M .and.  want_C            then line1 = line1 + ","
$	if want_C then line1 = line1 + "C"
$!
$	line1 = line1 + ")"
$!
$	if log1 then line1 = line1 + "/LOG"
$!
$	line2 = "@''fnam'.TEMP_COM"
$!
$	type sys$input

Rather than using NEWMESSAGE, you should now use the new NEWMSG program.
This is documented in the LSLLIB manual. In order to perform the same
operations as this call of NEWMESSAGE, you need to include the following
two lines in place of whatever you have now:

$!
$	ws "$ " + line1
$	ws "$ " + line2
$!
$	wsb
$	ws "... I will now do that for you"
$	wsb
$!
$	on warning then continue
$	if verifying then set verify
$	'line1'
$	'line2'
$	if verifying then set noverify
$!
$	goto end_normally
$!
$! *************************************************************************
$! we come here if we have an error or control-Y
$!
$end_badly_asynch:
$		ws "%NEWMESSAGE-F-ERREXIT, forced exit due to error"
$end_badly:	ws "-NEWMESSAGE-I-ABORT, command file abandoned"
$		status = %x10000004	! abort (but quietly)
$		goto end_it
$!
$! and we come here for normal completion
$!                                               
$end_normally:
$	status = 1			! normal succesful completion
$!
$! and both routes join up here
$!
$end_it:
$ 	if verifying then set verify
$	exit 'status'
