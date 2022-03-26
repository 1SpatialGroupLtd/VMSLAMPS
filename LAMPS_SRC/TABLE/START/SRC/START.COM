$!
$! Process START, or STARTMON
$!
$! set up where we keep our common files
$!
$	define cmn lsl$source_root:[table.shared]
$!
$	deb := ""
$	ldeb:= ""
$	if p1 .eqs. "D" then deb := "/debug"
$	if p1 .eqs. "N" then deb := "/debug/noopt"
$	if deb.nes. ""  then ldeb:= "/debug"
$!
$	write sys$output " "
$	inquire main  "Compile startmon                             "
$	inquire marit "Assemble macro routines                      "
$	inquire check "Compile other routines (chkprc,is_alpha_axp) "
$!
$	set verify
$	if marit
$	then
$	   macro'ldeb' checksym
$	endif
$!
$	if check
$	then
$	   adc check=chkprc,is_alpha_axp
$	   fort'deb' check
$	   pvv check
$	   delete adc.ide;*
$	   if deb.eqs."" then delete check.FOR;*
$	endif
$!
$	if main
$	then
$	   adc startmon=startmon
$	   fort'deb' startmon
$	   pvv startmon
$	   delete adc.ide;*
$	   if deb.eqs."" then delete startmon.FOR;*
$	endif
$!
$	link/map/notrace'ldeb' startmon,checksym,check,-
			lsl$library:lsllib/lib
$!
$	purge/log *.*
$	exit
