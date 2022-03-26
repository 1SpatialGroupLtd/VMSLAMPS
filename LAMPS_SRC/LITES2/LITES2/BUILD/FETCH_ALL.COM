$! fetch all LITES2 sources from the CMS
$! (except the obj group, which only contains MAPIDs)
$! P1 (optional) = CMS class to fetch
$ ws = "write sys$output"
$ sd lsl$lites2_root:[000000]
$ if p1.nes."" then p1 = "/generation="+p1
$ groups = "cmn,com,exe,hlp,mar,src,hrd,motif,sig6000,tek4100,tek_args,uis"
$ n = 0
$ next:
$   group = f$element(n,",",groups)
$   if group.eqs."," then goto exit
$   call fetch 'group' 'p1'
$   n = n+1
$   goto next
$!
$ exit: exit
$!
$fetch: subroutine
$ ws "Fetching group ",p1,p2
$ CMS fetch/nolog 'p1''p2' /output=['p1'] ""
$ return
$ endsubroutine
