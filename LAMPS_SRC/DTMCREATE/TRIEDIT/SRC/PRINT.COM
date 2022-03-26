$ ver_stat=f$verify(0)
$ type sys$input

+----------------------------------------------------------------------------+
|                                                                            |
|   P R I N T    C O M M A N D    P R O C E D U R E   F O R  T R I E D I T   |
|                                                                            |
+----------------------------------------------------------------------------+

$ 	date=""
$ 	inq/nop everything "Print everything? [default NO] "
$ 	if everything then goto noquest
$ 	write sys$output "OK, incremental print required ..."
$ 	inq/nop date "Print all updated sources since when? [default TODAY] "
$ noquest:
$ 	options=""
$ 	if date.eqs."" then date="TODAY"
$ 	if .not.everything then options="/since="+date
$ set verify
$ 	print'options' *.src;,*.cmn;,*.mar;,*.mes;,*.par;,*.opt;,triedit.com;
$ if ver_stat.ne.1 then set noverify
