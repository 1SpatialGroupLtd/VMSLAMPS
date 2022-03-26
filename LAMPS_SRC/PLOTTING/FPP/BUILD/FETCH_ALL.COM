$! fetch all FPP sources from the CMS
$! (except the obj group, which only contains MAPIDs)
$ sd lsl$fpp_root:[000000]
$ CMS
fetch/nolog cmn /output=[cmn] ""
fetch/nolog com /output=[com] ""
fetch/nolog dev /output=[dev] ""
fetch/nolog hlp /output=[hlp] ""
fetch/nolog mar /output=[mar] ""
fetch/nolog src /output=[src] ""
$ exit
