$! To check a group of CMS files against disk
$! Expects P1 = CMS group, P2 (optionally) = D to delete files
$!
$ set noon
$ if P1.eqs.""
$ then
$    write sys$output "Parameter 1 should be a CMS group name"
$    exit
$ endif
$ olddir = f$environment("DEFAULT")
$ set def lsl$source_root:[plotting.fpp]
$ if f$search("cms_temp.com").nes."" then delete cms_temp.com;*
$ CMS show elem 'P1' /output=cms_temp.com /format="$ @check_diff #e ''P1' ''P2'"
$ if f$search("cms_temp.com").nes.""
$ then
$    @cms_temp
$    delete cms_temp.com;*
$ endif
$ set def 'olddir'
$ exit
