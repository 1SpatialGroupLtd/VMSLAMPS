$deb = ""
$if p1 .eqs. "D" then deb = "/debug/noopt"
$fort'deb dtiinfo.src
$if p1 .eqs. "D" then deb = "/debug"
$link'deb dtiinfo,lsl$library:dtilib/l,lsllib/l
$delete dtiinfo.obj;
