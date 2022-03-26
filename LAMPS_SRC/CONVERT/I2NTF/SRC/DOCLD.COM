$	   adc		'p1'.tmp='p1'_cld.cld
$	   set command/object='p1'_cld 'p1'.tmp
$	   pvv		'p1'_cld
$	   delete	'p1'.tmp;*
$	   purge	'p1'_cld.*
