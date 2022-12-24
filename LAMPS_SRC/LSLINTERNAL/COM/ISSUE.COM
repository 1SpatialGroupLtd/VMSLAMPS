$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-11 15:33:38.000000000 +0000
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
$! ISSUE.COM - procedure to control issuing of LSL software to customers.
$!
$! It will generate a command file containing BACKUP commands to make up a
$! release tape for a particular customer from the LSL software distribution 
$! trees (usually LSL$ISSUE_ROOT, but may be LSL$LAST_ISSUE_ROOT), 
$! or optionally (BETA command) from LSL$PUBLIC_ROOT.
$! Alternatively source files can be issued from LSL$SOURCE_ROOT.
$!
$! The procedure is driven from the customer list file CUSTOMERS.RNO
$! in LSL$ISSUE:
$!
$! Created					PGH	02-Oct-1986
$! remote network backup added			PGH	31-Dec-1986
$! remote network timeout delay increased	PGH	19-Feb-1987
$! /since made /modify rather than /created	PGH	14-Aug-1987
$! LITES2 user routines name changed		PGH	25-Oct-1987
$! continue on MT allocated, minor tidies	PGH	29-Dec-1987
$! Change to use LSL$ISSUE_ROOT rather than	WJJ	 9-Jun-1988
$!   LSL$PUBLIC_ROOT
$! Source issue added, special issue removed    SMG      3-Aug-1988
$!   and issue of individual programs added
$! Use of MUB1:, tidies to SMG's changes	PGH	 8-Aug-1988
$! VTRAK has options like LITES2's		 DM	05-Sep-1988
$! VMS V5 BACKUP doesnt like /NOLIST		PGH	03-Oct-1988
$! PLOTTING needs FPPSHR and sometimes HCBSSHR	PGH/CCB	28-Nov-1988
$! don't fall over if magtape owned by SYSTEM	PGH	17-Feb-1989
$! faster, skip lines with 1 space character 	PGH	07-Mar-1989
$! VMS V5 BACKUP needs /IGNORE=LABEL)		PGH	31-May-1989
$! allow customer info with part issue		PGH	06-Jun-1989
$! automatically add LITES2GEOGSHR		PGH	16-Aug-1989
$! Allow pVAX SCSI magtapes MKA500:		PGH	16-Oct-1989
$! Automatically add licence for SCANCONVERT	PGH	13-Sep-1990
$! Improve journal and listing handling		PGH	15-Sep-1991 (V3.0)
$! remember BACKUP errors			PGH	17-Sep-1991 (V3.0)
$! keep listing file				PGH	23-Sep-1991 (V3.1)
$! translate BACKUP errors using SYSMGTMSG 	PGH	16-Oct-1991 (V3.2)
$! don't fall over if no errors found		PGH	 6-Nov-1991 (V3.3)
$! Part issues now driven by package list       PGH	25-Nov-1991 (V3.4)
$! Use * not *.* in BACKUP listing search	PGH	 9-Dec-1991 (V3.5)
$! Avoid formfeeds in listings			PGH	19-May-1992 (V3.6)
$! Cope with LSL$XGIS_SOURCE_ROOT		PGH	19-May-1992 (V3.6)
$! Always delete errors list			PGH	19-May-1992 (V3.6)
$! Add components for XGIS (RDB,ORACLE,etc)	PGH	20-May-1992 (V3.6)
$! ... but not Horizon executables		PGH	22-May-1992 (V3.7)
$! Allow specify from_root (for demo issues)	PGH	 6-Aug-1992 (V3.8)
$! Find MSCP-served tapes			PGH	 1-Dec-1992 (V3.9)
$! Support LSL$LAST_ISSUE_ROOT			PGH	 9-Mar-1993 (V4.0)
$! Support Alpha AXP issues (first try)		PGH	22-Jun-1993 (V4.1)
$! Allow longer lines in control file		PGH	19-Aug-1993 (V4.2)
$! Add LCMSQUASH to LITES2 list			PGH	29-Sep-1993 (V4.3)
$! Record Generation and Execution dates	PGH	18-Jan-1994 (V4.4)
$! Check for ) in package name as common typo	PGH	21-Jan-1994 (V4.5)
$! Avoid +AXP in computer name when defaulting	PGH	15-Mar-1994 (V4.6)
$! Don't include user routines for LITES2	PGH	16-Mar-1994 (V4.6)	
$! AXP roots merged into public and issue roots	PGH	11-Nov-1994 (V4.7)
$! 
$	on control_C then goto emergency
$	on error then goto emergency
$	on warning then goto emergency
$	ws="write sys$output"
$	command_open=0
$	record_open=0
$	customer_open=0
$	date_open=0
$	device_open=0
$	record_file="LSL$ISSUE:PUBLIC.RECORD"
$	sour=""
$	is_axp_issue=0
$	
$!
$! Determine name of user etc
$!
$       username=f$edit(f$getjpi("","username"),"collapse")
$!
$! get a command
$!
$Panic:
$       type sys$input
LSL software issue procedure V4.7. Try HELP if needed.
$ question:
$	if command_open then close command_file
$	command_open=0
$	if record_open then close record_file
$	record_open=0
$	if customer_open then close customer_list
$	customer_open=0
$	if device_open then close device_list
$	device_open=0
$       read/end=exit/prompt="ISSUE> " sys$command P1
$	p1=f$edit(p1,"upcase,collapse")
$       if p1 .eqs."" then goto panic
$	clen=f$length(p1)
$	do_beta=0
$	was_beta=0
$	do_customers=0
$	do_help=0
$	do_last=0
$	do_issue=0
$	do_journal=0
$	do_packages=0
$	do_record=0
$	do_sources=0
$	do_who=0
$	only_components=0
$ 	selection=""
$	package_list=""
$	last_package=""
$	part_issue=0
$	if p1.eqs."?" then goto help
$       if p1.eqs.f$extract(0,clen,"BETA") then goto beta
$	if p1.eqs.f$extract(0,clen,"CUSTOMERS") then goto customers
$       if p1.eqs.f$extract(0,clen,"EXIT") then goto exit
$	if p1.eqs.f$extract(0,clen,"HELP") then goto help
$       if p1.eqs.f$extract(0,clen,"ISSUE") then goto issue
$	if p1.eqs.f$extract(0,clen,"JOURNAL") then goto journal
$       if p1.eqs.f$extract(0,clen,"LAST") then goto last
$       if p1.eqs.f$extract(0,clen,"PACKAGES") then goto packages
$       if p1.eqs.f$extract(0,clen,"QUIT") then goto exit
$       if p1.eqs.f$extract(0,clen,"RECORD") then goto record
$       if p1.eqs.f$extract(0,clen,"SOURCES") then goto sources
$       if p1.eqs.f$extract(0,clen,"WHO") then goto who
$	ws "%ISSUE-W-UNKNCMD, unknown command"
$	ws "\''p1'\"
$	goto question
$!
$! ************************************************************************
$!
$! here to give help
$!
$help:
$	type sys$input

This command procedure automates the issuing of LSL software to VMS customers.
It is driven by a master list of customers and packages held in the file
LSL$ISSUE:CUSTOMERS.RNO.

Commands may be abbreviated, and currently available are:

HELP or ?	Type this message.
ISSUE		Create command file to make a software issue to a customer.
BETA		As for ISSUE above, but for a "beta test" site.
LAST		As for ISSUE above, but old software from LSL$LAST_ISSUE_ROOT.
JOURNAL		Type or print the backup journal for a customer.
SOURCES         Create command file to make an issue of sources to a customer.
PACKAGES	Query what packages a particular customer has.
CUSTOMERS	Type a list of customers and their computers.
RECORD		Record an event which is not an orthodox issue.
WHO		Query which customers have a particular software package.

The ISSUE, BETA, LAST, SOURCES, PACKAGES, and JOURNAL commands will prompt for
a customer name and computer, which can be abbreviated. Typing ? will give a
list of known ones. Hit RETURN to the computer prompt if you want the first or
only computer for this particular customer. 

The ISSUE, BETA, LAST and SOURCES commands will ask a series of hopefully
self-explanatory questions about the backup destination and options. 

$	goto question
$!
$! ************************************************************************
$!
$! here to produce a list of customers
$!
$customers:
$	do_customers=1
$	ws "Query of customer list."
$	ws " "
$	customer="?"
$	goto skip_customer
$!
$! ************************************************************************
$!
$! here to query the journal for a customer
$!
$journal:
$	do_journal=1
$	ws "Query of journal for customer."
$	ws " "
$	goto get_customer
$!
$! back here with customer and computer
$!
$list_journal:
$       read/end=question/prompt="Previous issue [default N for current issue] ? " -
		sys$command yes
$	if yes then journal_file=history_file
$	if f$search(journal_file).eqs."" then goto no_such_journal
$       read/end=question/prompt="Output to printer [default N for terminal] ? " -
		sys$command yes
$	if yes
$	then
$	   backup/LIST='listing_file'/JOUR='journal_file'
$	   LPSP/NOTIFY/PARAM=(NUMBER=4,SIDES=2)/DELETE/NOFEED 'listing_file'
$	else
$	   backup/LIST/JOUR='journal_file'
$	endif
$	goto question
$!
$no_such_journal:
$	ws "%ISSUE-W-NOJOURNAL, journal file ",journal_file," not found."
$	goto question
$!
$! ************************************************************************
$!
$! here to query what packages a customer has
$!
$Packages:
$	do_packages=1
$	ws "Query of packages for customer."
$	ws " "
$	goto get_customer
$!
$! ************************************************************************
$!
$! here to create an issue of source files 
$!
$Sources:
$  	do_sources=1
$	do_issue=1
$	ws "Issue of source files for customer."
$	ws " "
$	sour="_SOURCE"
$	goto get_customer
$!
$! ************************************************************************
$!
$! here to create a beta test issue
$!
$Beta:
$  	do_beta=1
$	do_issue=1
$	ws "Issue of software for beta test customer."
$	ws " "
$	goto get_customer
$!
$! ************************************************************************
$!
$! here to create an issue from LSL$LAST_ISSUE_ROOT:
$!
$Last:
$  	do_last=1
$	do_issue=1
$	ws "Issue of old software for customer, from LSL$LAST_ISSUE_ROOT:."
$	ws " "
$	goto get_customer
$!
$! ***********************************************************************
$!
$! here to create a software issue
$! 
$Issue:
$	do_issue=1
$ 	ws "Issue of software for customer."
$	ws " "
$	goto get_customer	
$!
$! ************************************************************************
$!
$! here to say who has a particular package
$!
$Who:
$	do_who=1
$	ws "Query who has particular package."
$	ws " "
$       read/end=exit/prompt="What Package ?  " -
		sys$command package
$	package=f$edit(package,"upcase,collapse")
$	if package.eqs."" then goto question
$	Search/log LSL$ISSUE:CUSTOMERS.RNO 'package'
$	goto question
$!
$! ************************************************************************
$!
$! here to record an unorthodox event
$!
$Record:
$	do_record=1
$	ws "Record an unorthodox event"
$	ws " "
$	goto get_customer
$! return here with customer name etc
$record_something:
$	time=f$time()
$	issue_text="Event record for "+customer+"("+computer+") by "+username+-
		" at "+time
$       read/end=question/prompt="What event ?  " -
		sys$command event
$	if event.eqs."" then goto question
$       read/end=question/prompt="Reason for event ?  " -
		sys$command reason
$	reason=f$edit(reason,"trim")
$	if reason.eqs."" then goto question
$! actually do the record
$	if f$search(record_file).eqs."" then create 'record_file'
$	open/append record_file 'record_file'
$	record_open=1
$	wr="WRITE RECORD_FILE"
$	wr ""
$	wr issue_text
$	wr "Event:    ",event
$	wr "Reason:   ",reason
$	close record_file
$	record_open=0
$	goto question
$!
$! ************************************************************************
$!
$! various commands join here to get customer details.
$!
$get_customer:
$       read/end=question/prompt="Customer name ?  " sys$command customer
$	customer=f$edit(customer,"upcase,collapse")
$	if customer.eqs."" then goto question
$skip_customer:
$	cust_len=f$length(customer)
$	computer="*QUERY*"
$	last_computer="*UNSET*"
$	last_customer="*UNSET*"
$	if customer.eqs."?" then goto skip_computer
$       read/end=question/prompt="Computer name [default is first for this customer] ?  "-
		sys$command computer
$	computer=f$edit(computer,"upcase,collapse")
$	if computer.eqs."?" then goto skip_computer
$	goto got_computer
$skip_computer:
$! here to query possible customers or computers
$	do_issue=0
$	computer="?"
$got_computer:
$	comp_len=f$length(computer)
$!
$! ************************************************************************
$!
$! find if customer name is valid
$!
$read_customers:
$	open/read customer_list LSL$ISSUE:CUSTOMERS.RNO
$	customer_open = 1
$	ws "Now searching customer list."
$next_line:
$	read/end=no_more customer_list line
$	if f$extract(0,1,line).nes." " then goto next_line
$	line=f$edit(line,"compress,trim,upcase")
$	if line.eqs."" then goto next_line
$	this_customer=f$edit(f$element(0," ",line),"trim")
$	if customer.eqs."?" then goto all_cust
$	if customer.nes.f$extract(0,cust_len,this_customer) then goto next_line
$	customer=this_customer
$	cust_len=f$length(customer)
$!
$! ************************************************************************
$!
$! here with right customer, check on computer
$!
$all_cust:
$	this_computer=f$edit(f$element(1," ",line),"trim")
$	if computer.eqs.""
$	then
$	   computer=this_computer-"+AXP"
$	   comp_len=f$length(computer)
$	endif
$	if computer.nes.f$extract(0,comp_len,this_computer) then goto not_comp
$	computer=this_computer
$	comp_len=f$length(computer)
$not_comp:
$	if this_computer.nes.last_computer.or.this_customer.nes.last_customer -
	then ws "Customer ",this_customer," has computer ",this_computer
$	last_computer=this_computer
$	last_customer=this_customer
$	if this_computer.nes.computer then goto next_line
$	goto got_cust
$!
$! ************************************************************************
$!
$! here at end of customer list - was it expected ?
$!
$no_more:
$	if customer.eqs."?".or.computer.eqs."?" then goto query_ok
$	ws "%ISSUE-W-NOTFND, customer ",customer,"(",computer,")"," not found in the list"
$query_ok:
$	close customer_list
$	customer_open = 0
$	goto question
$!
$! ************************************************************************
$!
$! here with a possible customer and computer
$!
$got_cust:
$	if customer.eqs."?" then goto done2		! query customer
$	if computer.eqs."?" then goto done2		! query computer
$	if do_record then goto done2			! record an event
$	if do_packages then goto process_line		! query packages
$	if f$locate("+AXP",computer).lt.comp_len
$	then
$ 	   ws "... Alpha AXP support is selected"
$	   is_axp_issue=1
$	   computer=computer-"+AXP"
$	   comp_len=f$length(computer)
$	endif
$	history_file="LSL$RELEASES:REL_"+customer+"_"+computer+sour+"_PREV.BJL"
$	journal_file="LSL$RELEASES:REL_"+customer+"_"+computer+sour+"_LAST.BJL"
$	listing_file="LSL$RELEASES:REL_"+customer+"_"+computer+sour+"_LAST.LIS"
$	error_file="LSL$RELEASES:REL_"+customer+"_"+computer+sour+"_ERROR.LIS"
$	journalsw="/JOURNAL="+journal_file
$	if do_journal then goto list_journal		! query journal
$	if .not.do_issue then goto done2
$	ws " "
$	ws "BACKUP journal will be to ",journal_file
$	sincesw=""
$	something_done=0
$!
$! ************************************************************************
$!
$! here with a valid customer and computer - read dates from date file
$!
$	date_file="LSL$RELEASES:REL_"+customer+"_"+computer+".DATE"
$	unset_date="17-NOV-1858 00:00:00.00"
$	full_exe_update==unset_date
$	incr_exe_update==unset_date
$	part_exe_update==unset_date
$	full_source_update==unset_date
$	incr_source_update==unset_date
$	part_source_update==unset_date
$	axp_status==unset_date
$	beta_status==unset_date
$	if f$search(date_file) .nes. "" then @'date_file'
$	if do_sources then goto dates_sources
$dates_issue:
$	if do_last
$	then
$	   from_root="LSL$LAST_ISSUE_ROOT:"
$	else
$	   from_root="LSL$ISSUE_ROOT:"
$	endif
$	full_date=full_exe_update
$	incr_date=incr_exe_update
$	part_date=part_exe_update
$	goto check_beta
$dates_sources:
$	from_root="LSL$SOURCE_ROOT:"
$	full_date=full_source_update
$	incr_date=incr_source_update
$	part_date=part_source_update
$	goto check_AXP_status
$check_beta:
$	was_beta=1
$	if beta_status.eqs.unset_date then was_beta=0
$	if beta_status.eqs."" then was_beta=0
$	if .not.do_beta then goto not_beta
$	from_root="LSL$PUBLIC_ROOT:"
$	if was_beta then goto check_AXP_status
$	ws " "
$	ws "%ISSUE-W-NOBETA, Site was not Beta Test before."
$	ws "%ISSUE-W-HINT, extra care must be taken with future updates"
$	ws " "
$       read/end=done2/prompt="Continue with issue [RETURN to abort] ?  " -
		sys$command yes
$	if .not.yes then goto done2
$	goto check_AXP_status
$not_beta:
$	if .not.was_beta then goto check_AXP_status
$	ws " "
$	ws "%ISSUE-W-BETA, Site had Beta Test update on ",beta_status
$	ws "%ISSUE-W-HINT, This issue may overwrite later software"
$	ws " "
$       read/end=done2/prompt="Continue with issue [RETURN to abort] ?  " -
		sys$command yes
$	if .not.yes then goto done2
$!
$! ************************************************************************
$!
$check_AXP_status:
$	was_axp=1
$	if axp_status.eqs.unset_date then was_axp=0
$	if axp_status.eqs."" then was_axp=0
$	if .not.is_axp_issue then goto not_axp
$	if was_axp then goto type_of_issue
$	ws " "
$	ws "%ISSUE-W-NOAXP, Site was not Alpha AXP before."
$	ws "%ISSUE-W-HINT, Make sure all necessary files are being sent"
$	ws " "
$       read/end=done2/prompt="Continue with issue [RETURN to abort] ?  " -
		sys$command yes
$	if .not.yes then goto done2
$	goto type_of_issue
$not_axp:
$	if .not.was_axp then goto type_of_issue
$	ws " "
$	ws "%ISSUE-W-AXP, Site had Alpha AXP update on ",AXP_status
$	ws "%ISSUE-W-HINT, This issue may not include necessary AXP files"
$	ws " "
$       read/end=done2/prompt="Continue with issue [RETURN to abort] ?  " -
		sys$command yes
$	if .not.yes then goto done2
$!
$! ************************************************************************
$!
$! here to get type of issue
$!
$type_of_issue:
$	full_issue=1	! assumption
$	package_list=""
$	ws " "
$	ws "A complete issue will send updates for all packages for this customer."
$	ws "A part issue allows you to select particular packages to send."
$       read/end=done2/prompt="Is this a part issue [default N for complete issue] ?  " -
		sys$command part_issue
$	if (.not. part_issue) then goto not_packages
$	ws " "
$	ws "%ISSUE-W-PART, Part issues should always include LSLSYSTEM and MAPPING"
$	ws " "
$	ws "There are now two ways of choosing the packages for a part issue."
$	ws "You can confirm by Y/N each package in the standard list for this customer,"
$	ws "or you can type in package names to override components of the standard list."
$       read/end=done2/prompt="Do you want to type in package names [default N for confirm against list] ?  " -
		sys$command yes
$	if (.not. yes) then goto not_packages
$	ws " "
$       read/end=done2/prompt="Package name [RETURN for all packages] ?  " -
		sys$command package
$	if package .eqs. "" then goto not_packages
$	full_issue=0	! not full
$	goto first_package
$another_package:
$       read/end=done2/prompt="Package name [RETURN if no more] ?  " -
		sys$command package
$first_package:
$	package=f$edit(package,"upcase,collapse")
$	if package.eqs."?" then gosub list_packages
$	if package.eqs."?" then goto another_package
$	if package.eqs."" then goto not_packages
$	pack=from_root+"[000000]"+package+"*.dir"
$	package_file=f$search(pack)
$	if package_file.nes."" then goto package_exists
$	ws "%ISSUE-W-NOPACKAGE, package ",package," not found."
$	goto another_package
$package_exists:
$	package=f$parse(package_file,,,"name")
$	ws "Package is:  ",package
$	package_list=package_list+package+","
$ 	selection=""
$	select_symbol="component_'package'_select"
$	'select_symbol'=""
$	if do_sources then goto first_selection
$       read/end=done2/prompt="Selected component [RETURN for all of package] ?  " -
		sys$command selection
$	goto first_selection
$another_selection:
$       read/end=done2/prompt="Selected component [RETURN if no more] ?  " -
		sys$command selection
$first_selection:
$	selection=f$edit(selection,"upcase,collapse")
$	if selection.eqs."" then goto another_package
$	'select_symbol'='select_symbol'+selection+"/"
$	goto another_selection
$!
$! ************************************************************************
$!
$! rejoin here if not selecting packages (complete issue), and report dates
$!
$not_packages:
$	lastrel=full_date
$	issue_type="a full"
$	if f$cvtime(full_date) .LTS. f$cvtime(incr_date) then lastrel=incr_date
$	if f$cvtime(full_date) .LTS. f$cvtime(incr_date) then issue_type="an incremental"
$	if lastrel .eqs. unset_date then goto noissue
$	if lastrel .eqs. " " then goto noissue
$	ws " "
$	ws "The previous issue of all packages to this customer was ",issue_type," issue;" 
$       ws "	Dated: ",lastrel
$ 	if f$cvtime(part_date) .LES. f$cvtime(lastrel) then goto get_incr
$	ws " "
$	ws "At least one part release has been made since, on ",part_date
$	goto get_incr
$noissue:
$	ws " "
$	ws "%ISSUE-W-NOISSUE, no record of previous issue"
$	lastrel="*NONE*"
$get_incr:
$	ws " "
$	ws "A full issue will send all requested files regardless of date."
$	ws "An incremental issue will only send files modified since a given date."
$	incrementsw=""
$       read/end=done2/prompt="Do you want to do an incremental issue [default N for full issue] ?  " -
		sys$command incr_issue
$	if .not. incr_issue then goto not_increment
$get_date:
$       read/end=done2/prompt="Starting date of increment [default is ''lastrel'] ?  " -
		sys$command date
$	if date.eqs."" then date=lastrel
$	if date.eqs."*NONE*" then goto get_date
$	set noon
$	absdate=""
$	absdate=f$cvtime(date,"ABSOLUTE")
$	set on
$	if absdate.eqs."" then goto get_date
$	sincesw="/MODIF/SINCE="""+absdate+""""
$	ws "Increment is since ",absdate
$	full_issue=0	! not full
$not_increment:
$	package_check=package_list
$	packages_tried=""
$!
$! ************************************************************************
$!
$! now check what sort of backup
$!
$get_dest:
$	ws " "
$	ws "Issue savesets are usually written direct to magtape or cartridge tape."
$	ws " "
$	default_device="*UNKNOWN*"
$	ws "The following magtape devices are available from this CPU (",f$getsyi("NODENAME"),")"
$	Show device M/out=LSL$ISSUE:MAGTAPES.TMP
$	device_open = 0
$	open/read device_list LSL$ISSUE:MAGTAPES.TMP
$	device_open = 1
$	ws " "
$next_device:
$	read/end=no_more_devs device_list dev_line
$	if f$locate(":",dev_line).GE.f$len(dev_line) then goto next_device
$	device=f$edit(f$element(0,":",dev_line),"TRIM")-"_"
$	if f$extract(0,2,device).eqs."MB" then goto next_device
$	devclass=f$getdvi(device,"DEVCLASS")
$	if devclass.ne.2 then goto next_device
$	gosub check_device
$	if devtype.nes."" then default_device=device+":"
$	goto next_device
$no_more_devs:
$	close device_list
$	delete LSL$ISSUE:MAGTAPES.TMP;
$	device_open = 0
$!
$	ws " "
$get_dest2:
$	ws "Answer ? to next question to get more information on possible output devices."
$       read/end=done2/prompt="Where should savesets be written [default is ''default_device'] ?  " -
		sys$command destination
$	destination=f$edit(destination,"upcase,collapse")
$	if destination.eqs."?" then goto help_device
$	if destination.eqs."" then destination=default_device
$	class=0
$	name=f$parse(destination,,,"name","no_conceal")
$	if name.nes."" then goto got_name
$	dest_node=f$parse(destination,,,"node","no_conceal")
$	device=f$parse(destination,"sys$disk:",,"device","no_conceal")
$	if dest_node.nes."" then goto remote_thing
$	if device.eqs."" then goto no_such
$	exists=f$getdvi(device,"exists")
$	if .not.exists then goto no_such
$	class=f$getdvi(device,"devclass")
$	if class.ne.2 then goto not_tape
$	goto tape_device
$help_device:
$	type sys$input:

To get output on half inch magtape, select destination as follows:

Logon to CPU = LSLM3B:: and use ISSUE destination = MUB1: to get TU81+ drive.
Logon to CPU = LSLM3B:: and use ISSUE destination = MUC0: to get Kennedy drive.

To get output on TK50 cartridge, select destination as follows:

Logon to CPU = LSLV3C:: and use ISSUE destination = MUA0: to get TK50 drive.
Logon to CPU = LSLV3F:: and use ISSUE destination = MKA500: to get TK50 drive.

To get output on TK70 cartridge, select destination as follows:
(BEWARE - TK70 cartridges will not read on TK50 drives!)

Logon to CPU = LSLM3B:: and use ISSUE destination = MUA0: to get TK70 drive.

To get output on Exabyte cartridge select destination as follows:

Logon to CPU = LSLM3D:: and use ISSUE destination = MKB500: to get Exabyte drive.
Logon to CPU = LSLM3E:: and use ISSUE destination = MKB500: to get Exabyte drive.

To get output to other device, eg disk file, specify the full device/directory.

$	goto get_dest2
$no_such:
$	ws "%ISSUE-W-NOSUCHDEV, device ",destination," is not available"
$       read/end=done2/prompt="Do you really mean ''device' [default N] ?  " -
		sys$command yes
$	if yes then goto tape_device
$	goto get_dest
$got_name:
$	ws "%ISSUE-W-NOCOLON, destination ",destination," has unexpected filename"
$	ws "%ISSUE-I-HINT, device names must end in colon, filenames not allowed."
$	goto get_dest
$!
$! ************************************************************************
$!
$!
$! here with a tape device - get characteristics.
$!
$tape_device:
$	tape_device=1
$	remote_device=0
$	ws "Device ",destination," assumed to be a tape"
$       read/end=done2/prompt="Add to existing data on tape [default N] ?  " -
		sys$command yes
$	if .not.yes then rewindsw="/REWIND/IGNORE=(LABEL)"
$	if yes then rewindsw="/NOREWIND"
$	if .not.yes then ws "%ISSUE-I-REWIND, previous contents of tape will be overwritten"
$	densitysw=""		! density only set for (TU81+)
$	if class.eq.0 then goto not_tu81
$	devtype=f$getdvi(device,"MEDIA_NAME")
$	if devtype.nes."TU81" then goto not_tu81
$       read/end=done2/prompt="6250BPI Density [default N for 1600BPI] ?  " -
		sys$command yes
$	if yes then densitysw="/DENSITY=6250"
$	if .not.yes then densitysw="/DENSITY=1600"
$not_tu81:
$	goto all_devices
$remote_thing:
$	if device.eqs."" then goto not_tape
$	device=device-"_"
$       devtyp=f$extract(0,2,device)
$       if f$extract(0,2,device).nes."MU" then goto not_tape
$	ws "Device ",destination," assumed remote TK50 cartridge tape."
$	ws "... it will be treated as a network task"
$	tape_device=0
$	remote_device=1
$	goto all_devices
$not_tape:
$	ws "Device ",destination," is not a tape. Assumed file structured."
$	tape_device=0
$	remote_device=0
$!
$! here to get rest of characteristics for all destination devices.
$!
$all_devices:
$	if tape_device
$	then
$	   ws " "
$	   ws "This procedure *always* produces a printed log of the issue."
$	   ws "The default is to do a separate BACKUP pass reading the tape."
$	   ws "If you are in a hurry, it can produce a journal log instead."
$          read/end=done2/prompt="Produce printed log from journal [default N] ?  " -
		sys$command list_from_journal
$	else
$	   list_from_journal="Y"
$	endif
$	ws " "
$	verifysw=""
$	if remote_device then goto endverify
$       read/end=done2/prompt="BACKUP with /VERIFY [default N] ?  " -
		sys$command yes
$	if yes then verifysw="/VERIFY"
$	if .not.yes then verifysw="/NOVERIFY"
$endverify:
$       read/end=done2/prompt="BACKUP with /LOG [default N] ?  " -
		sys$command yes
$	if yes then logsw="/LOG"
$	if .not.yes then logsw="/NOLOG"
$       read/end=done2/prompt="BACKUP with /LIST [default N] ?  " -
		sys$command yes
$	if yes then listsw="/LIST"
$	if .not.yes then listsw=""
$       read/end=done2/prompt="BACKUP with /CONFIRM [default N] ?  " -
		sys$command yes
$	if yes then confsw="/CONFIRM"
$	if .not.yes then confsw=""
$	miscsw=verifysw+logsw+listsw+confsw
$	ws ""
$!
$! ************************************************************************
$!
$! now open the command file and put in any header stuff
$!
$	time=f$time()
$	s=""
$	if do_sources then s=" of sources"
$	if do_beta then s=" from BETA tree"
$	if do_last then s=" from LAST tree"
$	issue_text="Issue"+s+" to "+customer+"("+computer+")"
$	issue_text2="Generated by "+username+" at "+time
$	command_file="LSL$RELEASES:REL_"+customer+"_"+computer+".COM"
$	create 'command_file'	! so that it is standard text file format
$	open/append command_file 'command_file'
$	command_open=1
$	wc="write command_file"
$	wc "$ SAVVER=F$VERIFY(0)"
$	wc "$ SET NOON"
$	wc "$ WS=""WRITE SYS$OUTPUT"""
$	wc "$!"
$	wc "$ WS """""
$	wc "$ WS """,issue_text
$	wc "$ WS """,issue_text2
$	wc "$ username=f$edit(f$getjpi("""",""username""),""collapse"")"
$	wc "$ time=f$time()"
$	wc "$ issue_text3=""Executed  by ""+username+"" at ""+time"
$	wc "$ WS issue_text3"
$	wc "$ WS """""
$	wc "$!"
$	if remote_device then goto mount_remote
$	if .not.tape_device then goto nomount
$	wc "$	MOUNT ",destination,"/FOREIGN"
$	wc "$ IF .NOT.$STATUS THEN GOTO EXIT"
$	wc "$!"
$	goto nomount
$mount_remote:
$	wc "$ WS ""Testing Network Connection"""
$	wc "$ DIR ''dest_node'::SYS$SYSTEM:MU*.COM"
$ 	wc "$ WAIT 0:0:20"
$	wc "$ WS ""Initialising cartridge"""
$	wc "$ TYPE ''dest_node'::""TASK=MUINIT"""
$ 	wc "$ WAIT 0:0:20"
$	wc "$ WS ""Mounting cartridge"""
$	wc "$ TYPE ''dest_node'::""TASK=MUMOUNT"""
$	wc "$!"
$!
$nomount:
$	if f$search(journal_file).nes."" then -
	   wc "$ RENAME ",journal_file," ",history_file,"/LOG"
$	if f$search(history_file).nes."" then -
	   wc "$ PURGE/NOLOG ",history_file
$	wc "$ ERROR_FILE=""''error_file'"""
$	wc "$ IF F$SEARCH(ERROR_FILE).NES."""" THEN -"
$	wc "     DELETE/NOLOG/NOCONFIRM ",error_file,";*"
$	wc "$ WS """""
$	wc "$ SET VERIFY"
$!
$! ************************************************************************
$!
$! now read the package records
$!
$process_line:
$	gosub strip_line
$	element_no=0
$next_package:
$	gosub get_package
$	if package.eqs."" then goto done_line
$!
$! ************************************************************************
$!
$! do we want this package ?
$!
$	if package_list.eqs."" then goto want_this_package
$	want_no=0
$get_wanted_package:
$	want_this=f$element(want_no,",",package_list)
$	want_no = want_no + 1
$	if want_this.eqs."," then want_this=""
$	if want_this.eqs."" then goto next_package
$	if want_this.eqs.package then goto want_this_package
$	goto get_wanted_package
$want_this_package:
$	select_symbol="component_'package'_select"
$	if f$type('select_symbol').nes."" then components='select_symbol'
$	component_message=""
$	if components.nes."" then component_message=", components: "+components
$	if .not.do_sources then goto not_source_package
$	component_message=""
$	xgis_package=0
$	if package.eqs."XGIS" then xgis_package=1
$	if package.eqs."HORIZON" then xgis_package=1
$	if package.eqs."METROPOLIS" then xgis_package=1
$	if package.eqs."MAPPER" then xgis_package=1
$	if package.eqs."OLIGS" then xgis_package=1
$	if f$extract(0,5,package).eqs."$XGIS" then xgis_package=1
$	from_root="LSL$SOURCE_ROOT:"
$	if xgis_package then from_root="LSL$XGIS_SOURCE_ROOT:"
$not_source_package:
$	ws "Processing package ",package
$	if package_list.nes."" then package_check=package_check-package
$	if (.not.part_issue) then goto out_package
$	if package_list.nes."" then goto out_package
$       read/end=done2/prompt="Do you want this package [N] ?  " -
		sys$command yes
$	if .not.yes then goto next_package
$!
$! ************************************************************************
$!
$! here with a package name and its components (if any) to issue if requested
$! if any components then output bulk first, then selected components,
$! unless components selected with "{", in which case only_components.
$!
$out_package:
$	if do_sources then components=""
$	if do_packages then goto next_package	! only telling you
$	if is_AXP_issue		! we want to exclude AXP executables if VAX
$	then
$	   excludesw=""
$	else
$	   excludesw="/EXCLUDE=(*_TV*.*,*_AXP*.*)"
$	endif
$	source=from_root+"["+package+"...]*.*"
$	destname=package
$	packages_tried=packages_tried+package+","
$	same_package=0
$	if package.eqs.last_package then same_package=1
$	last_package=package
$	if components.nes."" then goto complex_package
$! simple package here
$	if same_package then -
	   ws "%ISSUE-W-REPEAT, repeated package ",package
$!!!	ws "... Adding package ",package," files
$	gosub backup_package
$	goto next_package
$complex_package:
$	if only_components then goto components_only
$	if same_package then goto skip_same_package
$	if excludesw.eqs.""
$	then
$	   excludesw="/EXCLUDE=(["+package+".EXE]*.*)"
$	else
$	   excludesw=excludesw-")"+",["+package+".EXE]*.*)"
$	endif
$	ws "... Adding package ",package," environment files"
$	gosub backup_package
$	goto put_components
$skip_same_package:
$	ws "... Skipping over  ",package,", to components"
$	goto put_components
$! here with "{" components, so output just the ones we want
$components_only:
$	component_no=0
$	if is_AXP_issue		! we want to exclude AXP executables if VAX
$	then
$	   excludesw=""
$	else
$	   excludesw="/EXCLUDE=(*_TV*.*,*_AXP*.*)"
$	endif
$	source=from_root+"["+package+"...]"
$	destname=package
$	goto next_component
$put_components:
$	component_no=0
$	source=from_root+"["+package+".EXE]"
$	destname=package+"_2"
$	if same_package then destname=package+"_3"
$	ws "... Adding package ",package,component_message
$	if is_AXP_issue		! we want to exclude AXP executables if VAX
$	then
$	   excludesw=""
$	else
$	   excludesw="/EXCLUDE=(*_TV*.*,*_AXP*.*)"
$	endif
$	extra_components=""
$	if same_package then goto skip_extra1
$! ****  frigs to get LITES2 extras included ****
$	if package.eqs."LITES2" then -
	extra_components=extra_components+"/GEOGSHR/LCMSQUASH/"+customer
$! ****  frigs to get VTRAK licence included ****
$	if package.eqs."VTRAK" then -
	extra_components=extra_components+"/"+customer
$	if package.eqs."SCANCONVERT" then -
	extra_components=extra_components+"/"+customer
$! ****  frigs to get XGIS non-database routines images included    ****
$	if package.eqs."XGIS" then -
	extra_components=extra_components+"/START/RANGE/NETWORK/HARDCOPY"
$! ****  frigs to get FPP main shareable image included             ****
$	if package.nes."PLOTTING" then goto not_plotting
$	extra_components=extra_components+"/FPPSHR"
$skip_extra1:
$! ****  frigs to get FPP HCBS shareable images included            ****
$	add_hcbs=0
$	components_length=f$len(components)
$	hcbs_pos=f$locate("HCBS",components)
$	if hcbs_pos.lt.components_length then add_hcbs=1
$	hcbs_pos=f$locate("CAL907",components)
$	if hcbs_pos.lt.components_length then add_hcbs=1
$	hcbs_pos=f$locate("CAL925",components)
$	if hcbs_pos.lt.components_length then add_hcbs=1
$	hcbs_pos=f$locate("CAL1044",components)
$	if hcbs_pos.lt.components_length then add_hcbs=1
$	hcbs_pos=f$locate("CALGEOG",components)
$	if hcbs_pos.lt.components_length then add_hcbs=1
$	hcbs_pos=f$locate("CALAIDU",components)
$	if hcbs_pos.lt.components_length then add_hcbs=1
$	hcbs_pos=f$locate("BEN",components)
$	if hcbs_pos.lt.components_length then add_hcbs=1
$	if add_hcbs then extra_components=extra_components+"/HCBSSHR"
$! ****  frig to get PSEXPORT image included                        ****
$	if f$locate("POSTSCRIPT",components).lt.components_length then -
		extra_components=extra_components+"/PSEXPORT"
$not_plotting:
$	if extra_components.eqs."" then goto next_component
$	components=components+extra_components
$	ws "... Adding package ",package,", components: ",extra_components
$! ****  end of inclusion frigs					    ****
$next_component:
$	gosub get_component
$	if component.eqs."" then goto got_components
$	component_length=f$len(component)
$	dot_pos=f$locate(".",component)
$	if dot_pos.lt.component_length then goto dot_present
$	source=source+"*"+component+"*.*,"
$	goto next_component
$dot_present:
$	source=source+"*"+component+"*,"
$	goto next_component
$got_components:
$	length=f$length(source)-1
$	source=f$extract(0,length,source)
$	gosub backup_package
$	goto next_package
$!
$! ************************************************************************
$!
$! here when processed one line of packages - any more ?
$!
$done_line:
$	read/end=done2 customer_list line
$	if f$extract(0,1,line).nes." " then goto done_line
$	line=f$edit(line,"compress,trim,upcase")
$	if line.eqs."" then goto done_line
$	this_customer=f$element(0," ",line)
$	if this_customer.nes.customer then goto done2
$	this_computer=f$element(1," ",line)-"+AXP"
$	if this_computer.nes.computer then goto done2
$	goto process_line
$!
$! ************************************************************************
$!
$! here at end of package records for this customer/computer
$!
$done2:
$	close customer_list
$	customer_open = 0
$	if do_record then goto record_something
$	if .not.command_open then goto question
$!!!	if package_list.nes."" then goto no_customer
$! following stuff about adding _customer info skipped PGH 6/8/92
$! instead use CUSTOMER:_custname in CUSTOMERS.RNO
$	goto no_customer
$	if f$search("LSL$CUSTOMER_ROOT:[000000]_''customer'.DIR").eqs."" then goto no_customer
$	ws "Customer information exists in LSL$CUSTOMER_ROOT:[_''customer'...]"
$       read/end=exit/prompt="Add customer info [default N] ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if .not.yes then goto no_customer
$	wc "$!"
$	wc "$! now customer-specific stuff"
$	wc "$!"
$	from_root="LSL$CUSTOMER_ROOT:"
$	package="_"+customer
$	destname="_"+customer
$	source=from_root+"["+package+"...]*.*"
$	excludesw=""
$	gosub backup_package
$no_customer:
$	wc "$! End of issue"
$	wc "$!"
$!
$! ************************************************************************
$!
$! here to do final checks
$!
$	if package_list.eqs."" then goto package_check_ok
$	package_temp=package_check
$	package_temp=package_temp-","-","-","-","-","-","-","-","-","
$	package_temp=package_temp-","-","-","-","-","-","-","-","-","
$	if package_temp.eqs."" then goto package_check_ok
$	ws "%ISSUE-W-NOTTHEIRS, the following packages not found in customer list"
$	ws "%ISSUE-W-LIST, ",package_check
$package_check_ok:
$	if something_done then goto something_ok
$	ws "%ISSUE-W-NOTHING, no packages to ISSUE"
$something_ok:
$!
$! ************************************************************************
$!
$! record the event for posterity
$!
$record_it:
$	ws ""
$	reason=""
$       read/end=no_reason/prompt="Reason for issue ?  " -
		sys$command reason
$	reason=f$edit(reason,"trim")
$	if reason.eqs."" then goto record_it
$no_reason:
$	if reason.eqs."" then reason="Unknown"
$	if f$search(record_file).eqs."" then create 'record_file'
$	open/append record_file 'record_file'
$	record_open=1
$	close record_file
$	record_open=0
$	wc "$! now record the event for posterity"
$	wc "$!"
$	wc "$ SET NOVERIFY"
$	wc "$ OPEN/APPEND RECORD_FILE ",record_file
$	wc "$ WR=""WRITE RECORD_FILE"""
$	wc "$ WX=""WRITE SYS$OUTPUT"""
$	wr="write command_file ""$ WR """""","
$	wx="write command_file ""$ WX """""","
$	wrs="write command_file ""$ WR "","
$	wxs="write command_file ""$ WX "","
$	wr ""
$	wx ""
$	wr issue_text
$	wx issue_text
$	wr issue_text2
$	wx issue_text2
$	wrs "issue_text3"
$	wxs "issue_text3"
$	line=packages_tried
$	element_no=0
$record_more:
$	gosub get_package_line
$	if packages_line.eqs."" then goto packages_recorded
$	wr "Packages: ",packages_line
$	wx "Packages: ",packages_line
$	goto record_more
$packages_recorded:
$	if .not.is_axp_issue then goto not_AXP_record
$	wr "Target:   Alpha AXP"
$	wx "Target:   Alpha AXP"
$not_AXP_record:
$	if sincesw.nes."" then sincesw=sincesw-"/MODIF/SINCE="-""""-""""
$	if sincesw.nes."" then      wr "Since:    ",sincesw
$	wr "Reason:   ",reason
$	wx "Reason:   ",reason
$	wx ""
$	wc "$ CLOSE RECORD_FILE"
$	wc "$!"
$!
$! ************************************************************************
$!
$! record the dates for this customer
$!
$record_date:
$	wc "$ DATE_FILE=""''date_file'"""
$	wc "$ IF F$SEARCH(DATE_FILE).EQS."""" THEN CREATE 'DATE_FILE'"
$	wc "$ @''date_file'"
$ 	wc "$ OPEN/APPEND DATE_FILE ",date_file
$ 	wc "$ WD=""WRITE DATE_FILE""
$ 	if (.not. incr_issue) .and (.not. part_issue) .and. (.not. do_sources)-
		 then wc "$ WD ""$ full_exe_update=="""""",F$TIME(),"""""""""
$ 	if (incr_issue) .and. (.not. part_issue) .and. (.not. do_sources)-
		 then wc "$ WD ""$ incr_exe_update=="""""",F$TIME(),"""""""""
$ 	if (part_issue) .and. (.not. do_sources)-
		 then wc "$ WD ""$ part_exe_update=="""""",F$TIME(),"""""""""
$ 	if (do_sources) .and. (.not. incr_issue) .and. (.not. part_issue)-
		 then wc "$ WD ""$ full_source_update=="""""",F$TIME(),"""""""""
$ 	if ((incr_issue) .and. (do_sources .EQ. 1)) .and. (.not. part_issue)-
		 then wc "$ WD ""$ incr_source_update=="""""",F$TIME(),"""""""""
$ 	if do_sources .and. part_issue-
		 then wc "$ WD ""$ part_source_update=="""""",F$TIME(),"""""""""
$ 	if do_beta-
		 then wc "$ WD ""$ beta_status=="""""",F$TIME(),"""""""""
$ 	if was_beta.and..not.do_beta-
		 then wc "$ WD ""$ beta_status=="""""","""""""""
$ 	if is_axp_issue-
		 then wc "$ WD ""$ axp_status=="""""",F$TIME(),"""""""""
$ 	if was_axp.and..not.is_axp_issue-
		 then wc "$ WD ""$ axp_status=="""""","""""""""
$ 	wc "$ CLOSE DATE_FILE"
$	wc "$!"
$!
$! ************************************************************************
$!
$! produce listings from journal or tape itself
$!
$	wc "$ WS ""Producing BACKUP listing for printing"""
$	if list_from_journal
$	then
$	   wc "$ BACKUP",journalsw,"/LIST=",listing_file
$	else
$	   wc "$ SET VERIFY"
$	   wc "$ BACKUP ",destination,"*/REWIND/LIST=",listing_file
$	   wc "$ SET NOVERIFY"
$	endif
$	wc "$ LPSP/NOTIFY/PARAM=(NUMBER=4,SIDES=2)/NOFEED ",listing_file
$	wc "$ IF F$SEARCH(""",listing_file,";-1"").NES."""" THEN PURGE ",listing_file
$	wc "$!"
$!
$! ************************************************************************
$!
$! finish off the issue tape
$!
$	wc "$EXIT:"
$	wc "$ SET NOVERIFY"
$	if tape_device 
$	then 
$	   wc "$ WS ""Dismounting tape"""
$	   wc "$ DISMOUNT/NOUNLOAD ",destination
$	endif
$	if .not.remote_device then goto dism_done
$ 	wc "$ WAIT 0:0:20"
$	wc "$ WS ""Dismounting cartridge"""
$	wc "$ WS ""Do not worry if network timeout occurs"""
$	wc "$ TYPE ''dest_node'::""TASK=MUDISM"""
$ 	wc "$ WAIT 0:0:20"
$dism_done:
$	wc "$ IF F$SEARCH(ERROR_FILE).NES."""""
$	wc "$ THEN"
$	wc "$    WS ""***********************************************************************"""
$	wc "$    WS ""BACKUP errors and warnings occurred during issue generation, as follows"""
$	wc "$    WS ""***********************************************************************"""
$	wc "$    TYPE 'ERROR_FILE'"
$	wc "$    WS ""***********************************************************************"""
$	wc "$ ENDIF"
$	wc "$ IF SAVVER THEN SET VERIFY"
$	wc "$!"
$	wc "$ EXIT
$	wc "$!"
$	wc "$! Subroutine to remember BACKUP errors"
$	wc "$STORE_ERROR: ! store the error code and context for future reference"
$	wc "$   ERRCODE=$STATUS"
$	wc "$   SET NOVERIFY
$	wc "$   ERROR_FILE=""''error_file'"""
$	wc "$   IF F$SEARCH(ERROR_FILE).EQS."""" THEN CREATE 'ERROR_FILE'"
$ 	wc "$   OPEN/APPEND ERROR_FILE ",error_file
$ 	wc "$   WE=""WRITE ERROR_FILE""
$	wc "$   SET MESSAGE SYS$MESSAGE:SYSMGTMSG"
$	wc "$   ERRTEXT=F$MESSAGE(ERRCODE)"
$	wc "$   IF ERRCODE.EQS.""%X10A38400"" THEN ",-
                "ERRTEXT=""%BACKUP-W-NOFILES, No files selected""
$	wc "$   WE ""Saveset "",SAVESET,"" - "",ERRTEXT"
$ 	wc "$   CLOSE ERROR_FILE"
$	wc "$   SET VERIFY
$	wc "$ RETURN
$	wc "$!"
$	wc "$ WS ""Issue generation complete"""
$!
$! ************************************************************************
$!
$! actually do it ?
$!
$	close command_file
$	command_open=0
$get_now:
$	ws ""
$	ws "Issue command file is ",command_file
$	if f$search("''command_file';-1").nes."" then purge 'command_file'
$       read/end=exit/prompt="Execute command file now [default N] ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if .not.yes then goto question
$	if .not.tape_device then goto do_it_now
$	ownerpid=f$getdvi(device,"PID")
$	if ownerpid.eqs."" then goto do_it_now
$	mypid=f$getjpi("","PID")
$	if ownerpid.nes.mypid then goto someone_else
$	mountcnt=f$getdvi(device,"MOUNTCNT")
$	if mountcnt.gt.0 then goto already_mounted
$	goto do_it_now
$someone_else:
$	ws "%ISSUE-W-DEVOWNED, ",device," is currently owned by process ",ownerpid
$       owneruser=f$edit(f$getjpi(ownerpid,"username"),"collapse")
$	ws "%ISSUE-W-OWNER, owner username is ",owneruser
$	goto get_now
$already_mounted:
$	ws "%ISSUE-W-MOUNTED, ",device," is already mounted so MOUNT will fail"
$       read/end=exit/prompt="Go ahead now [default N] ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if .not.yes then goto question
$do_it_now:
$	@'command_file'
$	set noverify
$	goto question
$!
$! ************************************************************************
$!
$! subroutine to get the next package from the line
$!
$get_package:
$	package=f$element(element_no,",",LINE)
$	element_no = element_no + 1
$	if package.eqs."," then package=""
$	components=""
$	only_components=0
$	if package.eqs."" then return
$	package_length=f$len(package)
$! look for colon to signify new from_root
$	colon_pos=f$locate(":",package)
$	if colon_pos.ge.package_length then goto no_colon
$	from_root="LSL$"+f$extract(0,colon_pos,package)+"_ROOT:"
$	package=f$extract(colon_pos+1,package_length-colon_pos+1,package)
$	write sys$output "From ",from_root
$no_colon:
$! look for ( to signify components
$	bra_pos=f$locate("(",package)
$	if bra_pos.lt.package_length then goto got_round_bra
$! look for { to signify only components
$	curly_bra_pos=f$locate("{",package)
$	if curly_bra_pos.lt.package_length then goto got_curly_bra
$! look for ket as common layout mistake
$	ket_pos=f$locate(")",package)
$	if ket_pos.lt.package_length then goto found_ket_in_package
$	return
$got_curly_bra:
$	bra="{"
$	end_bra="}"
$	only_components=1
$	bra_pos=curly_bra_pos
$	goto got_bra
$got_round_bra:
$	bra="("
$	end_bra=")"
$got_bra:
$	components=f$extract(bra_pos,package_length-bra_pos,package)-bra-end_bra
$	package=f$extract(0,bra_pos,package)
$	return
$!
$found_ket_in_package:
$	ws "%ISSUE-F-INVPACKAGE, Invalid package description in CUSTOMERS.RNO."
$	ws "%ISSUE-W-HINT, Package is """,package,""""
$	ws "%ISSUE-W-HINT, check that ""/"" not "","" used between components"
$	goto emergency
$!
$!
$! ************************************************************************
$!
$! subroutine to get the next component from the list
$!
$get_component:
$	component=f$element(component_no,"/",components)
$	component_no = component_no + 1
$	if component.eqs."/" then component=""
$	return
$!
$!
$! ************************************************************************
$!
$! subroutine to get the next line of packages to record
$!
$get_package_line:
$	packages_line=""
$get_another_package:
$	gosub get_package
$	if package.eqs."" then return
$	packages_line=packages_line+package+","
$	length=f$len(packages_line)
$	if length.lt.60 then goto get_another_package
$	packages_line=f$extract(0,length-1,packages_line)
$	return
$!
$! ************************************************************************
$!
$! subroutine to get the next relevant line from the customer list
$!
$get_line:
$	read/end=no_more2 customer_list line
$	if f$extract(0,1,line).nes." " then goto get_line
$	line=f$edit(line,"compress,trim,upcase")
$	if line.eqs."" then goto get_line
$	return
$no_more2:
$	line=""
$	return
$!
$! ************************************************************************
$!
$! subroutine to strip the customer and computer info off line and format it
$!
$strip_line:
$	next_bit=f$element(2," ",line)
$	next_ptr=f$locate(next_bit,line)
$	line=f$extract(next_ptr,200,line)
$	line=f$edit(line,"upcase,collapse")
$	return
$!
$! ************************************************************************
$!
$! subroutine to check availability of a magtape device
$!	
$ check_device:
$	devnam=device-":"-"_"
$	devtype=""
$	exists=f$getdvi(device,"exists")
$	if .not.exists then goto end_check_device
$	devtype=f$getdvi(device,"MEDIA_NAME")
$	devtype_explain="(Unknown type)"
$	if devtype.eqs."TK50" then devtype_explain="(95MB Cartridge tape)"
$	if devtype.eqs."TZ30" then devtype_explain="(95MB Cartridge tape)"
$	if devtype.eqs."TK70" then devtype_explain="(296MB Cartridge tape)"
$	if devtype.eqs."TU81" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TU78" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TE16" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TS11" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TLZ04" then devtype_explain="(1.2GB DAT tape)"
$	if devtype.eqs."TLZ06" then devtype_explain="(4GB DAT tape)"
$	if devtype.eqs."TKZ08" then devtype_explain="(Exabyte tape)"
$	if devtype.eqs."MKX00" then devtype_explain="(SCSI tape)"
$	explain_owner=""
$	ownerpid=f$getdvi(device,"PID")
$	if ownerpid.eqs."" then goto output_check_device
$	owneruser=""
$	set noon
$       owneruser=f$getjpi(ownerpid,"username")
$	set on
$	if owneruser.eqs."" then owneruser="* UNKNOWN *"
$       owneruser=f$edit(owneruser,"collapse")
$	mountcnt=f$getdvi(device,"MOUNTCNT")
$	if mountcnt.gt.0 then goto dev_mounted
$	explain_owner=" -  Allocated by "+owneruser
$	goto output_check_device
$dev_mounted:
$	explain_owner=" -  Mounted by "+owneruser
$	goto output_check_device
$output_check_device:
$	ws "Device ",device," is a ",devtype," drive ",devtype_explain,explain_owner
$end_check_device:
$	devtype_'devnam'=devtype
$	return
$!
$! ************************************************************************
$!
$! subroutine to write BACKUP commands to output a particular package
$!	
$backup_package:
$	source_check=from_root+"[000000]"+package+".dir"
$	if f$search(source_check).eqs."" then goto no_such_package
$	if .not.remote_device then goto not_remote
$ 	wc "$ WAIT 0:0:20"
$not_remote:
$	wc "$ SAVESET=""''destname'"""
$	wc "$ BACKUP ",source," -"
$	if sincesw.nes."" then wc "	",sincesw," -"
$	if excludesw.nes."" then wc "	",excludesw," -"
$	if remote_device then goto remote_backup
$	if tape_device then goto backup_tape
$! here with non-tape (file-structured) destination
$	wc "	",destination,destname,"/SAVE/INTERCHANGE",miscsw,"-"
$	goto backup_both
$! here with tape destination
$backup_tape:
$	wc "	",destination,destname,"/INTERCHANGE",rewindsw,densitysw,"-"
$	wc "	","/LABEL=LSLSYS",miscsw,"-"
$	rewindsw="/NOREWIND"
$	got backup_both
$remote_backup:
$! here with remote network device as destination
$	destination=dest_node
$	destname="""TASK=MUBACK"""
$	wc "	",destination,destname,"/SAVE/BLOCK=4096/INTERCHANGE",miscsw,"-"
$backup_both:
$	wc "	",journalsw
$	wc "$ IF .NOT.$STATUS THEN GOSUB STORE_ERROR"
$	wc "$! "
$	something_done=1
$	return
$no_such_package:
$	ws "%ISSUE-W-NOPACKAGE, package ",source," not found."
$	return
$!
$! ************************************************************************
$!
$! subroutine to list possible packages
$!
$list_packages:
$	directory LSL$ISSUE_ROOT:[000000]*.dir
$	return
$!
$! ************************************************************************
$!
$! here for abnormal exits
$!
$emergency:
$	set noverify
$	ws "%ISSUE-W-ABORT, issue procedure terminated abnormally"
$!
$! ************************************************************************
$!
$! all done
$!
$exit:
$	if command_open then close command_file
$	if record_open then close record_file
$	if customer_open then close customer_list
$	if device_open then close device_list
$	exit
