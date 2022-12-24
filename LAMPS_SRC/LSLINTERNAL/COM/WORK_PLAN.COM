$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-03-25 18:52:22.000000000 +0000
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
$! WORK_PLAN.COM - procedure to handle planning files
$!
$! Created	(after PUBLISH.COM)			PGH	27-Apr-1991
$!
$	on control_C then goto emergency
$	on error then goto emergency
$	on warning then goto emergency
$	ws="write sys$output"
$	set term/width=132
$!
$! get a command
$!
$Panic:
$	ws "Work planning procedure V1.2"
$	ws "Try HELP if needed."
$ question:
$	gosub get_latest_plan
$       read/end=exit/prompt="PLAN> " sys$command P1
$	p1=f$edit(p1,"upcase,collapse")
$       if p1 .eqs."" then goto panic
$	clen=f$length(p1)
$       if p1.eqs.f$extract(0,clen,"NEW") then goto new
$       if p1.eqs.f$extract(0,clen,"EDIT") then goto edit
$       if p1.eqs.f$extract(0,clen,"PRINT") then goto print
$       if p1.eqs.f$extract(0,clen,"TYPE") then goto type
$       if p1.eqs.f$extract(0,clen,"DIRECTORY") then goto directory
$       if p1.eqs.f$extract(0,clen,"DELETE") then goto delete
$	if p1.eqs.f$extract(0,clen,"HELP") then goto help
$	if p1.eqs."?" then goto help
$	ws "%PLAN-W-UNKNCMD, unknown command"
$	ws "\''p1'\"
$	goto question
$!
$! ************************************************************************
$!
$! here to edit current PLAN.
$!
$EDIT:
$	ws "Edit current plan."
$	define/user sys$input sys$command:
$	ced 'current_plan'
$	purge/keep=2 'current_plan'
$	goto question
$!
$! ************************************************************************
$! here to type out current PLAN.
$!
$TYPE:
$	ws "Type current plan."
$	type/page 'current_plan'
$	goto question
$!
$! ************************************************************************
$!
$! here to print current PLAN.
$!
$PRINT:
$	ws "Print current plan."
$	PRINT/QUEUE=ANSI_L$LSLLPA/PARAM=(SIDE=2)/NOTIFY 'current_plan'
$	goto question
$!
$! ************************************************************************
$!
$! here to delete current PLAN.
$!
$DELETE:
$	ws "Delete current plan - ",latest_plan
$	read/end=question/prompt="Are you sure ?  " sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if yes then delete/noconfirm/log 'latest_plan'
$	goto question
$!
$! ************************************************************************
$!
$! here to create a new PLAN, based on previous one
$!
$NEW:
$	ws "Create new plan."
$	date=f$cvtime("TODAY")
$	date=f$element(0," ",date)
$	new_plan=team+"-"+date+".PLAN"
$	ws "New plan name is ",new_plan
$	copy/log 'latest_plan' 'new_plan'
$	edit/edt 'new_plan'/command=sys$input:
set quiet
set nosummary
CHANGE ;EL BACK W -C ADV D+C DEW DATE BACK W ADV DEW EX
exit
$	goto question
$!
$! ************************************************************************
$!
$! here to produce a list of plans
$!
$DIRECTORY:
$	DIR *.PLAN
$	goto question
$!
$! ************************************************************************
$!
$! here to give help
$!
$help:
$	type sys$input

This command procedure handles software planning files.

Commands may be abbreviated, and currently available are:

HELP or ?	Type this message.
NEW		Start a new planning file, based on previous one.
EDIT		Edit the latest planning file.
PRINT		Print the latest planning file on the LN03 printer.
TYPE		Type out the latest planning file.
DELETE		Delete the latest planning file.
DIRECTORY	List available planning files.

$	goto question
$!
$! ************************************************************************
$! subroutines
$!
$get_latest_plan:
$	latest_plan=""
$	team="****"
$get_next_plan:
$	next_plan=f$search("*-%%%%-%%-%%.PLAN;0")
$	if next_plan.eqs."" then goto no_more_plans
$	latest_plan=next_plan
$	next_team=f$element(0,"-",latest_plan)
$	old_team=team
$	team=next_team
$	if old_team.eqs."****" then goto get_next_plan
$	if next_team.nes.old_team then goto mixed_plans_found
$	goto get_next_plan
$no_more_plans:
$	if latest_plan.eqs."" then goto no_plans_found
$	latest_plan=f$element(1,"]",latest_plan)
$	if latest_plan.eqs."" then goto no_plans_found
$	current_plan=f$element(0,";",latest_plan)
$	team=f$element(0,"-",latest_plan)
$	ws " "
$	ws "Latest plan for team ",team," is ",latest_plan
$	ws " "
$	return
$!
$! ************************************************************************
$!
$! here for errors
$!
$no_plans_found:
$	  WS "%PLAN-W-NOPLAN. No plans found in current directory."
$	  goto emergency
$!
$mixed_plans_found:
$	  WS "%PLAN-W-MIXEDPLAN. Mixed plans (for more than one team) found in current directory."
$	  goto emergency
$!
$!
$! ************************************************************************
$!
$! here for abnormal exits
$!
$emergency:
$	WS "%PLAN-W-ABORT. PLAN procedure terminated abnormally"
$	WS "%PLAN-I-WAIT, waiting 10 seconds for you to read messages.
$	wait 00:00:10
$!
$! ************************************************************************
$!
$! all done
$!
$exit:
$	set noverify
$	set term/width=80
$	exit
