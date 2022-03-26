$!
$! Command file to build CONVERT utility MGD2I
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!
$!	Mod 1435 Use new frtshr				 JB 23-Nov-1994
$!
$	ver=f$verify(0)
$!
$	on error then goto mgd2iex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$mgd2i_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto mgd2iex
$	define/group lsl$mgd2i_building "in_progress"
$	open/write comfil mgd2ibat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto mgd2iex"
$	wc "$	if ""'","'f$logical(""lsl$mgd2i_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$mgd2i_building ""in_progress"""
$!
$	wc "$	assign here lsl$mgd2i"
$	wc "$	sd:=$lsl$exe:sd"
$!
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	mgd2i_dbg=""
$	cldgen=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop mgd2i_dbg "With Debug ? "
$	if .not. mgd2i_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$!
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$!
$	mgd2i = "t"
$	decode_command_line = "t"
$	setup_tape = "t"
$	create_iff_file = "t"
$	process_header_blocks = "t"
$	process_data_blocks = "t"
$	update_header_zs = "t"
$	update_iff_header = "t"
$	close_iff_file = "t"
$	mgd2i_init = "t"
$	read_header_block = "t"
$	start_layer = "t"
$	finish_layer = "t"
$	start_feature = "t"
$	finish_feature = "t"
$	write_first_header = "t"
$	write_extra_header = "t"
$	read_block = "t"
$	output_block_diagnostics = "t"
$	read_data_block = "t"
$	write_data_features = "t"
$	finish_file = "t"
$	write_data_zs = "t"
$	write_zs = "t"
$	write_data_ac = "t"
$	write_ac = "t"
$	buffer_is_blank = "t"
$	replace_character = "t"
$	convert_integer = "t"
$	check_header_sequence = "t"
$	
$	goto a11
$ a05:	   
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop mgd2i "mgd2i ? "
$	inq/nop decode_command_line "decode_command_line ? "
$	inq/nop setup_tape "setup_tape ? "
$	inq/nop create_iff_file "create_iff_file ? "
$	inq/nop process_header_blocks "process_header_blocks ? "
$	inq/nop process_data_blocks "process_data_blocks ? "
$	inq/nop update_header_zs "update_header_zs ? "
$	inq/nop update_iff_header "update_iff_header ? "
$	inq/nop close_iff_file "close_iff_file ? "
$	inq/nop mgd2i_init "mgd2i_init ? "
$	inq/nop read_header_block "read_header_block ? "
$	inq/nop start_layer "start_layer ? "
$	inq/nop finish_layer "finish_layer ? "
$	inq/nop start_feature "start_feature ? "
$	inq/nop finish_feature "finish_feature ? "
$	inq/nop write_first_header "write_first_header ? "
$	inq/nop write_extra_header "write_extra_header ? "
$	inq/nop read_block "read_block ? "
$	inq/nop output_block_diagnostics "output_block_diagnostics ? "
$	inq/nop read_data_block "read_data_block ? "
$	inq/nop write_data_features "write_data_features ? "
$	inq/nop finish_file "finish_file ? "
$	inq/nop write_data_zs "write_data_zs ? "
$	inq/nop write_zs "write_zs ? "
$	inq/nop write_data_ac "write_data_ac ? "
$	inq/nop write_ac "write_ac ? "
$	inq/nop buffer_is_blank "buffer_is_blank ? "
$	inq/nop replace_character "replace_character ? "
$	inq/nop convert_integer "convert_integer ? "
$	inq/nop check_header_sequence "check_header_sequence ? "
$!
$ a11:
$	   inq/nop cldgen	"Generate command definitions? "
$!
$	   inq/nop mes "Generate message definitions ? "
$!
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="mgd2i"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not.mes then goto cmponly
$		wc "$	newmsg/number=1617/prefix=mgd2i__ -"
$		wc "	/parameter=for/runoff mgd2i.mes"
$		wc "$ @mgd2i.temp_com"
$!	
$ cmponly:		
$	if .not. cldgen then goto for2
$		wc "$	adc mgd2i.tmp = mgd2i_cld.cld"
$		wc "$	set command/object =mgd2i_cld mgd2i.tmp"
$		wc "$	pvv mgd2i_cld"
$		wc "$	delete mgd2i.tmp;*"
$		wc "$	delete adc.ide;*"
$		wc "$	purge mgd2i_cld.obj"
$		wc "$	set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$ for2: if .not. compile then goto lnkonly
$!	
$!
$	if mgd2i then call compiler mgd2i
$	if decode_command_line then call compiler decode_command_line
$	if setup_tape then call compiler setup_tape
$	if create_iff_file then call compiler create_iff_file
$	if process_header_blocks then -
				call compiler process_header_blocks
$	if process_data_blocks then call compiler process_data_blocks
$	if update_header_zs then call compiler update_header_zs
$	if update_iff_header then call compiler update_iff_header
$	if close_iff_file then call compiler close_iff_file
$	if mgd2i_init then call compiler mgd2i_init
$	if read_header_block then call compiler read_header_block
$	if start_layer then call compiler start_layer
$	if finish_layer then call compiler finish_layer
$	if start_feature then call compiler start_feature
$	if finish_feature then call compiler finish_feature
$	if write_first_header then call compiler write_first_header
$	if write_extra_header then call compiler write_extra_header
$	if read_block then call compiler read_block
$	if output_block_diagnostics then -
				call compiler output_block_diagnostics
$	if read_data_block then call compiler read_data_block
$	if write_data_features then call compiler write_data_features
$	if finish_file then call compiler finish_file
$	if write_data_zs then call compiler write_data_zs
$	if write_zs then call compiler write_zs
$	if write_data_ac then call compiler write_data_ac
$	if write_ac then call compiler write_ac
$	if buffer_is_blank then call compiler buffer_is_blank
$	if replace_character then call compiler replace_character
$	if convert_integer then call compiler convert_integer
$	if check_header_sequence then -
				call compiler check_header_sequence
$!
$	   goto lnkonly
$!----------------------------------------------------------------------
$ compiler: subroutine 
$!----------------------------------------------------------------------
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc ''p1'''kpcom'=''p1'"
$	   	wc "$	fort''fsw1' ''p1'"
$	      	wc "$ 	ok=$status"	
$		wc "$ 	if ok then pvv ''p1'"
$		wc "$ 	purge/nolog ''p1'.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog ''p1'.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog ''p1'.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" ''p1'"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!----------------------------------------------------------------------
$ lnkonly:
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output ""Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	goto nolnk"
$	wc "$	noerr:"
$ 	if .not. lnkit then goto nolnk
$	wc "$ set noverify"
$	wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$ 	link''linkopts'/exe=''linkver' mgd2i/opt, -"
$	wc "		mgd2i.promsg_obj, -"
$	WC "		lsl$library:frtshr/opt,-
$	WC "		lsl$library:lslshr/opt, lsl$library:iffshr/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	mgd2iex:"
$		wc "$ 	deass/group lsl$mgd2i_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto mgd2iex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$mgd2i_building
$	submit/notify/noprint/keep/restart mgd2ibat.com
$	goto mgd2ix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto mgd2iex
$	deass/group lsl$mgd2i_building
$	@mgd2ibat.com
$	goto mgd2ix2
$!
$ mgd2iex:
$	deass/group lsl$mgd2i_building
$!
$ mgd2ix2:
$	if ver then set verify
$!
