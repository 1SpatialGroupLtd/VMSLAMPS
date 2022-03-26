!
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
filein lsl$public_root:[dtmprepare.accept]dtmprepare_accept_i3d.intersected2_iff
fileout here:dtmprepare_accept_i3d_interpolated.iff
checkplot here:dtmprepare_accept_i3d_checkplot.iff
lites here:dtmprepare_accept_i3d_heightnodes.lcm
enable diagnostics
enable mode interpolate
set symbol_scale 0.5
set arrow_fc 101
set box_fc 102
set max_interval 70.0
set clip_tolerance 150
!go
