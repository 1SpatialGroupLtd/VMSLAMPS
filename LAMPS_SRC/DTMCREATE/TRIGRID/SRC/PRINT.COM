$ 	date=""
$ 	inq/nop everything "Print everything? [default NO] "
$ 	if everything then goto noquest
$ 	write sys$output "OK, incremental print required ..."
$ 	inq/nop date "Print all updated sources since when? [default TODAY] "
$ noquest:
$ 	options=""
$ 	if date.eqs."" then date="TODAY"
$ 	if .not.everything then options="/since="+date
$ 	print'options' *.src;,*.mar;,*.mes;,*.par;,*.opt;,trigrid.com;
