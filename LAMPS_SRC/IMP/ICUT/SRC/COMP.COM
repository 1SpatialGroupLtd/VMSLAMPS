$ define lsl$cmnicut lsl$source_root:[imp.icut]
$ COMPILE:SUBROUTINE
$  	vvv=f$verify(0)
$ 	if p1 .eqs. "" then inq/nop p1 "File ?"
$ 	set verify
$ 	adc 'p1'/co='p1'
$ 	fort/deb/noopt/lis/check=(bound,overflow) 'p1'.for
$ 	pvv 'p1'
$ 	purge/nolog 'p1'.for,'p1'.obj','p1'.lis
$ 	if .not.vvv then set noverify
$	delete adc.ide;
$ ENDSUBROUTINE
$ CALL COMPILE "''p1'"
