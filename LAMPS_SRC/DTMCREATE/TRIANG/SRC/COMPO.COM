$ vvv=f$verify(0)
$ if p1 .eqs. "" then inq/nop p1 "File ?"
$ ass lsl$source_root:[dtmcreate.service.src] lsl$dtmcreatesys
$ ass lsl$source_root:[dtmcreate.triang.src] lsl$cmntriang
$ set verify
$ adc 'p1'/co='p1'
$ fort 'P1'
$ ok=$status
$ if ok then pvv 'p1'
$ if ok then librarian/replace/log triang_fortran_sources 'p1'
$ purge/nolog 'p1'.for,'p1'.obj'
$ if .not.vvv then set noverify
