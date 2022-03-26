$! command file to check differences between CMS file and actual file
$! Expects P1 = element
$!         P2 = group
$!         P3 (optionally) = class
$!         P4 (optionally) = D to delete files
$!
$ set noon
$ if P3.nes."" then P3="="+P3
$ file = "LSL$LITES2_ROOT:["+P2+"]"+P1
$ if f$search(file).eqs.""
$ then
$    write sys$output "File ",file," does not exist"
$    exit
$ endif
$ CMS diff/nooutput/nolog 'P1'/gen'P3' 'file'
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
$    if P4.eqs."D" .or. P4.eqs."d"
$    then
$       delete 'file';0
$    endif
$ endif
