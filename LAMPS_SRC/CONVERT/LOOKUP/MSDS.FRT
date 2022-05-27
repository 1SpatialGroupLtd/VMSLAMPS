!
! MSDS Feature Representation Table			RWR	15-FEB-1990
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! FC's for MSDS primitives
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!       FC    	GT    	COL   	WID   	SIZ   	SC    	
FRT	0	1     	1    	0	0.0	0   	! unset linear
FRT	1	7     	8    	0	0.1	101   	! node    (symbol)
FRT	2	1	8	0	0	0	! edge
FRT	3	7     	9    	0	0.1	103	! face    (symbol)
!
FRT	4	7     	6    	0	0.3	104   	! point   (symbol)
FRT	5	1     	1    	0	0	0   	! line
FRT	6	12	7	0	0	-1	! area    (filled)
!
FRT	7	1	9	0	0	0	! face (boundary)
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! FC's for graphical IFF representation based on MSDS feature names
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
!    FC  GT    COL   WID   SIZ   SC    	
! A
FRT  100 12    1     0     0     101   0     0   ! ADMIN_AREA_A
FRT  101 12    1     0     2.0   102   0     0   ! AGRICULT_A	
FRT  102 1     1     0     1.0   5     0     0   ! AIRFIELD_L	
FRT  103 12    1     0     2.0   103   0     0   ! AIRFIELD_A
FRT  104 12    1     0     0     104   0     0   ! AMEN_AREA_A
! B
!    FC  GT    COL   WID   SIZ   SC    	
FRT  140 12    9     0     2.5   105   0     0   ! BAMBOO_A	
FRT  141 12    8     0     2.5   106   0     0   ! BARE_GND_A	
FRT  143 12    9     0     1.0   106   0     0   ! BLT_U_AREA_A
FRT  144 1     1     0     0     0     0     0   ! BOUNDARY_L	
FRT  145 7     10    .5    4.0   145   0     0   ! BRIDGE_P (unorientated)
FRT  146 1     8     0     0     0     0     0   ! BRIDGE_L
FRT  147 7     8     0     2.0   160   0     0   ! BRIDGE_SUP_P
FRT  148 12    1     0     0     105   0     0   ! BRUSH_A		
FRT  149 7     1     0     2.0   160   0     0   ! BUILDING_P
FRT  150 12    11    0     1.0   106 2048    0   ! BUILT_UP_A	
FRT  151 8     10    .5    4.0   145   0     0   ! BRIDGE_P (orientated)
! 
!    FC  GT    COL   WID   SIZ   SC    	
FRT  180 12    7     0     0    -1     0     0   ! CANAL_A
FRT  181 1     7     0     0     0     0     0   ! CANAL_L
FRT  182 1     1     0     0     0     0     0   ! CART_TRACK_L	
FRT  183 7     1     0     2.0   160   0     0   ! CHIMNEY_P
FRT  184 12    6     0     0     102   0     0   ! CLEARING_A	
FRT  185 1     1     0     0     0     0     0   ! CLIFF_ESC_L
FRT  187 1     7     0     0     0     0     0   ! COASTLINE_L
FRT  188 7     1     0     2.0   160   0     0   ! COMM_TOWER_P
FRT  189 7     0     0     0     0     0     0   ! CONSTRICT_P	
FRT  190 1     1     0     0     0     0     0   ! CONST_LINE_L
FRT  191 1     11    0     0     0     0     0   ! CONTOUR_L
FRT  192 1     11    0     0     0     0     0   ! CONTOUR3L
FRT  193 1     11    0     0     0     0     0   ! CONTOUR2L
FRT  194 1     11    0     0     0     0     0   ! CONTOUR1L
FRT  195 1     1     0     0     0     0     0   ! CONTOUR4L
FRT  196 7     1     0     2.0   160   0     0   ! CRANE_P
FRT  197 7     10    0     2.0   0     0     0   ! CROSSING_P	
FRT  198 1     1     0     0     11    0     0   ! CUTTING_L
FRT  199 1     0     0     0     0     0     0   ! CUT_L		
! D
!    FC  GT    COL   WID   SIZ   SC    	
FRT  220 1     8     2.0   0     0     0     0   ! DAM_L		
FRT  221 1     8     2.0   0     0     0     0   ! DAM_WEIR_L
FRT  222 1     9     0     0     0     0     0   ! DEPRESSION_L	
FRT  223 7     0     0     0     0     0     0   ! DRIVE_OFF_P	
FRT  225 12    0     0     0   103     0     0   ! DEPRESSION_A
! E
!    FC  GT    COL   WID   SIZ   SC    	
FRT  260 1     1     0     0     11    0     0   ! EMBANKMENT_L
FRT  261 1     1     0     0     0     0     0   ! ESCARPMENT_L	
! F
!    FC  GT    COL   WID   SIZ   SC    	
FRT  300 1     1     0     0     0  2048     0   ! FENCE_L		
FRT  301 1     1     0     0     0     0     0   ! FILL_L		
FRT  302 7     7     1.5   4.0   145   0     0   ! FORD_P		
FRT  303 12    6     0     2.0   -2 2048     0   ! FOREST_A - coniferous
FRT  304 12    6     0      0    -1  		 ! FOREST_A - deciduous
! G
!    FC  GT    COL   WID   SIZ   SC    	
FRT  340 12    1     0     3   102     0     0   ! GRASSLAND_A	
FRT  341 12    1     0    10   103     0     0   ! GROUND_SUR_A
! H
!    FC  GT    COL   WID   SIZ   SC    	
FRT  380 1     6     0     0     0     0     0   ! HEDGEROW_L	
! I
!    FC  GT    COL   WID   SIZ   SC    	
! J
!    FC  GT    COL   WID   SIZ   SC    	
! K
!    FC  GT    COL   WID   SIZ   SC    	
! L
!    FC  GT    COL   WID   SIZ   SC    	
FRT  540 12    7     0     0     -1    0     0   ! LAKE_POND_A
FRT  541 7     7     0     0     0     0     0   ! LOCK_P		
! M
!    FC  GT    COL   WID   SIZ   SC    	
FRT  580 12    7     0     0    105    0     0   ! MARSH_BOG_A	
FRT  581 12    7     0     0    106    0     0   ! MAR_SWAMP_A
FRT  582 12    7     0     0     -1    0     0   ! MOAT_A		
FRT  583 7     1     0     2.0   160   0     0   ! MONUMENT_P
! N
!    FC  GT    COL   WID   SIZ   SC    	
! O
!    FC  GT    COL   WID   SIZ   SC    	
FRT  660 7     8     0     0     0     0     0   ! OBSTRUCT_P	
FRT  661 12    7     0     0     -1    0     0   ! OPEN_WATER_A	
! P
!    FC  GT    COL   WID   SIZ   SC    	
FRT  700 7     1     0     0     0     0     0   ! PARKING_P	
FRT  701 1     1     0     0     0     0     0   ! PIPELINE_L	
FRT  702 1     8     0     0     0     0     0   ! POWERLINE_L
FRT  703 12    1     0     0    102    0     0   ! POWER_PL_A
FRT  704 7     8     0     2.0   2     0     0   ! PYLON_P
! Q
!    FC  GT    COL   WID   SIZ   SC    	
! R
!    FC  GT    COL   WID   SIZ   SC    	
FRT  780 1     10    0.5   0     20    0     0   ! RAILWAY_L
FRT  782 12    1     0     0    103    0     0   ! RAILYARD_A
FRT  783 1     0     0     0     0     0     0   ! RAIL_BRIDG_L	
FRT  784 7     10   .5     4   145     0     0   ! RAIL_BRIDG_P	 (unorientated)
FRT  785 12    7     0     0   104     0     0   ! RESERVOIR_A
FRT  786 1     7     0     0     0     0     0   ! RIVER_STRM_L
FRT  788 7     10   .5     4.0 145     0     0   ! ROAD_BRIDG_P	
FRT  789 1     1     0     0     0     0     0   ! ROAD_BRIDG_L	
FRT  790 1     8     1.5   0     0     0     0   ! ROAD_L
FRT  792 1     1     2     0     0     0     0   ! RUNWAY_L
FRT  793 8     10   .5     4   145     0     0   ! RAIL_BRIDG_P	 (orientated)
! S
!    FC  GT    COL   WID   SIZ   SC    	
FRT  820 7     0     0     0     0     0     0   ! SHARP_CUR_P	
FRT  822 1     7     0     0     0     0     0   ! SHORELINE_L
FRT  823 1     0     0     0     0     0     0   ! SINGLE_FIL_L	
FRT  824 1     0     0     0     0     0     0   ! SINGLE_CUT_L	
FRT  825 12    6     0     4   105     0     0   ! SLOPE_A		
FRT  826 12    6     0     2   105     0     0   ! SLOPE_B		
FRT  827 12    9     0     4   105     0     0   ! SLOPE_C		
FRT  828 12    9     0     2   105     0     0   ! SLOPE_D		
FRT  829 12    8     0     2   105     0     0   ! SLOPE_E		
FRT  830 12    8     0     1   105     0     0   ! SLOPE_F		
FRT  831 12    8     0     0.1 105     0     0   ! SLOPE_G		
FRT  832 12    8     0     0   106     0     0   ! SOIL_A		
FRT  833 7     1     0     2.0 160     0     0   ! STEEPLE_P
FRT  834 1     7     0     0     0     0     0   ! STREAM_L	
FRT  835 12    7     0     0   101     0     0   ! SWAMP_A		
! T
!    FC  GT    COL   WID   SIZ   SC    	
FRT  860 12    0     0     0     102   0     0   ! TAILINGS_A	
FRT  861 7     1     0     2.0   160   0     0   ! TANK_P
FRT  862 7     1     0     3.0   160   0     0   ! TOWER_P
FRT  863 12    6     0     4.0   -2    0     0   ! TREES_A
FRT  864 1     1     0     0     0     0     0   ! TUNNEL_L
FRT  870 1     1     0     0     0     0     0   ! Topology line ???? 
! U
!    FC  GT    COL   WID   SIZ   SC    	
! V
!    FC  GT    COL   WID   SIZ   SC    	
FRT  900 12    6     0     0    101    0     0   ! VINEYARD_A	
! W
!    FC  GT    COL   WID   SIZ   SC    	
FRT  920 12    7     0     0    102    0     0   ! WETLANDS_A	
FRT  921 1     0     0     0     0     0     0   ! WINDBREAK_L	
! X
!    FC  GT    COL   WID   SIZ   SC    	
! Y
!    FC  GT    COL   WID   SIZ   SC    	
! Z
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!    FC  GT    COL   WID   SIZ   SC    	
FRT  997   1    12    1.0    0     0     0     0   ! 10 Km grid line
FRT  998   1    12     0     0     0     0     0   ! Minor grid line
FRT  999   1     1     0     0     0     0     0   ! MERGED FEATURE 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! SYMBOL COMPONENTS - the SCT which defines symbol components
!
!   	FC	GT	Colour	Width	Size	SC	Description
SCT	0	1	0	0	0	0	unknown - linear
SCT	1	1	0	0	0	0	line
SCT	2	2	0	0	0	0	clockwise arc
SCT	3	3	0	0	0	0	anticlockwise arc
SCT	4	4	0	0	0	0	circumcircle arc
SCT  	5     	6     	0     	0     	0     	0     	interpolated curve
SCT	6	6	0	0	0	0	interpolated curve
SCT	15	12	0	0	0	-1	fill area
SCT	20	1	0	0	2	0	pecked line in SRI
SCT  	65    	2     	0     	0     	0     	0     	clockwise arc
SCT  	66    	3     	0     	0     	0     	0       anticlockwise arc
SCT  	67    	4     	0     	0     	0     	0       circumcircle arc
SCT  	68    	5     	0     	0     	0     	0       full circumcircle
!
! LINES
!
SCT  100   1     0     0.0   0     0     ! SS 0
SCT  101   1     0     0.0   0     0     ! SS 1
SCT  102   1     0     0.0   0     0     ! SS 2
SCT  103   1     0     0.0   0     0     ! SS 3
SCT  104   1     0     0.0   0     0     ! SS 4
SCT  105   1     0     0.0   0     0     ! SS 5
SCT  106   1     0     0.0   0     0     ! SS 6
SCT  107   1     0     0.0   0     0     ! SS 7
SCT  108   1     0     0.0   0     0     ! SS 8
SCT  109   1     0     0.0   0     0     ! SS 9
SCT  110   1     0     0.0   0     0     ! SS 10
SCT  111   1     0     0.0   0     0     ! SS 11
SCT  112   1     0     0.0   0     0     ! SS 12
!
! ANTICLOCKWISE ARCS
!
SCT  300   3     0     0.0   0     0     ! SS 0
SCT  301   3     0     0.0   0     0     ! SS 1
SCT  302   3     0     0.0   0     0     ! SS 2
SCT  303   3     0     0.0   0     0     ! SS 3
SCT  304   3     0     0.0   0     0     ! SS 4
SCT  305   3     0     0.0   0     0     ! SS 5
SCT  306   3     0     0.0   0     0     ! SS 6
SCT  307   3     0     0.0   0     0     ! SS 7
SCT  308   3     0     0.0   0     0     ! SS 8
SCT  309   3     0     0.0   0     0     ! SS 9
SCT  310   3     0     0.0   0     0     ! SS 10
SCT  311   3     0     0.0   0     0     ! SS 11
SCT  312   3     0     0.0   0     0     ! SS 12
!
! CIRCUMCIRCLE ARCS
!
SCT  400   4     0     0.0   0     0     ! SS 0
SCT  401   4     0     0.0   0     0     ! SS 1
SCT  402   4     0     0.0   0     0     ! SS 2
SCT  403   4     0     0.0   0     0     ! SS 3
SCT  404   4     0     0.0   0     0     ! SS 4
SCT  405   4     0     0.0   0     0     ! SS 5
SCT  406   4     0     0.0   0     0     ! SS 6
SCT  407   4     0     0.0   0     0     ! SS 7
SCT  408   4     0     0.0   0     0     ! SS 8
SCT  409   4     0     0.0   0     0     ! SS 9
SCT  410   4     0     0.0   0     0     ! SS 10
SCT  411   4     0     0.0   0     0     ! SS 11
SCT  412   4     0     0.0   0     0     ! SS 12
!
! CIRCLES
!
SCT  500   5     0     0.0   0     0     ! SS 0
SCT  501   5     0     0.0   0     0     ! SS 1
SCT  502   5     0     0.0   0     0     ! SS 2
SCT  503   5     0     0.0   0     0     ! SS 3
SCT  504   5     0     0.0   0     0     ! SS 4
SCT  505   5     0     0.0   0     0     ! SS 5
SCT  506   5     0     0.0   0     0     ! SS 6
SCT  507   5     0     0.0   0     0     ! SS 7
SCT  508   5     0     0.0   0     0     ! SS 8
SCT  509   5     0     0.0   0     0     ! SS 9
SCT  510   5     0     0.0   0     0     ! SS 10
SCT  511   5     0     0.0   0     0     ! SS 11
SCT  512   5     0     0.0   0     0     ! SS 12
!
!==========================================================================
! GROUP definitions
!
GROUP BOUNDARY  144
GROUP DRAINAGE	661,834,220,541
GROUP MISC	660,702
GROUP OBSTACLES 199,824,301,823,260,225,300,380,261,582,921,860,701
GROUP SOILS	832
GROUP SURF_CON	825-831
GROUP SURF_MAT	832
GROUP RP_OBSTACLES 600-606
GROUP TRANSPORT 102,788-790,182,820,189,700,223,302,864,783,784,780,187,151,793
GROUP VEGETATION 101,148,303,340,184,835,580,920,900,140,141,150
!
! Some Laser-Scan defined ones 
GROUP AIR 	101,102,792
GROUP BRIDGE 	145-147,151,302,783-784,788-789,793
GROUP CONTOUR 	191-195
GROUP FOREST 	140,184,303,863
GROUP GROUND 	341
GROUP OBSTRUCT 	142-143,147,163,188,583,702-704,863
GROUP RAIL 	197,780-784,864
GROUP ROAD 	182,790,791
GROUP URBAN 	142,143,149,150
GROUP WATER 	180-181,186-187,302,580-581,582,661,785-787,821-822,834-835
!
GROUP GRID 	997,998
!
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!		   TPC/ONC LINE PATTERNS 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
!     1.0 DASH, 0.5 SPACE
PATTERN 1     0     0     0     0     1.5   1.0   0     0     0
!--------------------------------------------------------------
!     3.0 DASH, 0.4 SPACE
PATTERN 2     0     0     0     0     3.4   3.0   0     0     0
!--------------------------------------------------------------
!     0.5 DASH, THREE DOTS IN A 2.5 SPACE
!     DOTS: 0.25 DIAMETER
PATTERN 3     0     8     0     2     7.5   5.0   0     0     0.063
!--------------------------------------------------------------
!     1.5 DASH, 0.4 SPACE
PATTERN 4     0     0     0     0     1.9   1.5   0     0     0
!--------------------------------------------------------------
!     3.0 DASH, 0.5 SPACE
PATTERN 5     0     0     0     0     3.5   3.0   0     0     0
!--------------------------------------------------------------
!     1.5 DASH, 0.5 SPACE
PATTERN 6     0     0     0     0     2.0   1.5   0     0     0
!--------------------------------------------------------------
!     1.5 DASH, 0.5 SPACE, 1.5 DASH, CIRCLE IN 2.0 SPACE
!     CIRCLES: 0.13 LINE, 1.0 DIAMETER
PATTERN 7     3     0     0     1     5.5   1.0   1.5   0.5   0
!--------------------------------------------------------------
!     0.25 DIAMETER DOTS, 0.8 BETWEEN CENTRES
PATTERN 8     8     0     0     0     0.8   0.8   0     0.063 0
!--------------------------------------------------------------
!     2.0 DASH, 0.4 SPACE
PATTERN 9     0     0     0     0     2.4   2.0   0     0     0
!--------------------------------------------------------------
!     5.0 DASH, 0.5 SPACE
!     SPURS: 0.5 LONG, 0.5 SPACE
PATTERN 10    0     0     0     0     4.3   3.8   0     0     0
PATTERN 11    11    0     0     0     0.5   0.5   0     0.5   0
!--------------------------------------------------------------
PATTERN 12    4     0     0     0     2.63  0     0     1.275 0
!--------------------------------------------------------------
!     2.0 DASH 0.5 SPACE
PATTERN 13    0     0     0     0     2.5   2.0   0     0     0
!--------------------------------------------------------------
!     7.6 DASH, 0.5 SPACE
PATTERN 14    0     0     0     0     8.1   7.6   0     0     0
!--------------------------------------------------------------
!     3.8 DASH, 0.5 SPACE
PATTERN 15    0     0     0     0     4.3   3.8   0     0     0
!--------------------------------------------------------------
!     SOLID LINE
!     SPURS: 0.5 LONG, 0.5 INTERVAL
PATTERN 16    11    0     0     0     0.5   0     0.5   0.5   0
!--------------------------------------------------------------
!     SOLID LINE
!     SPURS: 0.5 LONG, 1.0 INTERVAL
PATTERN 17    11    0     0     0     1.0   0     1.0   0.5   0
!--------------------------------------------------------------
!     SOLID LINE
!     SPURS: 0.5 LONG, 2.0 INTERVAL
PATTERN 18    11    0     0     0     2.0   0     2.0   0.5   0
!--------------------------------------------------------------
!     SOLID LINE
!     SPURS: 0.5 LONG, 3.8 INTERVAL
PATTERN 19    11    0     0     0     3.8   0     3.8   0.5   0
!--------------------------------------------------------------
!     SOLID LINE
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, 6.4 INTERVAL
PATTERN 20    0     9     0     0     6.4   6.4   0     0     0.75
!--------------------------------------------------------------
!     SOLID LINE
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, 13 INTERVAL
PATTERN 21    0     9     0     0     13.0  13.0  0     0     0.75
!--------------------------------------------------------------
!     SOLID LINE
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, SPACED 0.5 APART AT 6.4 INTERVAL
PATTERN 22    0     10    0     0     6.9   6.9   0     0     0.75
!--------------------------------------------------------------
!     SOLID LINE
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, SPACED 0.5 APART AT 13.0 INTERVAL
PATTERN 23    0     10    0     0     13.5  13.5  0     0     0.75
!--------------------------------------------------------------
!     11.3 DASH, 1.5 SPACE
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, 6.4 INTERVAL
PATTERN 24    9     0     0     0      6.4  4.9   0     0.75  0
PATTERN 25    9     0     1     0     12.8  4.9   0     0.75  0
!--------------------------------------------------------------
!     24.5 DASH, 1.5 SPACE
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, 13 INTERVAL
PATTERN 26    0     0     0     0     13.0  11.5  0     0     0
PATTERN 27    9     0     0     0     13.0  11.5  0     0.75  0
!--------------------------------------------------------------
!     SOLID LINE
!     CROSSTIES: 1.2 LONG, 0.2 LINE WEIGHT, 3.2 INTERVAL
PATTERN 28    0     12    0     0     3.2   3.2   0     0     0.6
!--------------------------------------------------------------
!     3.3 DASH, 0.5 SPACE
PATTERN 29    0     0     0     0     3.9   3.3   0     0     0
!--------------------------------------------------------------
!     SOLID LINE
!     SYMBOL: 25.0 INTERVAL
PATTERN 30    0     2     0     0     25.0  25.0  0     0     1.375
!--------------------------------------------------------------
!     4 DASHES 1.0 LONG, 0.5 SPACE
!     DOTS: 0.8 DIAMETER, 7 APART
PATTERN 31    0     6     3     0     7.0   1.0   0.5   0     0.2
!--------------------------------------------------------------
!     2.5 DASH, 0.5 SPACE
PATTERN 32    0     0     0     0     3.0   2.5   0     0     0
!--------------------------------------------------------------
!     5.0 DASH, 1.3 SPACE
!     CROSS: 1.3, 45 DEGREE ANGLE
PATTERN 33    0     5     0     0     6.3   5.0   1.3   0     0.65
!--------------------------------------------------------------
!     7.6 DASH, 1.3 SPACE, 2.5 DASH
PATTERN 34    0     0     0     1     16.5  7.6   2.5   0     0
!--------------------------------------------------------------
!     SOLID DOTS: 0.6 DIAMETER, 2.5 SPACE BETWEEN CENTRES
PATTERN 35    19    0     0     0     2.5   2.5   0     0.15  0
!--------------------------------------------------------------
!     7.6 DASH, 1.3 SPACE, 2.5 DASH
PATTERN 36    0     0     0     0     12.7  7.6   2.5   0     0
!--------------------------------------------------------------
!     5.0 DASH, 1.0 SPACE
PATTERN 37    0     0     0     0     6.0   5.0   0     0     0
!--------------------------------------------------------------
!     6.0 DASH, 3.8 SPACE
PATTERN 38    0     0     0     0     9.8   6.0   0     0     0
!--------------------------------------------------------------
!     3.8 DASH, 1.3 SPACE
PATTERN 39    0     0     0     0     5.1   3.8   0     0     0
!--------------------------------------------------------------
!     DOTS: 0.25 DIAMETER, 0.75 SPACE BETWEEN CENTRES
PATTERN 40    8     0     0     0     0.75  0.75  0     0.063 0
!--------------------------------------------------------------
!     2.5 DASH, 1.3 SPACE
!     DOTS: 0.3 DIAMETER, CENTRED IN SPACE
PATTERN 41    0     7     0     0     3.8   2.5   1.3   0     0.075
!--------------------------------------------------------------
!     7.6 DASH, 0.5 SPACE
!     SPURS: 0.5 LONG, 1.0 SPACE
PATTERN 42    0     0     0     0     8.1   7.6   0     0     0
PATTERN 43    11    0     0     0     1.0   1.0   0     0.5   0
!--------------------------------------------------------------
!     7.6 DASH, 0.5 SPACE
!     SPURS: 0.5 LONG, 2.0 SPACE
PATTERN 44    0     0     0     0     8.1   7.6   0     0     0
PATTERN 45    11    0     0     0     2.0   2.0   0     0.5   0
!--------------------------------------------------------------
!     7.6 DASH, 0.5 SPACE
!     SPURS: 0.5 LONG, 3.8 SPACE
PATTERN 46    0     0     0     0     8.1   7.6   0     0     0
PATTERN 47    11    0     0     0     3.8   3.8   0     0.5   0
!--------------------------------------------------------------
!--------------------------------------------------------------
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, 6.4 INTERVAL
PATTERN 48    9     0     0     0     6.4   6.4   0     0.75  0
!--------------------------------------------------------------
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, SPACED 0.5 APART AT 6.4 INTERVAL
PATTERN 49    10    0     0     0     6.9   6.9   0     0.75  0
!--------------------------------------------------------------
!     11.3 DASH, 1.5 SPACE (PATTERN 24)
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, SPACED 0.5
!     APART AT 6.4 INTERVAL
PATTERN 50    10    0     1     0     13.8  6.9   0     0.75  0
!--------------------------------------------------------------
PATTERN 51    177   0     0     0     2.0   2.0   0     0.75  0  16
!--------------------------------------------------------------
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! 			FILL AREAS
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
!	Index	Hatch 	SC	Description
FILL  	 -2      3      51      Trees
!
! that's the end of the MSDS FRT
