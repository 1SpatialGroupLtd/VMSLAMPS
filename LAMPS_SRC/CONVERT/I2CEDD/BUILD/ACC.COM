$	savver = f$verify(1)
$!
$	def/user sys$input sys$command
$	i2cedd/diag/frt=cedd -
		lsl$if:iffcedd_accept_input.iff -
		lsl$if:iffcedd_accept_text.txt
$!
$	def/user sys$input sys$command
$	cedd2i/diag/frt=cedd -
		lsl$if:iffcedd_accept_text.txt -
		lsl$if:iffcedd_accept_output.iff
$!
$	idifference iffcedd_accept_input iffcedd_accept_output_0001
$!
$	savver = f$verify(savver)
