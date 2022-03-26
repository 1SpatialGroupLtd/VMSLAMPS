$! File to create the FLOWLINE database all the fields and relations
$!
$ oper = f$getjpi("","USERNAME")
$ work = f$trnlnm("lsl$fln_workstation")
$ if work.eqs.""
$ then
$   write sys$output "LSL$FLN_WORKSTATION is not defined"
$   exit
$ endif
$!
$! write temporary command file to authorise operator and workstation
$ open/write cmdfil sys$scratch:flowline_db_authorise.rdo
$ wc = "write cmdfil"
$ wc "store o in operator using"
$ wc " o.operator_id = ""''oper'"""
$ wc "end_store"
$ wc "store w in workstation using" 
$ wc " w.workstation_id = ""''work'"""
$ wc "end_store"
$ close cmdfil
$!
$ set verify
$run sys$system:rdo
define database "lsl$fln_database:flowline".
sho database
@lsl$com:flowline_relations
@sys$scratch:flowline_db_authorise
commit
sho relations
finish
exit
$ set noverify
$ delete/noconfirm sys$scratch:flowline_db_authorise.rdo;*
$!
