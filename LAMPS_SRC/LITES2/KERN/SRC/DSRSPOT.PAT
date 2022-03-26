lites2dsrspotshr
! This patch is to remove calls to Pascal OPEN and REWRITE in
! SUP_START_USER_PROGRAM. Calls access violate because address
! of arguments is wrong in shareable image. Calls are in any
! case not used.
set modu p2pl00
set mode ins
d/ins sup_start_user_program+64="brb sup_start_user_program+85"
u
