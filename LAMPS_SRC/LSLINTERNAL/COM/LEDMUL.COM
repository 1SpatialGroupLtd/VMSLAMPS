$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-08-12 12:17:58.000000000 +0100
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
$	ver:='f$verify(0)'
$! (termporary) command file to run MUL to the LED printer on LTA500:
$	if .not.f$getdvi("lta500:","spl") then write sys$output -
		"*** LED line appears not to be spooled just now"
$	if p1.eqs."" then inquire p1 "File"
$	if p1.eqs."" then exit
$	form="*"
$check_form: p2=f$extract(0,1,f$edit(p2,"LOWERCASE,TRIM"))
$	if p2.eqs."" then goto ask_for_form
$	if p2.eqs."p" then form=""
$	if p2.eqs."l" then form="l"
$	if form.nes."*" then goto got_form
$ask_for_form: inquire/nopunc p2 " What format (portrait or landscape) ? "
$	goto check_form
$!
$got_form: output_file=f$parse("sys$scratch:.mul_output",p1)
$	output_file=f$extract(0,f$locate(";",output_file),-
				f$edit(output_file,"LOWERCASE"))
$!	ss output_file
$	width=80
$	if form.nes."" then width=132
$	mul 'p1'/w'width'/o'output_file'
$	define/user	sys$output	nl:
$	print/queue=led'form'_print	'output_file'/delete
$	if ver then set verify
