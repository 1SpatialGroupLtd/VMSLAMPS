$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-04-30 19:02:00.000000000 +0100
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
$	savver = f$verify(0)
$!
$!	Command file to initialise the FLOWLINE system
$!
$!	Created					MWSR	13-May-1988
$!	Modified				JMB	08-Jul-1988
$!	Modified				RWH	06-Sep-1990
$!Mod	Add support for acceptance testing	JMC	19-Mar-1991
$!Mod	DECCA2 version for LSL			RJH	30-Apr-1991
$!
$!
$!
$! form a data root for FLOWLINE
$! must search for the directory LSL$SITE_ROOT:[FLOWLINE.GENERAL]
$! Allowing for LSL$SITE_ROOT to be search list
$!
$!
$	index = 0
$	gendir = p1
$!
$! Loop which searches for the relevant directory for flowline
$! package, searching down LSL$SITE_ROOT, which is a search list
$!
$ finddir:
$!
$! Check that LSL$SITE_ROOT is defined
$!
$	missdir = "LSL$SITE_ROOT:"
$!
$	dir = f$trnlnm("lsl$site_root",,index)
$	if dir.eqs."" then goto nodir
$!
$! Now check that the flowline directory is present in site root
$!
$	missdir = "LSL$SITE_ROOT:[FLOWLINE]"
$!
$	t = f$search("''dir'"-".]"+"]"+"flowline.dir")	
$	if t.nes."" then goto gotdir
$!
$! Move to the next item in the list
$!
$	index = index + 1
$	goto finddir
$!
$! Jump here when have found flowline directory
$!
$ gotdir:
$	dir = "lsl$site_root:["
$!
$! Now check that general directory is present
$!
$	missdir = "LSL$SITE_ROOT:[FLOWLINE.''gendir']"
$!
$	t = f$search(dir + "flowline]" + "''gendir'.dir")	
$	if t.eqs."" then goto nodir
$!
$! Set up symbol for general directory
$!
$	gen_dir = dir + "flowline.''gendir']"
$!
$! Now check that database directory is present
$!
$	missdir = "LSL$SITE_ROOT:[FLOWLINE.''general'.DATABASE]"
$!
$	t = f$search(gen_dir + "database.dir")	
$	if t.eqs."" then goto nodir
$!
$! Now check that definition directory is present
$!
$	missdir = "LSL$SITE_ROOT:[FLOWLINE.''gendir'.DEFINITION]"
$!
$	t = f$search(gen_dir + "definition.dir")	
$	if t.eqs."" then goto nodir
$!
$! Now check that log directory is present
$!
$	missdir = "LSL$SITE_ROOT:[FLOWLINE.''gendir'.LOG]"
$!
$	t = f$search(gen_dir + "log.dir")	
$	if t.eqs."" then goto nodir
$!
$! Now check that login directory is present 
$!
$	missdir = "LSL$SITE_ROOT:[FLOWLINE.''gendir'.LOGIN]"
$!
$	t = f$search(gen_dir + "login.dir")
$	if t.eqs."" then goto nodir
$!
$! Now check that project directory is present
$!
$	missdir = "LSL$SITE_ROOT:[FLOWLINE.''gendir'.PROJECT]"
$!
$	t = f$search(gen_dir + "project.dir")
$	if t.eqs."" then goto nodir
$!
$! Now check that work directory is present 
$!
$	missdir = "LSL$SITE_ROOT:[FLOWLINE.''gendir'.WORK]"
$!
$	t = f$search(gen_dir + "work.dir")	
$	if t.eqs."" then goto nodir
$!
$! Now check that jacket directory is present
$!
$	missdir = "LSL$SITE_ROOT:[FLOWLINE.''gendir'.JACKET]"
$!
$	t = f$search(gen_dir + "jacket.dir")	
$	if t.eqs."" then goto nodir
$!
$! Now set up the logical names
$!
$	gen_dir = gen_dir - "]"
$!
$! Deal with database dir
$!
$	t = gen_dir + ".database]"
$	if f$trnlnm("lsl$fln_database") .eqs. ""
$	then
$		define/nolog lsl$fln_database 't
$	endif
$!
$! Deal with definition dir
$!
$	t = gen_dir + ".definition]"
$	if f$trnlnm("lsl$fln_definition") .eqs. ""
$	then
$		define/nolog lsl$fln_definition 't
$	endif
$!
$! Deal with log file dir
$!
$	t = gen_dir + ".log]"
$	if f$trnlnm("lsl$fln_log") .eqs. ""
$	then
$		define/nolog lsl$fln_log 't
$	endif
$!
$! Deal with jacket dir
$!
$	t = gen_dir + ".jacket]"
$	if f$trnlnm("lsl$fln_jacket") .eqs. ""
$	then
$		define/nolog lsl$fln_jacket 't
$	endif
$!
$! Deal with work dir
$!
$	t = gen_dir + ".work]
$	if f$trnlnm("lsl$fln_work") .eqs. ""
$	then
$		define/nolog lsl$fln_work 't
$	endif
$!
$! Deal with login dir
$!
$	t = gen_dir + ".login]"
$	if f$trnlnm("lsl$fln_login") .eqs. ""
$	then
$		define/nolog lsl$fln_login 't', -
                             lsl$public_root:[flowline.com]
$	endif
$!
$! Deal with project dir
$!
$	t = gen_dir + ".project]"
$	if f$trnlnm("lsl$fln_project") .eqs. ""
$	then
$		define/nolog lsl$fln_project 't
$	endif
$!
$! Command Defns.
$!
$	lampscontrol == "$lsl$exe:lampscontrol"
$!
$! Set up logical name definitions for the flowlines
$! specified as parameters to the command file
$!
$	call flowline_setup 'p1' 'p2' 'p3' 'p4' 'p5' 'p6' 'p7' 'p8'
$!
$! Exit
$!
$ exit:	
$	savver = f$verify(savver)
$	exit
$!
$! No dir found, so exit
$!
$ nodir:
$	write sys$output "Cannot find directory ''missdir'"
$	goto exit
$!
$!----------------------------------------------------------------
$! Subroutine to check presence of and set up logical names
$! pointing to the directories for named flowline(s) passed as
$! parameters to the subroutine
$!
$ flowline_setup: subroutine
$!
$! For each parameter p1-p8 attempt to set up relevant
$! The parameter p1, if non-null will contain a customer name
$! The parameters p2 to p8, if non-null will contain application names
$!
$! Examine parameter p1 to see if non-null
$!
$	if p1 .eqs."" then goto no_customer_defined
$!
$! Set up symbol giving customer name currently of interest
$!
$	customer = p1
$!
$	index = 2
$!
$! Parameter p2 equals the Flowline name, e.g. DTED, DFAD, TPLATE, etc...
$!
$! Examine next parameter to see if non-null
$!
$	if p2 .eqs."" then goto no_flowline_defined
$!
$ flowline_param_loop:
$!
$	if index .gt. 8 then goto end
$	if p'index' .eqs. "" then goto end
$!
$! Set up symbol giving flowline name currently of interest
$!
$	flowline = p'index'
$!
$! Now increment index
$!
$	index = index + 1
$!
$	if f$edit(customer,"UPCASE") .eqs. "ACCEPT"
$	then
$		site_dir    = "lsl$site_root:[flowline.accept"
$		public_dir  = "lsl$public_root:[flowline.accept"
$		project_dir = "lsl$public_root:[flowline"
$	else
$		site_dir    = "lsl$site_root:[''customer'.flowline.''flowline'"
$		public_dir  = "lsl$source_root:[''customer'.flowline.''flowline'"
$		project_dir = "lsl$source_root:[''customer'.flowline"
$	endif
$	lnm = "lsl$fln_''flowline'_"
$!
$! ***** Note: lsl$source_root in 2 lines above should be changed to 
$! *****       lsl$public_root at customer site
$!
$! Check that directories are present
$!
$! For site modifications, on SITE_ROOT
$!
$	missdir = "''site_dir'.site]"
$	t = f$search(site_dir+"]site.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For definition, on PUBLIC_ROOT
$!
$	missdir = "''public_dir'.definition]"
$	t = f$search(public_dir+"]definition.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For definition, on SITE_ROOT
$!
$	missdir = "''site_dir'.definition]"
$	t = f$search(site_dir+"]definition.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For job, on PUBLIC_ROOT
$!
$	missdir = "''public_dir'.job]"
$	t = f$search(public_dir+"]job.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For job, on SITE_ROOT
$!
$	missdir = "''site_dir'.job]"
$	t = f$search(site_dir+"]job.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For element, on PUBLIC_ROOT
$!
$	missdir = "''public_dir'.element]"
$	t = f$search(public_dir+"]element.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For element, on SITE_ROOT
$!
$	missdir = "''site_dir'.element]"
$	t = f$search(site_dir+"]element.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For procedure, on PUBLIC_ROOT
$!
$	missdir = "''public_dir'.procedure]"
$	t = f$search(public_dir+"]procedure.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For procedure, on SITE_ROOT
$!
$	missdir = "''site_dir'.procedure]"
$	t = f$search(site_dir+"]procedure.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! define the logical names for individual directories
$!
$ 	define/nolog 'lnm'site		'site_dir'.site]
$ 	define/nolog 'lnm'definition	'site_dir'.definition], -
					'public_dir'.definition]
$	define/nolog 'lnm'job		'site_dir'.job], -
                                        'public_dir'.job]
$	define/nolog 'lnm'element	'site_dir'.element], -
					'public_dir'.element]
$	define/nolog 'lnm'procedure	'site_dir'.procedure], -
					'public_dir'.procedure]
$!
$! define search list for all command procedures
$!
$	define/nolog 'lnm'com		'lnm'site, -
				'lnm'element, -
				'lnm'procedure, -
				'lnm'job, -
				'lnm'definition
$!
$! define search list for projects
$!
$!!!!!	old_project_logical = f$trnlnm("lsl$fln_project")
$!!!!!	define/nolog lsl$fln_project 'old_project_logical',-
!!!!!                                     'project_dir'.'general'.project]
$!
$	goto flowline_param_loop
$!
$! Deal with missing flowline directory
$!
$ missing_fln_dir:
$	write sys$output ""
$	write sys$output "Missing directory  ''missdir'"
$	write sys$output "for Customer ''customer' and Flowline ''flowline'"
$	write sys$output ""
$!
$	goto flowline_param_loop
$!
$! Deal with no definition of customer (missing parameter p1)
$!
$ no_customer_defined:
$	write sys$output "No Customer name has been defined"
$	write sys$output ""
$	write sys$output "Please re-execute FLOWLINEINI"
$	write sys$output ""
$	write sys$output "e.g @LSL$COM:FLOWLINEINI customer flowline"
$	write sys$output ""
$!
$	goto end
$!
$! Deal with no definition of Flowline (missing parameter p2)
$!
$ no_flowline_defined:
$	write sys$output "No Flowline name has been defined"
$	write sys$output ""
$	write sys$output "Please re-execute FLOWLINEINI"
$	write sys$output ""
$	write sys$output "e.g @LSL$COM:FLOWLINEINI customer flowline"
$	write sys$output ""
$!
$	goto end
$!
$! Exit point for subroutine
$!
$ end:
$	endsubroutine
