$inquire comp "Compile"
$inquire mar "Command table"
$inquire lnk "Link"
$inquire dbg "with debug"
$set verify
$if .not.comp then goto nocomp
$ccsw=""
$if dbg then ccsw="/debug/noopt"
$cc'ccsw' uilmenus
$adc uilmen_cld.tmp=uilmen_cld.cld
$set command/object=uilmen_cld uilmen_cld.tmp
$pvv uilmen_cld
$delete uilmen_cld.tmp;*,adc.ide;*
$nocomp:
$if .not.mar then goto nomar
$macro uilcmd
$nomar:
$if .not.lnk then goto nolnk
$lnsw=""
$if dbg then lnsw="/debug"
$link/exe=uilmenusmotif'lnsw' -
	uilmenus,uilcmd,uilmen_cld,lsl$library:lslshr/opt,-
	sys$input:/opt
sys$share:decw$dxmlibshr/shareable ! we don't use DEC Motif extensions
sys$share:decw$xmlibshr/shareable
sys$share:vaxcrtl/shareable
$nolnk:
$pl	! 'f$verify(0)
