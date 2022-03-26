$! fetch all LSLLIB sources from the CMS
$! P1 (optional) = CMS class to fetch
$ ws = "write sys$output"
$ if p1.nes."" then p1 = "/generation="+p1
$ CMS fetch/nolog lsllib.com'p1' ""
$ groups = "commands,errors,expc,filename,iff,init,io,lsldcl,magtape,"+ -
	   "numbers,share,sort,string,system,txtc"
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
$ CMS fetch/nolog 'p1''p2' /output=[.'p1'] ""
$ return
$ endsubroutine
