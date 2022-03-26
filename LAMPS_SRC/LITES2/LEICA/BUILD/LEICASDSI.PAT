lites2leicasdsishr
! Change the QIO read timeout from 0 to 1, otherwise it nearly always
! times out, and then waits for 0.1sec before trying again
set modu p2pl00,p2pl01,p2pl39
d/long vax_send+155=1
set mode ins
! This patch is to remove calls to Pascal OPEN and REWRITE in
! SUP_START_USER_PROGRAM. Calls access violate because address
! of arguments is wrong in shareable image. Calls are in any
! case not used.
d/ins sup_start_user_program+0cb="brb sup_start_user_program+0ec"
! Return from track call without bothering to read the status
d/ins p2tm_p2_track_with_model_coordi+06e="ret"
u
