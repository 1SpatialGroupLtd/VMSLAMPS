$! gets rid of flowline acceptance test database
$ set noon
$ ass lsl$public_root:[flowline.accept] lsl$fln_database
$ @lsl$com:delflow
$ set noverify
