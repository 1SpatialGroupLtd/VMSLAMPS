! TESTCARD.FRT
! This is the LaserPlot Acceptance Feature Representation Table
! S.Baker, R. Heap  22-NOV-1983
!
!    FC    GT    COL   WID   SIZ   SC
FRT  0     1     2     0     0     0     ! IT 0  LINE
FRT  1     7     3     0     2.0   1     ! IT 1  POINT
FRT  5     6     6     0     0     0     ! IT 5  INTERPOLATED CURVE
FRT  64    10    1     0     3.0   1     ! IT 64 TEXT
FRT  65    2     5     0     0     0     ! IT 65 CLOCKWISE ARC
FRT  66    3     6     0     0     0     ! IT 66 ANTICLOCKWISE ARC
FRT  67    4     7     0     0     0     ! IT 67 CIRCUMCIRCLE ARC
FRT  68    5     8     0     0     0     ! IT 68 FULL CIRCUMCIRCLE
!
! FRT for TPC test
!
FRT  100   1      1    .25   0     0     ! 10101 COASTLINE              
FRT  101   6      1    .23   0     0     ! 10201 PER.STREAM (DOUBLE)    
FRT  102   6      1    .175  0     3     ! 10202 NON-PERENNIAL STREAM   
FRT  103   6      1    .175  0     0     ! 10203 PERENNIAL STREAM       
FRT  104   6      1    .38   0     5     ! 10214 CANAL-ABAN. OR U/C     
FRT  105   6      1    .25   0     0     ! 10250 PER. STREAM (MAIN)     
FRT  106   7      1    0     0.325 134   ! 10301 WELL (WATER)           
FRT  107   6      1    .15   0     0     ! 10404 FORESHORE FLATS        
FRT  108   6      1    .15   0     12    ! 10502 REEFS (LARGE)
FRT  109   6      1    .15   0     12    ! 10501 REEFS (SMALL)   
FRT  110   6      2    .3    0     21    ! 20101 RAIL SINGLE
FRT  111   6      2    .45   0     22    ! 20102 RAIL-DOUBLE 
FRT  112   1      3    .15   0     0     ! 20201 TOWN OUTLINE           
FRT  113   7      3    0     0.55  154   ! 20202 TOWN CATEGORY 3        
FRT  114   7      3    0     0.4   150   ! 20203 LANDMARK               
FRT  115   7      3    0     1.25  152   ! 20204 TOWN CATEGORY 1      
FRT  116   7      4    0     0.15  130   ! 20302 SPOT HGT (ACCURATE)
FRT  117   7      4    0     0.25  133   ! 20303 CRITICAL SP HT (ACC)   
FRT  118   1      5    .25   0     1     ! 20335 ROAD TUNNEL      
FRT  119   1      5    .25   0     1     ! 20336 RAIL TUNNEL
FRT  120   1      5    .2    0     0     ! 20338 TUNNEL R/WAY IN TOWN   
FRT  121   7      5    0     1.075 145   ! 20361 MINE                   
FRT  122   6      6    0     0     0     ! 20401 ROAD DUAL LANE         
FRT  123   6      6    .5    0     0     ! 20403 ROAD-PRIMARY           
FRT  124   6      6    .3    0     0     ! 20404 ROAD-SECONDARY         
FRT  125   7      1    0     0.65  148   ! 20702 ROCKS AWASH            
FRT  126   7      1    0     1.875 147   ! 20704 WRECK                  
FRT  127   6      7    .125  0     0     ! 31102 ACCURATE CONTOURS
FRT  128   1      8    0     0     0     ! 40101 VEGETATION             
FRT  129   7      9    0     1.8   144   ! 40201 OASIS                  
FRT  130   7     15    0     2.0   160   ! 50000 REGISTRATION GENERAL   
!
! FRT for testing Border patterns
!
FRT  201   1     15    0.15  0     0     ! 
FRT  202   1     15    0.2   0     0     ! 
FRT  203   1     15    0.3   0     0     ! 
FRT  204   1     15    1.0   0     0     ! 
FRT  205   1     15    2.0   0     0     ! 
!
! FRT for testing linegauges
!
FRT  301   1      1    0.1   0     0     ! SS 0
FRT  302   1      2    0.125 0     0     ! SS 1
FRT  303   1      3    0.15  0     0     ! SS 2
FRT  304   1      4    0.175 0     0     ! SS 3
FRT  305   1      5    0.2   0     0     ! SS 4
FRT  306   1      6    0.23  0     0     ! SS 5
FRT  307   1      7    0.25  0     0     ! SS 6
FRT  308   1      8    0.275 0     0     ! SS 6A
FRT  309   1      9    0.3   0     0     ! SS 7
FRT  310   1     10    0.325 0     0     ! SS 7A
FRT  311   1     11    0.35  0     0     ! SS 8
FRT  312   1     12    0.38  0     0     ! SS 9
FRT  313   1     13    0.4   0     0     ! SS 10
FRT  314   1     14    0.425 0     0     ! SS 10A
FRT  315   1     15    0.45  0     0     ! SS 11
FRT  316   1     16    0.475 0     0     ! SS 11A
FRT  317   1     17    0.5   0     0     ! SS 12
FRT  318   1     18    0.525 0     0     ! SS 12A
FRT  319   1     19    0.55  0     0     ! SS 12B
FRT  320   1     20    0.575 0     0     ! SS 12C
FRT  321   1     21    0.6   0     0     ! SS 12D
FRT  322   1     22    0.65  0     0     ! SS 13
FRT  323   1     23    0.675 0     0     ! SS 13A
FRT  324   1     24    0.7   0     0     ! SS 13B
FRT  325   1     25    0.725 0     0     ! SS 13C
FRT  326   1     26    0     0     0     !
FRT  327   1     27    0.75  0     0     ! SS 14
FRT  328   1     28    0.775 0     0     ! SS 14A
FRT  329   1     29    0.8   0     0     ! SS 14B
FRT  330   1     30    0.825 0     0     ! SS 14C
FRT  331   1     31    0.85  0     0     ! SS 14D
FRT  332   1     32    0.875 0     0     ! SS 14E
FRT  333   1     33    0.9   0     0     ! SS 14F
FRT  334   1     34    0.925 0     0     ! SS 14G
FRT  335   1     35    0.95  0     0     ! SS 14H
FRT  336   1     36    0.975 0     0     ! SS 14J
FRT  337   1     37    1.0   0     0     ! SS 15
FRT  338   1     38    0     0     0     ! 
FRT  339   1     39    0     0     0     ! 
FRT  340   1     40    0     0     0     ! 
FRT  341   1     41    0     0     0     ! 
FRT  342   1     42    0     0     0     ! 
FRT  343   1     43    0     0     0     ! 
FRT  344   1     44    0     0     0     ! 
FRT  345   1     45    1.25  0     0     ! SS 16
FRT  346   1     46    1.5   0     0     ! SS 17
FRT  347   1     47    2.0   0     0     ! SS 18
FRT  348   1     48    2.5   0     0     ! SS 19
FRT  349   1     49    3.5   0     0     ! SS 20
!
! FRT for testing line patterns
!
! circular patterns
!
FRT  501   5      1    0.2   0     1     ! PATTERN 1
FRT  502   5      1    0.2   0     2     ! PATTERN 2
FRT  503   5      1    0.2   0     3     ! PATTERN 3
FRT  504   5      1    0.2   0     4     ! PATTERN 4
FRT  505   5      1    0.4   0     5     ! PATTERN 5
FRT  506   5      1    0.3   0     6     ! PATTERN 6
FRT  507   5      1    0.3   0     7     ! PATTERN 7
FRT  508   5      1    0     0     8     ! PATTERN 8
FRT  509   5      1    0.13  0     9     ! PATTERN 9
FRT  510   5      1    0.13  0     10    ! PATTERN 10
FRT  511   5      1    0     0     11    ! PATTERN 11
FRT  512   5      1    0.2   0     12    ! PATTERN 12
FRT  513   5      1    0.2   0     13    ! PATTERN 13
FRT  514   5      1    0.13  0     14    ! PATTERN 14
FRT  515   5      1    0.13  0     15    ! PATTERN 15
FRT  516   5      1    0.13  0     16    ! PATTERN 16
FRT  517   5      1    0.13  0     17    ! PATTERN 17
FRT  518   5      1    0.13  0     18    ! PATTERN 18
FRT  519   5      1    0.13  0     19    ! PATTERN 19
FRT  520   5      1    0.3   0     20    ! PATTERN 20
FRT  521   5      1    0.25  0     21    ! PATTERN 21
FRT  522   5      1    0.5   0     22    ! PATTERN 22
FRT  523   5      1    0.25  0     23    ! PATTERN 23
FRT  524   5      1    0.3   0     24    ! PATTERN 24
FRT  525   5      1    0     0     25    ! PATTERN 25
FRT  526   5      1    0.25  0     26    ! PATTERN 26
FRT  527   5      1    0     0     27    ! PATTERN 27
FRT  528   5      1    0.2   0     28    ! PATTERN 28
FRT  529   5      1    0.4   0     29    ! PATTERN 29
FRT  530   5      1    0.3   0     30    ! PATTERN 30
FRT  531   5      1    0.25  0     31    ! PATTERN 31
FRT  532   5      1    0.15  0     32    ! PATTERN 32
FRT  533   5      1    0.13  0     33    ! PATTERN 33
FRT  534   5      1    0.5   0     34    ! PATTERN 34
FRT  535   5      1    0     0     35    ! PATTERN 35
FRT  536   5      1    0.4   0     36    ! PATTERN 36
FRT  537   5      1    0.25  0     37    ! PATTERN 37
FRT  538   5      1    0.5   0     38    ! PATTERN 38
FRT  539   5      1    0.3   0     39    ! PATTERN 39
FRT  540   5      1    0     0     40    ! PATTERN 40
FRT  541   5      1    0.25  0     41    ! PATTERN 41
!
! curved patterns
!
FRT  601   6      2    0.2   0     1     ! PATTERN 1
FRT  602   6      2    0.2   0     2     ! PATTERN 2
FRT  603   6      2    0.2   0     3     ! PATTERN 3
FRT  604   6      2    0.2   0     4     ! PATTERN 4
FRT  605   6      2    0.4   0     5     ! PATTERN 5
FRT  606   6      2    0.3   0     6     ! PATTERN 6
FRT  607   6      2    0.3   0     7     ! PATTERN 7
FRT  608   6      2    0     0     8     ! PATTERN 8
FRT  609   6      2    0.13  0     9     ! PATTERN 9
FRT  610   6      2    0.13  0     10    ! PATTERN 10
FRT  611   6      2    0     0     11    ! PATTERN 11
FRT  612   6      2    0.2   0     12    ! PATTERN 12
FRT  613   6      2    0.2   0     13    ! PATTERN 13
FRT  614   6      2    0.13  0     14    ! PATTERN 14
FRT  615   6      2    0.13  0     15    ! PATTERN 15
FRT  616   6      2    0.13  0     16    ! PATTERN 16
FRT  617   6      2    0.13  0     17    ! PATTERN 17
FRT  618   6      2    0.13  0     18    ! PATTERN 18
FRT  619   6      2    0.13  0     19    ! PATTERN 19
FRT  620   6      2    0.3   0     20    ! PATTERN 20
FRT  621   6      2    0.25  0     21    ! PATTERN 21
FRT  622   6      2    0.5   0     22    ! PATTERN 22
FRT  623   6      2    0.25  0     23    ! PATTERN 23
FRT  624   6      2    0.3   0     24    ! PATTERN 24
FRT  625   6      2    0     0     25    ! PATTERN 25
FRT  626   6      2    0.25  0     26    ! PATTERN 26
FRT  627   6      2    0     0     27    ! PATTERN 27
FRT  628   6      2    0.2   0     28    ! PATTERN 28
FRT  629   6      2    0.4   0     29    ! PATTERN 29
FRT  630   6      2    0.3   0     30    ! PATTERN 30
FRT  631   6      2    0.25  0     31    ! PATTERN 31
FRT  632   6      2    0.15  0     32    ! PATTERN 32
FRT  633   6      2    0.13  0     33    ! PATTERN 33
FRT  634   6      2    0.5   0     34    ! PATTERN 34
FRT  635   6      2    0     0     35    ! PATTERN 35
FRT  636   6      2    0.4   0     36    ! PATTERN 36
FRT  637   6      2    0.25  0     37    ! PATTERN 37
FRT  638   6      2    0.5   0     38    ! PATTERN 38
FRT  639   6      2    0.3   0     39    ! PATTERN 39
FRT  640   6      2    0     0     40    ! PATTERN 40
FRT  641   6      2    0.25  0     41    ! PATTERN 41
!
! linear patterns
!
FRT  701   1      3    0.2   0     1     ! PATTERN 1
FRT  702   1      3    0.2   0     2     ! PATTERN 2
FRT  703   1      3    0.2   0     3     ! PATTERN 3
FRT  704   1      3    0.2   0     4     ! PATTERN 4
FRT  705   1      3    0.4   0     5     ! PATTERN 5
FRT  706   1      3    0.3   0     6     ! PATTERN 6
FRT  707   1      3    0.3   0     7     ! PATTERN 7
FRT  708   1      3    0     0     8     ! PATTERN 8
FRT  709   1      3    0.13  0     9     ! PATTERN 9
FRT  710   1      3    0.13  0     10    ! PATTERN 10
FRT  711   1      3    0     0     11    ! PATTERN 11
FRT  712   1      3    0.2   0     12    ! PATTERN 12
FRT  713   1      3    0.2   0     13    ! PATTERN 13
FRT  714   1      3    0.13  0     14    ! PATTERN 14
FRT  715   1      3    0.13  0     15    ! PATTERN 15
FRT  716   1      3    0.13  0     16    ! PATTERN 16
FRT  717   1      3    0.13  0     17    ! PATTERN 17
FRT  718   1      3    0.13  0     18    ! PATTERN 18
FRT  719   1      3    0.13  0     19    ! PATTERN 19
FRT  720   1      3    0.3   0     20    ! PATTERN 20
FRT  721   1      3    0.25  0     21    ! PATTERN 21
FRT  722   1      3    0.5   0     22    ! PATTERN 22
FRT  723   1      3    0.25  0     23    ! PATTERN 23
FRT  724   1      3    0.3   0     24    ! PATTERN 24
FRT  725   1      3    0     0     25    ! PATTERN 25
FRT  726   1      3    0.25  0     26    ! PATTERN 26
FRT  727   1      3    0     0     27    ! PATTERN 27
FRT  728   1      3    0.2   0     28    ! PATTERN 28
FRT  729   1      3    0.4   0     29    ! PATTERN 29
FRT  730   1      3    0.3   0     30    ! PATTERN 30
FRT  731   1      3    0.25  0     31    ! PATTERN 31
FRT  732   1      3    0.15  0     32    ! PATTERN 32
FRT  733   1      3    0.13  0     33    ! PATTERN 33
FRT  734   1      3    0.5   0     34    ! PATTERN 34
FRT  735   1      3    0     0     35    ! PATTERN 35
FRT  736   1      3    0.4   0     36    ! PATTERN 36
FRT  737   1      3    0.25  0     37    ! PATTERN 37
FRT  738   1      3    0.5   0     38    ! PATTERN 38
FRT  739   1      3    0.3   0     39    ! PATTERN 39
FRT  740   1      3    0     0     40    ! PATTERN 40
FRT  741   1      3    0.25  0     41    ! PATTERN 41
!
! FRT for testing text font 1
!
FRT  801   10     4    0     4.0   1     ! FONT 1, 4mm
!
! FRT for testing symbols
!
FRT  901   7     15    0     12.0  101   ! LSL LOGO
FRT  902   7     15    0     12.0  102   ! MCE LOGO
FRT  930   7     15    0     0.15  130   ! SS 30  SPOT ELEVATION
FRT  933   7     15    0     0.25  133   ! SS 33  ALL CRITICAL ELEVATION
FRT  934   7     15    0     0.325 134   ! SS 34  SPRINGS & WELLS
FRT  944   7     15    0     1.8   144   ! SS 44  OASIS
FRT  945   7     15    0     1.075 145   ! SS 45  SHAFT MINES & QUARRIES
FRT  946   7     15    0     0.65  146   ! SS 46  APPROX. ELEVATION
FRT  947   7     15    0     1.875 147   ! SS 47  EXPOSED WRECK
FRT  948   7     15    0     0.65  148   ! SS 48  ROCKS - BARE OR AWASH
FRT  950   7     15    0     0.4   150   ! SS 50  LANDMARK
FRT  952   7     15    0     1.25  152   ! SS 52  TOWN CATEGORY 1
FRT  953   7     15    0     0.75  153   ! SS 53  TOWN CATEGORY 2
FRT  954   7     15    0     0.55  154   ! SS 54  TOWN CATEGORY 3
FRT  960   7     15    0     2.0   160   ! SS 60  4 mm CROSS
FRT  961   7     15    0     1.5   161   ! SS 61  3 mm CROSS
FRT  962   7     15    0     1.0   162   ! SS 62  2 mm CROSS
FRT  963   7     15    0     0.5   163   ! SS 63  1 mm CROSS
FRT  995   7     15    0     2.0   15    ! NW CORNER MARK
FRT  996   7     15    0     2.0   16    ! SW CORNER MARK
FRT  997   7     15    0     2.0   17    ! SE CORNER MARK
FRT  998   7     15    0     2.0   18    ! NE CORNER MARK
FRT  999   7     15    0     2.0   14    ! POSITIONING MARK
FRT 9999   7      2    0     1.0   103   ! BUG
!
! GROUPS
!
GROUP DRAINAGE 100-106,108,109
GROUP OPEN_WATER 100,101
GROUP BLACK_CULTURE 110-117,119,125,126
GROUP ROADS 118,122-124
! GROUP SYMBOLS
GROUP CONTOURS 127
GROUP WOODS 128
GROUP SURFACES 107
! GROUP LEVEES
! GROUP POWERLINES
GROUP OASIS 129
GROUP REGISTRATION 130
GROUP BORDER 201-205
GROUP LINE_TEST 301-350
GROUP PATTERN_TEST 501-741
GROUP SYMBOL_TEST 901-999,9999
GROUP TEXT_TEST 801-899
!
! SYMBOL COMPONENT TABLE
!
SCT  0     1     0     0     0     0     ! LINEAR
SCT  5     6     0     0     0     0     ! INTERPOLATED CURVE
SCT  65    2     0     0     0     0     ! CLOCKWISE ARC
SCT  66    3     0     0     0     0     ! ANTICLOCKWISE ARC
SCT  67    4     0     0     0     0     ! CIRCUMCIRCLE ARC
SCT  68    5     0     0     0     0     ! FULL CIRCUMCIRCLE
!
! LINEAR
!
SCT  100   1     0     0.1   0     0     ! SS 0
SCT  101   1     0     0.125 0     0     ! SS 1
SCT  102   1     0     0.15  0     0     ! SS 2
SCT  103   1     0     0.175 0     0     ! SS 3
SCT  104   1     0     0.2   0     0     ! SS 4
SCT  105   1     0     0.23  0     0     ! SS 5
SCT  106   1     0     0.25  0     0     ! SS 6
SCT  107   1     0     0.3   0     0     ! SS 7
SCT  108   1     0     0.35  0     0     ! SS 8
SCT  109   1     0     0.38  0     0     ! SS 9
SCT  110   1     0     0.4   0     0     ! SS 10
SCT  111   1     0     0.45  0     0     ! SS 11
SCT  112   1     0     0.5   0     0     ! SS 12
SCT  113   1     0     0.65  0     0     ! SS 13
!
! ANTICLOCKWISE ARC
!
SCT  300   3     0     0.1   0     0     ! SS 0
SCT  301   3     0     0.125 0     0     ! SS 1
SCT  302   3     0     0.15  0     0     ! SS 2
SCT  303   3     0     0.175 0     0     ! SS 3
SCT  304   3     0     0.2   0     0     ! SS 4
SCT  305   3     0     0.23  0     0     ! SS 5
SCT  306   3     0     0.25  0     0     ! SS 6
SCT  307   3     0     0.3   0     0     ! SS 7
SCT  308   3     0     0.35  0     0     ! SS 8
SCT  309   3     0     0.38  0     0     ! SS 9
SCT  310   3     0     0.4   0     0     ! SS 10
SCT  311   3     0     0.45  0     0     ! SS 11
SCT  312   3     0     0.5   0     0     ! SS 12
SCT  313   3     0     0.65  0     0     ! SS 13
!
! CIRCUMCIRCLE ARC
!
SCT  400   4     0     0.1   0     0     ! SS 0
SCT  401   4     0     0.125 0     0     ! SS 1
SCT  402   4     0     0.15  0     0     ! SS 2
SCT  403   4     0     0.175 0     0     ! SS 3
SCT  404   4     0     0.2   0     0     ! SS 4
SCT  405   4     0     0.23  0     0     ! SS 5
SCT  406   4     0     0.25  0     0     ! SS 6
SCT  407   4     0     0.3   0     0     ! SS 7
SCT  408   4     0     0.35  0     0     ! SS 8
SCT  409   4     0     0.38  0     0     ! SS 9
SCT  410   4     0     0.4   0     0     ! SS 10
SCT  411   4     0     0.45  0     0     ! SS 11
SCT  412   4     0     0.5   0     0     ! SS 12
SCT  413   4     0     0.65  0     0     ! SS 13
!
! FULL CIRCUMCIRCLE
!
SCT  500   5     0     0.1   0     0     ! SS 0
SCT  501   5     0     0.125 0     0     ! SS 1
SCT  502   5     0     0.15  0     0     ! SS 2
SCT  503   5     0     0.175 0     0     ! SS 3
SCT  504   5     0     0.2   0     0     ! SS 4
SCT  505   5     0     0.23  0     0     ! SS 5
SCT  506   5     0     0.25  0     0     ! SS 6
SCT  507   5     0     0.3   0     0     ! SS 7
SCT  508   5     0     0.35  0     0     ! SS 8
SCT  509   5     0     0.38  0     0     ! SS 9
SCT  510   5     0     0.4   0     0     ! SS 10
SCT  511   5     0     0.45  0     0     ! SS 11
SCT  512   5     0     0.5   0     0     ! SS 12
SCT  513   5     0     0.65  0     0     ! SS 13
!
!		   TPC/ONC LINE PATTERNS
!
!1    TPC/ONC FLUCTUATING SHORELINES
PATTERN 1     0     0     0     0     1.5   1.0   0     0     0
!
!2    TPC/ONC UNSURVEYED SHORELINES
PATTERN 2     0     0     0     0     3.4   3.0   0     0     0
!
!3    TPC/ONC NON-PERENNIAL STREAM
PATTERN 3     0     8     0     2     7.5   5.0   0     0     0.063
!
!4    TPC/ONC SEASONALLY FLUCTUATING STREAM
PATTERN 4     0     0     0     0     1.9   1.5   0     0     0
!
!5    TPC/ONC CANALS - ABANDONED OR U/C
PATTERN 5     0     0     0     0     3.5   3.0   0     0     0
!
!6    TPC/ONC UNDERGROUND AQUEDUCTS
PATTERN 6     0     0     0     0     2.0   1.5   0     0     0
!
!7    TPC/ONC KANATS
PATTERN 7     3     0     0     1     5.5   1.0   1.5   0.5   0
!
!8    TPC/ONC HUMMOCKS AND RIDGES
PATTERN 8     8     0     0     0     0.8   0.8   0     0.063 0
!
!9    TPC/ONC GLACIERS, SNOWFIELDS, ICE FIELDS & ICE CAPS
PATTERN 9     0     0     0     0     2.4   2.0   0     0     0
!
!10/11 TPC/ONC ESCARPMENTS, BLUFFS, CLIFFS, DEPRESSIONS
PATTERN 10    0     0     0     0     4.3   3.8   0     0     0
PATTERN 11    11    0     0     0     0.5   0.5   0     0.5   0
!
!12   TPC/ONC REEFS - ROCKY OR CORAL
PATTERN 12    4     0     0     0     2.63  2.63  0     1.43  0
!
!13   TPC/ONC TELEPHONE & TELEGRAPH LINES
PATTERN 13    0     0     0     0     2.5   2.0   0     0     0
!
!14   TPC/ONC BASIC, INTERMEDIATE CONTOURS (APPROX.)
PATTERN 14    0     0     0     0     8.1   7.6   0     0     0
!
!15   TPC/ONC AUXILIARY CONTOURS (APPROX)
PATTERN 15    0     0     0     0     4.3   3.8   0     0     0
!
!16   TPC/ONC LARGE ESCARPMENTS
PATTERN 16    11    0     0     0     0.5   0     0.5   0.5   0
!
!17   TPC/ONC DEPRESSION CONTOURS (SMALL)
PATTERN 17    11    0     0     0     1.0   0     1.0   0.5   0
!
!18   TPC/ONC DEPRESSION CONTOURS (MEDIUM)
PATTERN 18    11    0     0     0     2.0   0     2.0   0.5   0
!
!19   TPC/ONC DEPRESSION CONTOURS (LARGE)
PATTERN 19    11    0     0     0     3.8   0     3.8   0.5   0
!
!20   TPC     SINGLE TRACK RAILWAYS
PATTERN 20    0     9     0     0     6.4   6.4   0     0     0.75
!
!21   ONC     SINGLE TRACK RAILWAYS
PATTERN 21    0     9     0     0     13.0  13.0  0     0     0.75
!
!22   TPC     DOUBLE TRACK RAILWAYS
PATTERN 22    0     10    0     0     6.9   6.9   0     0     0.75
!
!23   ONC     DOUBLE TRACK RAILWAYS
PATTERN 23    0     10    0     0     13.5  13.5  0     0     0.75
!
!24/25 TPC     RAILWAY-NON-OPERATING, ABANDONED, DESTROYED OR U/C
PATTERN 24    0     0     0     0     12.8  11.3  0     0     0
PATTERN 25    9     0     1     0     12.8  4.9   0     0.75  0
!
!26/27 ONC     RAILWAY-NON-OPERATING, ABANDONED, DESTROYED OR U/C
PATTERN 26    0     0     0     0     13.0  11.5  0     0     0
PATTERN 27    9     0     0     0     13.0  11.5  0     0.75  0
!
!28   TPC/ONC CARLINES
PATTERN 28    0     12    0     0     3.2   3.2   0     0     0.6
!
!29   TPC/ONC ROADS-UNDER CONSTRUCTION
PATTERN 29    0     0     0     0     3.9   3.3   0     0     0
!
!30   TPC     POWER TRANSMISSION LINES
PATTERN 30    0     2     0     0     25.0  25.0  0     0     1.375
!
!31   ONC     POWER TRANSMISSION LINES
PATTERN 31    0     6     3     0     7.0   1.0   0.5   0     0.2
!
!32   TPC/ONC UNDERGROUND PIPELINE
PATTERN 32    0     0     0     0     3.0   2.5   0     0     0
!
!33   TPC/ONC PROMINENT FENCES
PATTERN 33    0     5     0     0     6.3   5.0   1.3   0     0.65
!
!34   TPC/ONC INTERNATIONAL BOUNDARY - DE JURE
PATTERN 34    0     0     0     1     16.5  7.6   2.5   0     0
!
!35   TPC/ONC INTERNATIONAL BOUNDARY - DE FACTO
PATTERN 35    19    0     0     0     2.5   2.5   0     0.15  0
!
!36   TPC/ONC ADMINISTRATIVE BOUNDARY - MAJOR
PATTERN 36    0     0     0     0     12.7  7.6   2.5   0     0
!
!37   TPC/ONC TREATY OR OCCUPANCY ZONE
PATTERN 37    0     0     0     0     6.0   5.0   0     0     0
!
!38   TPC/ONC INTERNATIONAL DATE LINE
PATTERN 38    0     0     0     0     9.8   6.0   0     0     0
!
!39   TPC/ONC ISOGONIC LINE
PATTERN 39    0     0     0     0     5.1   3.8   0     0     0
!
!40   TPC     DIVISION OF SOVEREIGNTY BOUNDARY
PATTERN 40    8     0     0     0     0.75  0.75  0     0.063 0
!
!41   ONC     MILITARY RESERVATION
PATTERN 41    0     7     0     0     3.8   2.5   1.3   0     0.075
!
! End of TESTCARD.FRT
!
