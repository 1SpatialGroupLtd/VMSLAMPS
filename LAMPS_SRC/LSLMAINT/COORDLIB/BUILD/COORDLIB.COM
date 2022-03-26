$	set noverify
$	goto start_doing_things
$!  
$! *************************************************************************
$!
$!	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
$!
$! 	Extended to include 3D interpolation		RWR	08-Feb-1989
$!
$! 	Extended to include BEZIER algorithms		DRC     04-Aug-1987
$!	Extended to include QUADSCAN			ACM	10-Aug-1987
$!	Created (cribbed from LSLLIB command file)	RJH	13-Nov-1986
$!
$!	COORDLIB - Create or update the library
$!
$! *************************************************************************
$!
$! Description
$!
$!	Command file which creates or updates COORDLIB, the LSL coordinate 
$!	manipulation library. The library includes 
$!
$!		- line filtering routines
$!		- curve and linear interpolation routines
$!		- area fill routines
$!		- quadtree processing routine
$!
$! *************************************************************************
$!
$start_doing_things:
$!
$	assign  'f$logical("HERE")  start_directory
$!
$	on control_y then goto tidy_exit
$	on error     then goto tidy_exit
$!
$! first define some symbols
$!
$	ws	= "write sys$output"
$	wsb	= "write sys$output """""
$	inq	= "inquire"
$!
$! and set up logicals
$!
$	assign  lsl$source_root:[lslmaint.coordlib.common] cmn
$!
$! *************************************************************************
$!
$	inquire testing_version "Is this a testing version "
$!
$! we need to specify where the finished library will be put
$!
$	if   testing_version -
	then assign  lsl$source_root:[lslmaint.coordlib.test]  coordlib_destination
$	if   .not.testing_version -
	then assign  lsl$source_root:[lslmaint.coordlib]  coordlib_destination
$!
$! and ensure that we are in the correct directory
$!
$	wsb
$!	sd  coordlib_destination
$!
$! *************************************************************************
$! now, find out what we are meant to be doing...
$!
$	wsb
$	inq	new_library	"Make a new library     "
$!
$	with_debug = 0
$	if testing_version then -
	inq	with_debug	"With debug             "
$!
$! *************************************************************************
$! sort out subsidiary variables
$!
$	not_all = .not.new_library
$	if with_debug then goto set_debug
$	   fdb     = ""
$	   mdb     = ""
$	   adcco   = ""
$	   cleanup = "delete"
$	   ver     = ";*"
$	   goto end_debug
$!
$set_debug:
$	   fdb     = "/debug/noopt/check=all"
$	   mdb     = "/debug"
$	   adcco   = "/co"
$	   cleanup = "purge"
$	   ver     = ""
$!
$end_debug:
$!
$! *************************************************************************
$! if we are creating a library from scratch, then we shall insert modules
$! into it. If we are updating a library, then we shall replace modules in it
$!
$! first initialise the logicals
$!
$	   do_filt	= 0
$	   do_int	= 0
$	   do_area	= 0
$	   do_bezier    = 0
$	   do_quad      = 0
$!
$! now do the action
$!
$	if .not.new_library then goto ask_what_to_replace
$!
$	library/create  coordlib_destination:coordlib
$	libr = "library/insert/log coordlib_destination:coordlib"
$	goto compilation
$!
$! *************************************************************************
$ask_what_to_replace:
$!
$	libr = "library/replace/log  coordlib_destination:coordlib"
$!
$	wsb
$	ws "What to replace -"
$	wsb
$	inq	do_filt		"FILTER   - filtering         "
$	inq	do_int		"INTRPL   - interpolation     "
$	inq     do_bezier       "BEZIER   - bezier interpolation "
$!**	inq	do_area		"AREA     - area fill         "
$	inq	do_quad		"QUADSCAN - quadtree processing"
$!
$! *************************************************************************
$! now do the actual work...
$!
$compilation:	set verify
$!
$	if not_all .and. .not. do_filt then goto no_filt
$	   from = "[lslmaint.coordlib.filter]"
$	   adc		filter'adcco'='from'bunch_init,bunch_line,bunch_point
$	   adc		filter/ap'adcco'='from'bunch,bunch_filter,bunch_flush
$	   adc		filter/ap'adcco'='from'dp_init,dp_line,reduce
$	   fortran'fdb'	filter
$	   pvv		filter
$	   libr		filter
$	   purge	filter.obj
$	   delete	adc.ide;*
$	   cleanup	filter.for'ver'				 
$no_filt:
$!
$	if not_all .and. .not. do_int then goto no_int
$	   from = "[lslmaint.coordlib.intrpl]"
$	   adc		intrpl'adcco'='from'intrpl,extrpl,akima,mconal,linear
$	   adc		intrpl/ap'adcco'='from'intrpl3d,akima3d,mconal3d
$	   adc		intrpl/ap'adcco'='from'grad,incsiz,curtol,intrpl_init
$	   fortran'fdb'	intrpl
$	   pvv		intrpl
$	   libr		intrpl
$	   purge	intrpl.obj
$	   delete	adc.ide;*
$	   cleanup	intrpl.for'ver'				 
$no_int:
$!
$	if not_all .and. .not. do_bezier then goto no_area
$	   from = "[lslmaint.coordlib.bezier]"
$	   adc		bezier'adcco'='from'bezier_interpolation
$	   adc		bezier/ap'adcco'='from'spcpts,avpts,thin
$	   adc		bezier/ap'adcco'='from'bezier,bezier_interp
$	   fortran'fdb'	bezier
$	   pvv		bezier
$	   libr		bezier
$	   purge	bezier.obj
$	   delete	adc.ide;*
$	   cleanup	bezier.for'ver'				 
$!
$!**	if not_all .and. .not. do_area then goto no_area
$!**	   from = "[lslmaint.coordlib.area]"
$!**	   adc		area'adcco'='from'
$!**	   adc		area/ap'adcco'='from'
$!**	   fortran'fdb'	area
$!**	   pvv		area
$!**	   libr		area
$!**	   purge	area.obj
$!**	   delete	adc.ide;*
$!**	   cleanup	area.for'ver'				 
$!
$no_area:
$!
$	if not_all .and. .not. do_quad then goto no_quad
$	   from = "[lslmaint.coordlib.quadscan]"
$	   adc		quadscan'adcco'='from'quadscan
$	   adc		quadscan/ap'adcco'='from'diarptbx,diarvebx
$	   adc		quadscan/ap'adcco'='from'dillptbx,dillvebx
$	   adc		quadscan/ap'adcco'='from'prarptbx,prarvebx
$	   adc		quadscan/ap'adcco'='from'prllptbx,prllvebx
$	   fortran'fdb'	quadscan
$	   pvv		quadscan
$	   libr		quadscan
$	   purge	quadscan.obj
$	   delete	adc.ide;*
$	   cleanup	quadscan.for'ver'				 
$!
$no_quad:
$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	sd        start_directory
$	deassign  start_directory
$	exit
$!
