$inquire comp "Compile"
$inquire mar "Command table"
$inquire lnk "Link"
$inquire dbg "with debug"
$set verify
$if .not.comp then goto nocomp
$ccsw=""
$if dbg then ccsw="/debug/noopt"
$cc/stan=vaxc'ccsw' uilmenus/obj=uilmenus12
$adc uilmen_cld.tmp=uilmen_cld.cld
$set command/object=uilmen_cld12 uilmen_cld.tmp
$pvv uilmen_cld12
$delete uilmen_cld.tmp;*,adc.ide;*
$nocomp:
$if .not.mar then goto nomar
$macro uilcmd/obj=uilcmd12
$nomar:
$if .not.lnk then goto nolnk
$lnsw=""
$if dbg then lnsw="/debug"
$link/exe=uilmenusmotif12'lnsw' -
	uilmenus12,uilcmd12,uilmen_cld12,lsl$library:lslshr/opt,-
	sys$input:/opt
sys$share:decw$dxmlibshr12/shareable ! we don't use DEC Motif extensions
sys$share:decw$xmlibshr12/shareable
!sys$share:vaxcrtl/shareable
sys$share:decc$shr/shareable
$nolnk:
$pl	! 'f$verify(0)
