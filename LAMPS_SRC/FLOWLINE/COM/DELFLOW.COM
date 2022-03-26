$! gets rid of flowline database
$ 
$ set noon
$ set verify
$ set protection = (Owner:rwed) LSL$FLN_DATABASE:flowline.rdb, -
LSL$FLN_DATABASE:flowline.snp
$ delete lsl$fln_database:flowline.rdb;*,lsl$fln_database:flowline.snp;*
$ mcr dmu
delete /all flowline
exit
$ set noverify
