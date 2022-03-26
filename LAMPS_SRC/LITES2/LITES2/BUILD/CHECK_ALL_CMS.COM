$! To check a all LITES2 groups in CMS files against disk
$! Expects P1 (optionally) = CMS class
$! Expects P2 (optionally) = D to delete files
$!
$ set noon
$ olddir = f$environment("DEFAULT")
$ set def lsl$source_root:[lites2.lites2]
$ @check_from_cms CMN "''P1'" 'P2'
$ @check_from_cms COM "''P1'" 'P2'
$ @check_from_cms EXE "''P1'" 'P2'
$ @check_from_cms HLP "''P1'" 'P2'
$ @check_from_cms HRD "''P1'" 'P2'
$ @check_from_cms MAR "''P1'" 'P2'
$ @check_from_cms MOTIF "''P1'" 'P2'
$ @check_from_cms OBJ "''P1'" 'P2'
$ @check_from_cms SIG6000 "''P1'" 'P2'
$ @check_from_cms SRC "''P1'" 'P2'
$ @check_from_cms TEK4100 "''P1'" 'P2'
$ @check_from_cms TEK_ARGS "''P1'" 'P2'
$ @check_from_cms UIS "''P1'" 'P2'
$ set def 'olddir'
$ exit
