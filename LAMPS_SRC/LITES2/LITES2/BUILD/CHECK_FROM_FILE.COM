$! To check a series of disk files against the CMS
$! Expects P1 = filespec (optionally wildcarded)
$!         P2 (optionally) = a CMS class or generation number
$!     and P3 (optionally) = D to delete files
$!
$ set noon
$ if P2.nes."" then P2 = "="+P2
$ file = f$search("")
$ next_file:
$ file = f$search(P1)
$ if file.eqs."" then exit
$ name = f$parse(file,,,"NAME","SYNTAX_ONLY")
$ type = f$parse(file,,,"TYPE","SYNTAX_ONLY")
$ if type.eqs.".DIR" then goto next_file
$ element = name+type
$ CMS diff/nooutput/nolog 'element'/gen'P2' 'file'
$ if $severity.ne.1
$ then
$    if $severity.eq.3
$    then
$       write sys$output "*** File ",file," differs from CMS"
$    else
$       write sys$output "*** Problem with file ",file
$    endif
$    write sys$output "********************************************************************************"
$ else
$    if P3.eqs."D" .or. P3.eqs."d"
$    then
$       delete 'file'
$    endif
$ endif
$ goto next_file
