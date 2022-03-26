$!
$	ver=f$verify(0)
$!
$!	Copyright Laser-Scan Ltd., Cambridge, England.
$!
$!	Created					RJH	19-May-1986
$!
$!MOD	Newmessage F(ortran) option added	ATT	14-Jan-1987
$!MOD   New area clipping routines added	JB	25-May-1990
$!MOD	Changed the build directory for CMS	ST	27-Jul-1993
$!MOD1432 Use new frtshr			JB	21-Nov-1994
$!	  and set up logical lsl$iwinpoly as the
$!	  directory holding poly.olb
$!
$!	IMP IWINDOW Program - Command file for building it
$!
$	on error then goto iwindowex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$iwindow_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building IWINDOW"
$	exit
$a0:	on control_y then goto iwindowex
$	define/group lsl$iwindow_building "in_progress"
$	open/write comfil iwindowbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto iwindowex"
$	wc	"$	if ""'","'f$logical(""lsl$iwindow_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building IWINDOW"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$iwindow_building ""in_progress"""
$	wc	"$	inter =f$mode() .eqs. ""interactive"""
$	wc	"$	assign here lsl$cmniwin"
$!
$! where to find the iwindow poly library:
$	wc	"$	assign lsl$source_root:[imp.iwindow.poly] lsl$iwinpoly"
$!
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	renmes =""
$	mldbg  =""
$	fsw1   =""
$	lis    =""
$	kpcom  =""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop iwin_dbg "With Debug ? "
$	if .not. iwin_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then lis = "y"
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   iwin="t"
$	   obey="t"
$	   map ="t"
$	   alg ="t"
$	   clip="t"
$	   boun="t"
$	   copy="t"
$	   lcm ="t"
$	   goto a11
$!
$ A05:	   INQ/NOP IWIN		"Main Program ?		"
$	   INQ/NOP OBEY		"Command Interface ?	"
$	   INQ/NOP MAP		"Clip Map ?		"
$	   INQ/NOP ALG		"Line Clipping Algorithms ?	"
$	   INQ/NOP CLIP		"Area Clipping Algorithms ?	"
$	   INQ/NOP BOUN		"Get Bounds ?		"
$	   INQ/NOP COPY		"Copy point ?		"
$	   INQ/NOP LCM		"LITES2 guidance file ?	"
$	   write sys$output " "
$ a11:	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="iwindow"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="iwindowx"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 	if .not. mes then goto nomes
$		wc "$	newmsg iwin.mes/num=1211/name=iwin/pre=iwin__/par=for"
$		wc "$	@iwin.temp_com"
$nomes:	if .not. cld then goto fortonly
$		wc "$ 		adc iwindow.tmp=iwindow.cld"
$		wc "$ 		set command/object=iwindow_cld iwindow.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iwindow_cld"
$		wc "$ 		if ok then delete iwindow.tmp;*,adc.ide;*"
$		wc "$ 		if ok then purge/nolog iwindow_cld.obj"
$	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. iwin then goto a110
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iwindow''kpcom'=iwindow"
$	   	wc "$ 		fort''fsw1' iwindow"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iwindow"
$		wc "$ 		purge/nolog iwindow.obj"
$		if fsw1.eqs."" then goto a102
$ 		wc "$ 		purge/nolog iwindow.for"
$		goto a104
$ a102:		wc "$ 		delete/nolog iwindow.for;*"
$ a104:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a106
$ 		wc "$ 		if .not.inter .and. lis then delete/nolog iwindow.lis;*"
$		goto a108
$ a106:		wc "$ 		purge/nolog iwindow.lis"
$ a108:		wc "$ 		delete adc.ide;*"
$!
$ a110:	   if .not. obey then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc obey''kpcom'=obey"
$	   	wc "$ 		fort''fsw1' obey"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv obey"
$		wc "$ 		purge/nolog obey.obj"
$		if fsw1.eqs."" then goto a112
$ 		wc "$ 		purge/nolog obey.for"
$		goto a114
$ a112:		wc "$ 		delete/nolog obey.for;*"
$ a114:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a116
$ 		wc "$ 		if .not. inter .and. lis then delete/nolog obey.lis;*"
$		goto a118
$ a116:		wc "$ 		purge/nolog obey.lis"
$ a118:		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. map then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc clip_map''kpcom'=clip_map,iniatt"
$		wc "$ 		adc clip_map''kpcom'/ap=update_no,copy_tc"
$	   	wc "$ 		fort''fsw1' clip_map"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv clip_map"
$		wc "$ 		purge/nolog clip_map.obj"
$		if fsw1.eqs."" then goto a122
$ 		wc "$ 		purge/nolog clip_map.for"
$		goto a124
$ a122:		wc "$ 		delete/nolog clip_map.for;*"
$ a124:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a126
$ 		wc "$ 		if .not. inter .and. lis then delete/nolog clip_map.lis;*"
$		goto a128
$ a126:		wc "$ 		purge/nolog clip_map.lis"
$ a128:		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. alg then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc clip''kpcom'=addpts"
$		wc "$ 		adc clip''kpcom'/ap=clip,interp_z"
$		wc "$ 		adc clip''kpcom'/ap=read_points"
$	   	wc "$ 		fort''fsw1' clip"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv clip"
$		wc "$ 		purge/nolog clip.obj"
$		if fsw1.eqs."" then goto a132
$ 		wc "$ 		purge/nolog clip.for"
$		goto a134
$ a132:		wc "$ 		delete/nolog clip.for;*"
$ a134:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a136
$ 		wc "$ 		if .not. inter .and. lis then delete/nolog clip.lis;*"
$		goto a138
$ a136:		wc "$ 		purge/nolog clip.lis"
$ a138:		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. boun then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc get_bounds''kpcom'=get_bounds,osmh,mcemh"
$		wc "$ 		adc get_bounds''kpcom'/ap=os_proc_mh"
$		wc "$ 		adc get_bounds''kpcom'/ap=mce_proc_mh"
$		wc "$ 		adc get_bounds''kpcom'/ap=os_proc_md2"
$		wc "$ 		adc get_bounds''kpcom'/ap=mce_proc_md2"
$	   	wc "$ 		fort''fsw1' get_bounds"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv get_bounds"
$		wc "$ 		purge/nolog get_bounds.obj"
$		if fsw1.eqs."" then goto a142
$ 		wc "$ 		purge/nolog get_bounds.for"
$		goto a144
$ a142:		wc "$ 		delete/nolog get_bounds.for;*"
$ a144:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a146
$ 		wc "$ 		if .not. inter .and. lis then delete/nolog get_bounds.lis;*"
$		goto a148
$ a146:		wc "$ 		purge/nolog get_bounds.lis"
$ a148:		wc "$ 		delete adc.ide;*"
$!
$ a150:	   if .not. copy then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc copypt''kpcom'=copypt,chekra,stout"
$		wc "$ 		adc copypt''kpcom'/ap=diff_att"
$	   	wc "$ 		fort''fsw1' copypt"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv copypt"
$		wc "$ 		purge/nolog copypt.obj"
$		if fsw1.eqs."" then goto a152
$ 		wc "$ 		purge/nolog copypt.for"
$		goto a154
$ a152:		wc "$ 		delete/nolog copypt.for;*"
$ a154:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a156
$ 		wc "$ 		if .not. inter .and. lis then delete/nolog copypt.lis;*"
$		goto a158
$ a156:		wc "$ 		purge/nolog copypt.lis"
$ a158:		wc "$ 		delete adc.ide;*"
$!
$ a160:	   if .not. clip then goto a170
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc clip_area''kpcom'=clip_area,iwin_inside"
$!		wc "$ 		adc clip_area''kpcom'/ap=iwin_clipgfa"
$!		wc "$ 		adc clip_area''kpcom'/ap=iwin_cliparea"
$	   	wc "$ 		fort''fsw1' clip_area"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv clip_area"
$		wc "$ 		purge/nolog clip_area.obj"
$		if fsw1.eqs."" then goto a162
$ 		wc "$ 		purge/nolog clip_area.for"
$		goto a164
$ a162:		wc "$ 		delete/nolog clip_area.for;*"
$ a164:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a166
$ 		wc "$ 		if .not.inter .and. lis then delete/nolog clip_area.lis;*"
$		goto a168
$ a166:		wc "$ 		purge/nolog clip_area.lis"
$ a168:		wc "$ 		delete adc.ide;*"
$!
$ a170:	   if .not. lcm then goto lnkonly
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc lcm_posn''kpcom'=lcm_posn,lcm_close"
$	   	wc "$ 		fort''fsw1' lcm_posn"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv lcm_posn"
$		wc "$ 		purge/nolog lcm_posn.obj"
$		if fsw1.eqs."" then goto a172
$ 		wc "$ 		purge/nolog lcm_posn.for"
$		goto a174
$ a172:		wc "$ 		delete/nolog lcm_posn.for;*"
$ a174:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a176
$ 		wc "$ 		if .not. inter .and. lis then delete/nolog lcm_posn.lis;*"
$		goto a178
$ a176:		wc "$ 		purge/nolog lcm_posn.lis"
$ a178:		wc "$ 		delete adc.ide;*"
$!
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' -"
$	   	wc "		iwindow,iwindow_cld,obey,clip_area, -"
$	   	wc "		clip_map,clip,get_bounds,copypt,lcm_posn, -"
$		wc "		iwin.promsg_obj, -"
$	   	wc "		lsl$iwinpoly:poly/lib, -"
$		wc "		lsl$library:osmhlib/lib, -"
$	   	wc "		lsl$library:frtshr/opt, -"
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$	   	wc "$ 		purge/nolog iwindow*.exe"
$	   	wc "$ 		purge/nolog iwindow*.map"
$!
$ nolnk:
$		wc "$ 		iwindowex:"
$		wc "$ 		deass/group lsl$iwindow_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto iwindowex
$	on control_y then goto iwindowex
$	close comfil
$	purge/nolog iwindowbat.com
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$iwindow_building
$	bat iwindowbat.com
$	goto iwindowx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto iwindowex
$	deass/group lsl$iwindow_building
$	@iwindowbat.com
$	goto iwindowx2
$!
$ iwindowex:
$	deass/group lsl$iwindow_building
$!
$ iwindowx2:
$	if ver then set verify
$!
