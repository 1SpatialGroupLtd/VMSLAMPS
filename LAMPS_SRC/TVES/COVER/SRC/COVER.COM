$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! command file to compile and link COVER
$!
$!	mod1264 use tves service library
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	set nover
$!
$	def	lsl$tvessys	lsl$source_root:[tves.service]
$!
$	deb=""
$!
$	inquire compile "compile"
$	if .not.compile then goto nocompile
$!
$	INQUIRE cover "compile cover?"
$	INQUIRE table "compile table?"
$	INQUIRE files "compile files?"
$	INQUIRE display "compile display?"
$	INQUIRE visibility "compile visibility?"
$	INQUIRE covcmd "command table?"
$!
$nocompile:
$       inquire lnkarg   "link (ARGS)"
$	inquire lnkmotif "link (MOTIF)"
$	inquire lnkuis   "link (UIS)"
$	inquire lnksig   "link (SIG6000)"
$	inquire debug    "debug"
$!
$	if .not. debug then goto nodebug
$	if debug then deb = "/debug/noopt/check=(b,o)"
$	if deb.nes."" then mbug = "/debug"
$	if deb.nes."" then ibug = "/debug"
$!
$nodebug: set verify
$	if .not.compile then goto link
$!
$	if .not.cover then goto nocover
$	adc cover = cover,cover_init,help,cover_print_observers,-
                    cover_print_targets,cover_set_window,readll
$	fortran 'deb' cover
$	pvv  cover
$!
$nocover: if.not.files then goto nofiles
$	adc files = create_file,open_file,get_filename
$	fortran 'deb' files
$	pvv files
$
$!
$nofiles: if .not.table then goto notable
$	adc table = setmap,showerr,put_output,transf,-
		    getdti,gettab,wait,ctrlcast,hadctrlc
$	fortran 'deb' table
$	pvv  table
$!
$notable: if.not.display then goto nodisplay
$	adc display = display,display_init,legend,annotate,-
		      display_inside
$	fortran 'deb' display
$	pvv  display
$!
$nodisplay: if.not.visibility then goto novisibility
$	adc visible = combine,create,visibility,inside,obstat,select,-
	              visble,write_column,framed_mes,write_dti,point
$	fortran 'deb' visible
$	pvv visible
$!
$novisibility: if .not.covcmd then goto link
$	macro 'mbug' cover_commands
$!
$link: 	
$	run lsl$exe:genver
$	adc version=version
$	fortran 'deb' version
$	pvv version
$	if .not.lnkarg then goto nolnkarg
$
$	link 'ibug'/map=coverargs/exe=coverargs -
			cover,version,table,files,display,-
			visible,cover_commands,-
			lsl$tvessys:tves_service/lib,-
			lsl$library:tablib/lib,- 
			lsl$library:gksldlib2/lib,-
			lsl$library:wosplib/lib,-
			lsl$library:vslib/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr/opt
$!
$	mapid coverargs
$	delete coverargs.map;*
$!
$nolnkarg: if .not.lnkmotif then goto nolnkmotif
$!	@sys$common:[decw$motif]dxm_logicals
$!
$	link 'ibug'/map=covermotif/exe=covermotif -
			cover,version,table,files,display,-
			visible,cover_commands,-
			lsl$tvessys:tves_service/lib,-
			lsl$library:tablib/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:gksmotiflib/lib,-
			lsl$library:lslshr/opt,-
			sys$input:/opt
			sys$share:xdps$dpsbindingsshr/share
			sys$share:decw$xmlibshr/share
$!
$	mapid covermotif
$	delete covermotif.map;*
$!
$nolnkmotif: if .not.lnkuis then goto nolnkuis
$	link 'ibug'/map=coveruis/exe=coveruis -
			cover,version,table,files,display,-
			visible,cover_commands,-
			lsl$tvessys:tves_service/lib,-
			lsl$library:tablib/lib,-
			lsl$library:gksuislib/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr/opt
$!
$	mapid coveruis
$	delete coveruis.map;*
$!
$nolnkuis: if .not.lnksig then goto nolnk
$	link 'ibug'/map=coversig6000/exe=coversig6000 -
			cover,version,table,files,display,-
			visible,cover_commands,-
			lsl$tvessys:tves_service/lib,-
			lsl$library:tablib/lib,-
			lsl$library:gkssiglib/lib,-
			lsl$library:wkslib/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr/opt
$!
$	mapid coversig6000
$	delete coversig6000.map;*
$!
$nolnk:
$	set ver
$	delete adc.ide;*
$!	purge *.exe
$	purge *.obj
$	purge *.for
$	set noverify
$!
