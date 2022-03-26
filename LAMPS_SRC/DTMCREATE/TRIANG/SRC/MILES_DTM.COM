$ @lsl$com:dtmcreateini
$ TRIANG
fileout lsl$bureau_root:[bureau.mobile]mobile_triang
enable graphics
enable diagnostics
max 60000
win -10 -10 31962.699 20061.40
zlimits 0 250
disable square
assign CLIFF_fc 2
filein lsl$bureau_root:[bureau.mobile]mobile_triang
go
$ trider
filein lsl$bureau_root:[bureau.mobile]mobile_triang
enable diagnostics
zlimits 0 250
go
$ TRIGRID
filein lsl$bureau_root[bureau.mobile]mobile_triang
enable diagnostics
window 0 0  31952.699 20051.40
sidelength 100 100
fileout mobile_trigrid
go
