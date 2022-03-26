$ ver = f$verify(0)
$ set verify
$ MACRO DPSDUMVEC
$ LINK/SHARE/EXE=DPSDUMMYSHR/MAP=DPSDUMMYSHR/FULL SYS$INPUT:/OPT
!
! Place the transfer vector first in its own cluster
cluster=TRANSFER,,,DPSDUMVEC.OBJ
!
! Set the global section match parameters (major id., minor id.)
gsmatch=lequal,2,9
!
$ purge/log
$!
$! 'f$verify(ver)
