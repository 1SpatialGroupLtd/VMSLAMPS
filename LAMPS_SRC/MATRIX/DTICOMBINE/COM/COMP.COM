$ vvv=f$verify(0)
$ if p1 .eqs. "" then inq/nop p1 "File ?"
$ ass lsl$source_root:[matrix.service] lsl$matrixssys
$ ass lsl$source_root:[dtmcreate.service] lsl$dtmcreatesys
$ ass lsl$source_root:[matrix.dticombine] lsl$cmndticombine
$ set verify
$ adc 'p1'/co='p1'
$ fort/deb/noopt/lis/check=(bound,overflow) 'p1'
$ pvv 'p1'
$ purge/nolog 'p1'.for,'p1'.obj','p1'.lis
$ if .not.vvv then set noverify
