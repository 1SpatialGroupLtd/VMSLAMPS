$	sqb fadt_batch*
$	inq/nop ans "Start at ? "
$	num = f$integer(ans)
$ do_delete:
$	on warning then continue
$	set verify
$	delete/entry='num' fadt_batch
$	set noverify
$	num = num + 1
$	goto do_delete
