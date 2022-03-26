$! LSLMAINTINI.COM
$! Command file to set up symbols for LSLMAINT
$!
$! set up logical names
$! (don't actually do this, since normally done at system startup)
$!!!	define	lsl$cmncoord	lsl$public_root:[lslmaint.common.coordlib]
$!!!	define	lsl$cmnvio	lsl$public_root:[lslmaint.common.violib]
$!!!	define	lsl$cmnosmh	lsl$public_root:[lslmaint.common.osmhlib]
$!
$! symbols that point to command files
$!
$	make		== "@lsl$com:make"	! 'make' utility
$	qlst		== "@lsl$com:qlst"	! queue listings
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	suffix=""
$	if f$getsyi("ARCH_NAME").eqs."Alpha" then suffix="_tv"
$!
$! symbols for images
$!
$	adc		== "@lsl$com:adc_jacket"  ! file preprocessor jacket
$!
$	adcc		== "$lsl$exe:adcc"+suffix  ! file preprocessor
$	frl		== "$lsl$exe:frl"	! Fortran re-labeller
$	ibm		== "$lsl$exe:ibm"	! write IBM unlabelled magtapes
$	mapid		== "$lsl$exe:mapid"+suffix ! process a map file
$	pid		== "$lsl$exe:pid"	! patch an ID in a text file
$	pvv		== "$lsl$exe:pvv"+suffix   ! apply that ID to an object
$	say		== "$lsl$exe:say"	! say to another user
$	screen		== "$lsl$exe:screen"	! look at a .MEM file
$	tapecopy	== "$lsl$exe:tapecopy"	! tape to disk utility
$!
