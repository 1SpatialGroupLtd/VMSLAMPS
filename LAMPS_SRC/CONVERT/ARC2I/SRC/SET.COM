$ set verify
$!
$! To set up testing image :
$!
$ arc2i == "$lsl$source_root:[convert.arc2i]arc2i.exe"
$ si here
$!
$!
$ set noverify
