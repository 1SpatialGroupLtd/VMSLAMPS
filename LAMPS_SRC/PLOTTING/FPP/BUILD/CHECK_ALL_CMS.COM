$! To check a all FPP groups in CMS files against disk
$! Expects P1 (optionally) = D to delete files
$!
$ set noon
$ olddir = f$environment("DEFAULT")
$ set def lsl$source_root:[plotting.fpp]
$ @check_from_cms CMN 'P1'
$ @check_from_cms COM 'P1'
$ @check_from_cms DEV 'P1'
$ @check_from_cms HLP 'P1'
$ @check_from_cms MAR 'P1'
$ @check_from_cms OBJ 'P1'
$ @check_from_cms SRC 'P1'
$ set def 'olddir'
$ exit
