!
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
filein lsl$public_root:[dtmprepare.accept]dtmprepare_accept_i3d.start_iff
terrain lsl$public_root:[dtmprepare.accept]dtmprepare_accept_i3d.terrain_iff
fileout here:dtmprepare_accept_i3d_intersected1.iff
set touch_tolerance 10
enable mode intersect
!go
