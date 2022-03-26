!
!			COMMAND FILE TO RUN I3D FLOW MODE
!				ESTHER S WHITTON
!				    01:08:94
!
!			     START THE PROGRAMME
!
!I3D
!
!				SPECIFY INPUT
!
!filein here:small_trial_intersect
!
!filein here:i3d_flow
!
filein here:i3d_test
lookup here:dtmprepare.dat
!
!			SPECIFY PARAMETERS/FEATURE CODES
!
enable mode flow
enable diagnostics
!set arrow_fc 69
!set box_fc 731
set max_interval 15
!
!				SPECIFY OUTPUT
!
checkplot here:test_flow 
lites here:small_trial_flow.lcm  
fileout here:small_trial_flow
!
!		
!
!go
!
