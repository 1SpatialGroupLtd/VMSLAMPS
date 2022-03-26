$	if p1.eqs.""
$	then
$	  ws "no files specified"
$	else
$	  squash == "$lsl$source_root:[lites2.lcmsquash.source]lcmsquash"
$	  squash /expl/list/diag 'p1'
$	endif
