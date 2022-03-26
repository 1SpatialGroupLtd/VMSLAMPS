$	ver:='f$verify(0)'
$	if p1 .nes. "?" then goto nohlp
$	type sys$input:
Available switches are:

 D - Compile with DEBUG
 T - Link with testing CMDLIB
$	goto tidy_ver
$!
$nohlp:	deb=""
$	if f$locate("D",p1) .lt. f$length(p1) then deb="/debug"
$	cmdlib="lsl$library:cmdlib/lib,"
$	if f$locate("T",p1) .lt. f$length(p1) then cmdlib=-
					"cmdlib/lib,lsl$library:"
$	set verify
$	adc cvt=cvt
$	fortran'deb' cvt
$	pvv cvt
$	macro cvtcom
$	link/map'deb' cvt,cvtcom,'cmdlib'violib/lib
$	xxx:='f$verify(0)'
$	cvtt=="$''f$logical("here")'cvt"
$	sh sym cvtt
$grut:	set verify
$	purge/log
$	xxx:='f$verify(0)'
$tidy_ver: if ver then set verify
