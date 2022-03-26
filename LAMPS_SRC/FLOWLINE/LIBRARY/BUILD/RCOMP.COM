$ vvv=f$verify(0)
$ rfort:=$sys$system:rdbpre/fortran
$ if p1 .eqs. "" then inq/nop p1 "File ?"
$ set verify
$ adc 'p1'.rfo/co='p1'
$ rfort/deb/noopt/lis/check=(bound,overflow) 'p1'
$ purge/nolog 'p1'.for,'p1'.obj','p1'.lis
$ library/replace/log  flowline 'p1'
$ if .not.vvv then set noverify
