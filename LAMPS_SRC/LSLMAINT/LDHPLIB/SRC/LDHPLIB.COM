$! Build LDHPLIB
$ adc ldhplib=ldhplib
$ fort ldhplib
$ pvv ldhplib
$ libr/cre ldhplib ldhplib
$ libr/comp ldhplib
$ set file/trunc ldhplib.olb
$ delete adc.ide;*,ldhplib.for;*,ldhplib.obj;*
$ purge/log
