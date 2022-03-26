$	set noon				! ignore $status settings
$	on control_y then exit 'HAD_CTRL'	! <CTRL/Y> is fatal
$!
$! *****************************************************************************
$! STANDARD_CREATE_SUB - this command file is called (via @) to handle the
$!		         creation of a new package directory structure
$!
$! It is currently called by either
$!
$!		LSL$DOC_COMMAND:STANDARD_CREATE
$!	or by	LSL$DOC_COMMAND:DOCUMENT
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author TJ Ibbs, 18 May 1987
$!
$! *****************************************************************************
$! - create the documentation directories that we need
$!
$	create/dir/log  LSL$DOC_ROOT:['DOC$package']
$	if .not.$status then goto final_exit
$!
$	create/dir/log  LSL$DOC_ROOT:['DOC$package'.SPS]
$	if .not.$status then goto final_exit
$!
$	create/dir/log  LSL$DOC_ROOT:['DOC$package'.GUIDE]
$	if .not.$status then goto final_exit
$!
$	create/dir/log  LSL$DOC_ROOT:['DOC$package'.REFERENCE]
$	if .not.$status then goto final_exit
$!
$! and we can now start to put some files into those directories
$! - start with the package title
$!
$	wsb
$	ws "Creating the package title page
$	wsb
$	copy/log  LSL$DOC_TEMPLATE:PACKAGE_TITLE.RNO -
		  LSL$DOC_ROOT:['DOC$package']
$	if .not.$status then goto final_exit
$!
$! - then the SPS directory
$!
$	wsb
$	ws "Creating the SPS"
$	wsb
$	copy/log  LSL$DOC_TEMPLATE:SPS.RNO -
		  LSL$DOC_ROOT:['DOC$package'.SPS]'DOC$package'_SPS.RNO
$	if .not.$status then goto final_exit
$!
$! - next the user GUIDE directory
$!
$	wsb
$	ws "Creating the user GUIDE"
$	wsb
$	copy/log  LSL$DOC_TEMPLATE:PACKAGE.SPEC -
		  LSL$DOC_ROOT:['DOC$package'.GUIDE]'DOC$package'_GUIDE.SPEC
$	if .not.$status then goto final_exit
$!
$	copy/log  LSL$DOC_TEMPLATE:PREFACE.RNO,CHANGES,INTRODUCTION -
  		  LSL$DOC_ROOT:['DOC$package'.GUIDE]
$	if .not.$status then goto final_exit
$!
$! - and then the REFERENCE manual directory
$!
$	wsb
$	ws "Creating the REFERENCE manual"
$	wsb
$	copy/log  LSL$DOC_TEMPLATE:PACKAGE.SPEC -
		  LSL$DOC_ROOT:['DOC$package'.REFERENCE]'DOC$package'_REF.SPEC
$	if .not.$status then goto final_exit
$!
$	copy/log  LSL$DOC_TEMPLATE:PREFACE.RNO,CHANGES,INTRODUCTION -
  		  LSL$DOC_ROOT:['DOC$package'.REFERENCE]
$	if .not.$status then goto final_exit
$!
$! .............................................................................
$!
$	wsb
$	ws "%DOC-S-NEWPACK, the documentation skeleton for package """ + -
	   DOC$package + """ is now created"
$	wsb
$	ws "To finish the skeleton" + -
	   " (before writing the actual documentation) you must:
$	wsb
$	wsb "	correct the  PACKAGE_TITLE.RNO"
$	wsb "	correct the     TITLE_PAGE.RNO		(all 3 directories)"
$	wsb "	correct the title in each .HDR file	(all 3 directories)"
$	wsb "	correct the .REQUIRE statements		(all 3 directories)"
$	wsb
$!
$! -----------------------------------------------------------------------------
$!
$final_exit:
$	exit '$status'
