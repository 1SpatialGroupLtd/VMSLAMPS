$	savver = f$verify(0)
$!
$!	Command file to initialise the FLOWLINE system
$!
$!	Created					MWSR	13-May-1988
$!	Modified				JMB	08-Jul-1988
$!	Modified				RWH	06-Sep-1990
$!Mod	Add support for acceptance testing	JMC	19-Mar-1991
$!Mod	DECCA2 version for LSL			RJH	30-Apr-1991
$!Mod	New version, root name as P1		CCB	10-Oct-1991
$!
$	ws = "write sys$output"
$!
$	root = p1
$	cust = p2
$!
$	missing = "ROOT"
$	if root .eqs."" then goto no_param_defined
$	missing = "Customer name"
$	if cust .eqs."" then goto no_param_defined
$	missing = "Flowline name"
$	if p3 .eqs."" then goto no_param_defined
$!
$! Search for the relevant directory for flowline package
$!
$! Check that LSL$SITE_ROOT is defined
$!
$	missing = "LSL$SITE_ROOT:"
$!
$	t = f$trnlnm("lsl$site_root")
$	if t.eqs."" then goto nodir
$!
$! Now check that the flowline directory is present in site root
$!
$	missing = "LSL$SITE_ROOT:[FLOWLINE]"
$!
$	t = f$search("LSL$SITE_ROOT:[000000]flowline.dir")	
$	if t.eqs."" then goto nodir
$!
$	dir = "lsl$site_root:["
$!
$! Now check that general purpose customer directory is present
$!
$	missing = "LSL$SITE_ROOT:[FLOWLINE.''cust']"
$!
$	t = f$search(dir + "flowline]" + "''cust'.dir")	
$	if t.eqs."" then goto nodir
$!
$! Set up symbol for general directory
$!
$	cust_dir = dir + "flowline.''cust']"
$!
$! Now check that database directory is present
$!
$	missing = "LSL$SITE_ROOT:[FLOWLINE.''cust'.DATABASE]"
$!
$	t = f$search(cust_dir + "database.dir")	
$	if t.eqs."" then goto nodir
$!
$! Now check that log directory is present
$!
$	missing = "LSL$SITE_ROOT:[FLOWLINE.''cust'.LOG]"
$!
$	t = f$search(cust_dir + "log.dir")	
$	if t.eqs."" then goto nodir
$!
$! Now check that login directory is present 
$!
$	missing = "LSL$SITE_ROOT:[FLOWLINE.''cust'.LOGIN]"
$!
$	t = f$search(cust_dir + "login.dir")
$	if t.eqs."" then goto nodir
$!
$! Now check that project directory is present
$!
$	missing = "LSL$SITE_ROOT:[FLOWLINE.''cust'.PROJECT]"
$!
$	t = f$search(cust_dir + "project.dir")
$	if t.eqs."" then goto nodir
$!
$! Now check that work directory is present 
$!
$	missing = "LSL$SITE_ROOT:[FLOWLINE.''cust'.WORK]"
$!
$	t = f$search(cust_dir + "work.dir")	
$	if t.eqs."" then goto nodir
$!
$! Now check that jacket directory is present
$!
$	missing = "LSL$SITE_ROOT:[FLOWLINE.''cust'.JACKET]"
$!
$	t = f$search(cust_dir + "jacket.dir")	
$	if t.eqs."" then goto nodir
$!
$! Now set up the logical names
$!
$	cust_dir = cust_dir - "]"
$!
$! Deal with database dir
$!
$	t = cust_dir + ".database]"
$	define/nolog lsl$fln_database 't
$!
$! Deal with log file dir
$!
$	t = cust_dir + ".log]"
$	define/nolog lsl$fln_log 't
$!
$! Deal with jacket dir
$!
$	t = cust_dir + ".jacket]"
$	define/nolog lsl$fln_jacket 't
$!
$! Deal with work dir
$!
$	t = cust_dir + ".work]
$	define/nolog lsl$fln_work 't
$!
$! Deal with login dir
$!
$	t = cust_dir + ".login]"
$	define/nolog lsl$fln_login 't', -
                             lsl$public_root:[flowline.com]
$!
$! Deal with project dir
$!
$	t = cust_dir + ".project]"
$	define/nolog lsl$fln_project 't
$!
$! Command Defns.
$!
$	lampscontrol == "$lsl$exe:lampscontrol"
$!
$! Set up logical name definitions for the flowlines
$! specified as parameters to the command file
$!
$	index = 3
$ next:	flowline = p'index'
$	if flowline .eqs. "" then goto exit
$	call flowline_setup 'root' 'cust' 'flowline'
$	index = index+1
$	goto next
$!
$! Exit
$!
$ exit:	
$	if savver then set verify
$	exit
$!
$! No dir found, so exit
$!
$ nodir:
$	ws "Cannot find directory ''missing'"
$	goto exit
$!
$! Deal with no definition of various things
$!
$ no_param_defined:
$	ws "No ''missing' has been defined"
$	ws ""
$	ws "Please re-execute FLOWLINEINI"
$	ws ""
$	ws "e.g @LSL$COM:FLOWLINEINI root customer flowline"
$	ws ""
$	goto exit
$!
$!----------------------------------------------------------------
$! Subroutine to check presence of and set up logical names
$! pointing to the directories for named flowline(s) passed as
$! parameters to the subroutine
$!
$ flowline_setup: subroutine
$!
$! p1 contains a root name
$! p2 contains a customer name
$! p3 contans a flowline name
$!
$	root = p1
$	cust = p2
$	flowline = p3
$!
$	if f$edit(cust,"UPCASE") .eqs. "ACCEPT"
$	then
$		site_dir    = "lsl$site_root:[flowline.accept"
$		root_dir    = "lsl$''root'_root:[flowline.accept"
$	else
$		site_dir    = "lsl$site_root:[''cust'.flowline.''flowline'"
$		root_dir    = "lsl$''root'_root:[''cust'.flowline.''flowline'"
$	endif
$	lnm = "lsl$fln_''flowline'_"
$!
$! Check that directories are present
$!
$! For site modifications, on SITE_ROOT
$!
$	missing = "''site_dir'.site]"
$	t = f$search(site_dir+"]site.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For job, on ROOT
$!
$	missing = "''root_dir'.job]"
$	t = f$search(root_dir+"]job.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For job, on SITE_ROOT
$!
$	missing = "''site_dir'.job]"
$	t = f$search(site_dir+"]job.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For element, on ROOT
$!
$	missing = "''root_dir'.element]"
$	t = f$search(root_dir+"]element.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! For procedure, on ROOT
$!
$	missing = "''root_dir'.procedure]"
$	t = f$search(root_dir+"]procedure.dir")
$	if t.eqs."" then goto missing_fln_dir
$!
$! define the logical names for individual directories
$!
$ 	define/nolog 'lnm'site		'site_dir'.site]
$	if f$edit(site_dir,"UPCASE") .eqs. f$edit(root_dir,"UPCASE")
$	then
$	   define/nolog 'lnm'job	'site_dir'.job], -
                                        'root_dir'.job]
$	else
$	   define/nolog 'lnm'job	'site_dir'.job], -
                                        'root_dir'.job]
$	endif
$	define/nolog 'lnm'element	'root_dir'.element]
$	define/nolog 'lnm'procedure	'root_dir'.procedure]
$!
$! define search list for all command procedures
$!
$	define/nolog 'lnm'com	'lnm'site, -
				'lnm'element, -
				'lnm'procedure, -
				'lnm'job
$!
$	exit
$!
$! Deal with missing flowline directory
$!
$ missing_fln_dir:
$	ws ""
$	ws "Missing directory  ''missing'"
$	ws "for Root ''root', Customer ''cust' and Flowline ''flowline'"
$	ws ""
$	exit
$!
$	endsubroutine
