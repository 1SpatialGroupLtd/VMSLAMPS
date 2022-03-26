$!
$! command file to build LSLGOTHICSHR for AXP Alpha or VAX
$!
$	arch_name = f$getsyi("arch_name")
$	if arch_name .eqs. "Alpha"
$	then
$	   @lsl$source_root:[lites2.geom]geom_axp.com
$	else
$	   @lsl$source_root:[lites2.geom]geom_vax.com
$	endif
$!
