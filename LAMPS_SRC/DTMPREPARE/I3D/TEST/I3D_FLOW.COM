$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1995-04-24 13:24:54.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
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
