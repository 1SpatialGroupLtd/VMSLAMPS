$	   adc		'p1'/co='p1'
$	   fortran'p2'	'p1'
$	   pvv		'p1'
$	   delete	adc.ide;*
$	   purge	'p1'.OBJ
$	   if p2.eqs."" then delete 'p1'.FOR;*
$	   if p2.nes."" then purge  'p1'.FOR
