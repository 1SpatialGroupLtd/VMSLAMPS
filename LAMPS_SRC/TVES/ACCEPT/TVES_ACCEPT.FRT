! Main TPC Feature Representation Table TPC1.FRT     S A BAKER
!version for ROVER
!
!    FC    GT    COL   WID   SIZ   SC
FRT  0     12    1     0     4     102   ! WOODS
FRT  1     1     4     0     0     0     ! RIVERS
FRT  3     1     6     0     0     0     ! INDEX CONT
FRT  4     1     4     0     0     0     ! COASTLINE
FRT  5     1     5     0     0     0     ! CONT
FRT  6     1     2     0     0     0     ! ROADS
FRT  7     11    4     0     4     1     ! SYMBOL STRING
!
GROUP CONTOUR 3,5
GROUP ROADS 6
GROUP WOODS 0
GROUP RIVERS 1
GROUP COAST 4
!--------------------------------------------------------------
!		   TPC/ONC SYMBOLS  (TPC.SRI)
!--------------------------------------------------------------
!
!   NO.      MPS         DESCRIPTION
!   ---      ---         -----------
!   15                   NW CORNER MARK
!   16                   SW CORNER MARK
!   17                   SE CORNER MARK
!   18                   NE CORNER MARK
!   14                   POSITIONING MARK
!   101                  LSL LOGO
!   102                  MCE LOGO
!   103                  BUG
!   130      SS 30       SPOT ELEVATION
!   133      SS 33       ALL CRITICAL ELEVATION
!   134      SS 34       SPRINGS & WELLS
!   144      SS 44       OASIS
!   145      SS 45       SHAFT MINES & QUARRIES
!   146      SS 46       APPROX. ELEVATION
!   147      SS 47       EXPOSED WRECK
!   148      SS 48       ROCKS - BARE OR AWASH
!   150      SS 50       LANDMARK
!   152      SS 52       TOWN CATEGORY 1
!   153      SS 53       TOWN CATEGORY 2
!   154      SS 54       TOWN CATEGORY 3
!   160      SS 60       4 mm CROSS
!   161      SS 61       3 mm CROSS
!   162      SS 62       2 mm CROSS
!   163      SS 63       1 mm CROSS
!   164      MC RIVTUN   DRAINAGE TUNNEL ENTRANCE
!   165      MC KAMP     KAMPONG
!   166      MC LANDG    LANDMARK (GROUP)
!   167      MC CIRC     GROUNDMARK
!   168      MC RESV     RESERVIOR
!   169      MC QWE      RAIL BRIDGE
!   170      MC ELEV     ROAD BRIDGE
!   171      MC TUN      RAIL TUNNEL ENTRANCE
!   172      MC RDTUN    ROAD TUNNEL ENTRANCE
!   173      MC CLOV     CLOVERLEAF
!   174      MC STAD     STADIUM/RACE TRACK
!   175      MC PASS     PASS
!   176      MC CTIMES   SMALL LOCKS (ONC)
!
! SYMBOL COMPONENTS
!
SCT  0     1     0     0     0     0     ! LINEAR
SCT  1     1     4     0     0     0     ! LINEAR
SCT  5     6     0     0     0     0     ! INTERPOLATED CURVE
SCT  15    1     11    0     0     0     ! special for pylons
SCT  65    2     0     0     0     0     ! CLOCKWISE ARC
SCT  66    3     0     0     0     0     ! ANTICLOCKWISE ARC
SCT  67    4     0     0     0     0     ! CIRCUMCIRCLE ARC
SCT  68    5     0     0     0     0     ! FULL CIRCUMCIRCLE
!
! LINES
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
!
! CLOCKWISE ARCS
!
SCT  200   2     0     0.1   0     0     ! SS 0
SCT  201   2     0     0.125 0     0     ! SS 1
SCT  202   2     0     0.15  0     0     ! SS 2
SCT  203   2     0     0.175 0     0     ! SS 3
SCT  204   2     0     0.2   0     0     ! SS 4
SCT  205   2     0     0.23  0     0     ! SS 5
SCT  206   2     0     0.25  0     0     ! SS 6
SCT  207   2     0     0.3   0     0     ! SS 7
SCT  208   2     0     0.35  0     0     ! SS 8
SCT  209   2     0     0.38  0     0     ! SS 9
SCT  210   2     0     0.4   0     0     ! SS 10
SCT  211   2     0     0.45  0     0     ! SS 11
SCT  212   2     0     0.5   0     0     ! SS 12
!
! ANTICLOCKWISE ARCS
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
!
! CIRCUMCIRCLE ARCS
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
!
! CIRCLES
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
!
!		   TPC/ONC LINE PATTERNS
!--------------------------------------------------------------
!1
!     1.0 DASH, 0.5 SPACE
!
PATTERN 1     0     0     0     0     1.5   1.0   0     0     0
!--------------------------------------------------------------
!2
!     3.0 DASH, 0.4 SPACE
!
PATTERN 2     0     0     0     0     3.4   3.0   0     0     0
!--------------------------------------------------------------
!3
!     0.5 DASH, THREE DOTS IN A 2.5 SPACE
!     DOTS: 0.25 DIAMETER
!
PATTERN 3     0     8     0     2     7.5   5.0   0     0     0.063
!--------------------------------------------------------------
!4
!     1.5 DASH, 0.4 SPACE
!
PATTERN 4     0     0     0     0     1.9   1.5   0     0     0
!--------------------------------------------------------------
!5
!     3.0 DASH, 0.5 SPACE
!
PATTERN 5     0     0     0     0     3.5   3.0   0     0     0
!--------------------------------------------------------------
!6
!     1.5 DASH, 0.5 SPACE
!
PATTERN 6     0     0     0     0     2.0   1.5   0     0     0
!--------------------------------------------------------------
!7
!     1.5 DASH, 0.5 SPACE, 1.5 DASH, CIRCLE IN 2.0 SPACE
!     CIRCLES: 0.13 LINE, 1.0 DIAMETER
!
PATTERN 7     3     0     0     1     5.5   1.0   1.5   0.5   0
!--------------------------------------------------------------
!8
!     0.25 DIAMETER DOTS, 0.8 BETWEEN CENTRES
!
PATTERN 8     8     0     0     0     0.8   0.8   0     0.063 0
!--------------------------------------------------------------
!9
!     2.0 DASH, 0.4 SPACE
!
PATTERN 9     0     0     0     0     2.4   2.0   0     0     0
!--------------------------------------------------------------
!10/11
!     5.0 DASH, 0.5 SPACE
!     SPURS: 0.5 LONG, 0.5 SPACE
!
PATTERN 10    0     0     0     0     4.3   3.8   0     0     0
PATTERN 11    11    0     0     0     0.5   0.5   0     0.5   0
!--------------------------------------------------------------
!12
!
PATTERN 12    4     0     0     0     2.63  2.63  0     1.43  0
!--------------------------------------------------------------
!13
!     2.0 DASH 0.5 SPACE
!
PATTERN 13    0     0     0     0     2.5   2.0   0     0     0
!--------------------------------------------------------------
!14
!     7.6 DASH, 0.5 SPACE
!
PATTERN 14    0     0     0     0     8.1   7.6   0     0     0
!--------------------------------------------------------------
!15
!     3.8 DASH, 0.5 SPACE
!
PATTERN 15    0     0     0     0     4.3   3.8   0     0     0
!--------------------------------------------------------------
!16
!     SOLID LINE
!     SPURS: 0.5 LONG, 0.5 INTERVAL
!
PATTERN 16    11    0     0     0     0.5   0     0.5   0.5   0
!--------------------------------------------------------------
!17
!     SOLID LINE
!     SPURS: 0.5 LONG, 1.0 INTERVAL
!
PATTERN 17    11    0     0     0     1.0   0     1.0   0.5   0
!--------------------------------------------------------------
!18
!     SOLID LINE
!     SPURS: 0.5 LONG, 2.0 INTERVAL
!
PATTERN 18    11    0     0     0     2.0   0     2.0   0.5   0
!--------------------------------------------------------------
!19
!     SOLID LINE
!     SPURS: 0.5 LONG, 3.8 INTERVAL
!
PATTERN 19    11    0     0     0     3.8   0     3.8   0.5   0
!--------------------------------------------------------------
!20
!     SOLID LINE
!     CROSSTIES: 1.5 LONG, 0.2 LINE WEIGHT, 6.4 INTERVAL
!
PATTERN 20    0     9     0     0     6.4   6.4   0     0     0.75
!--------------------------------------------------------------
!21
!     SOLID LINE
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, 13 INTERVAL
!
PATTERN 21    0     9     0     0     13.0  13.0  0     0     0.75
!--------------------------------------------------------------
!22
!     SOLID LINE
!     CROSSTIES: 1.5 LONG, 0.2 LINE WEIGHT, 6.4 INTERVAL
!
PATTERN 22    0     10    0     0     6.9   6.9   0     0     0.75
!--------------------------------------------------------------
!23
!     SOLID LINE
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, SPACED 0.5
!     APART AT 13.0 INTERVAL
!
PATTERN 23    0     10    0     0     13.5  13.5  0     0     0.75
!--------------------------------------------------------------
!24/25
!     11.3 DASH, 1.5 SPACE
!     CROSSTIES: 1.5 LONG, 0.2 LINE WEIGHT, 6.4 INTERVAL
!
PATTERN 24    0     0     0     0     12.8  11.3  0     0     0
PATTERN 25    9     0     1     0     12.8  4.9   0     0.75  0
!--------------------------------------------------------------
!26/27
!     24.5 DASH, 1.5 SPACE
!     CROSSTIES: 1.5 LONG, 0.15 LINE WEIGHT, 13 INTERVAL
!
PATTERN 26    0     0     0     0     13.0  11.5  0     0     0
PATTERN 27    9     0     0     0     13.0  11.5  0     0.75  0
!--------------------------------------------------------------
!28
!     SOLID LINE
!     CROSSTIES: 1.2 LONG, 0.2 LINE WEIGHT, 3.2 INTERVAL
!
PATTERN 28    0     12    0     0     3.2   3.2   0     0     0.6
!--------------------------------------------------------------
!29
!     3.3 DASH, 0.5 SPACE
!
PATTERN 29    0     0     0     0     3.9   3.3   0     0     0
!--------------------------------------------------------------
!30
!     SOLID LINE
!     SYMBOL: 25.0 INTERVAL
!
PATTERN 30    0     2     0     0     25.0  25.0  0     0     1.375
!--------------------------------------------------------------
!31
!     4 DASHES 1.0 LONG, 0.5 SPACE
!     DOTS: 0.8 DIAMETER, 7 APART
!
PATTERN 31    0     6     3     0     7.0   1.0   0.5   0     0.2
!--------------------------------------------------------------
!32
!     2.5 DASH, 0.5 SPACE
!
PATTERN 32    0     0     0     0     3.0   2.5   0     0     0
!--------------------------------------------------------------
!33
!     5.0 DASH, 1.3 SPACE
!     CROSS: 1.3, 45 DEGREE ANGLE
!
PATTERN 33    0     5     0     0     6.3   5.0   1.3   0     0.65
!--------------------------------------------------------------
!34
!     7.6 DASH, 1.3 SPACE, 2.5 DASH
!
PATTERN 34    0     0     0     1     16.5  7.6   2.5   0     0
!--------------------------------------------------------------
!35
!     SOLID DOTS: 0.6 DIAMETER, 2.5 SPACE BETWEEN CENTRES
!
PATTERN 35    19    0     0     0     2.5   2.5   0     0.15  0
!--------------------------------------------------------------
!36
!     7.6 DASH, 1.3 SPACE, 2.5 DASH
!
PATTERN 36    0     0     0     0     12.7  7.6   2.5   0     0
!--------------------------------------------------------------
!37
!     5.0 DASH, 1.0 SPACE
!
PATTERN 37    0     0     0     0     6.0   5.0   0     0     0
!--------------------------------------------------------------
!38
!     6.0 DASH, 3.8 SPACE
!
PATTERN 38    0     0     0     0     9.8   6.0   0     0     0
!--------------------------------------------------------------
!39
!     3.8 DASH, 1.3 SPACE
!
PATTERN 39    0     0     0     0     5.1   3.8   0     0     0
!--------------------------------------------------------------
!40
!     DOTS: 0.25 DIAMETER, 0.75 SPACE BETWEEN CENTRES
!
PATTERN 40    8     0     0     0     0.75  0.75  0     0.063 0
!--------------------------------------------------------------
!41
!     2.5 DASH, 1.3 SPACE
!     DOTS: 0.3 DIAMETER, CENTRED IN SPACE
PATTERN 41    0     7     0     0     3.8   2.5   1.3   0     0.075
!--------------------------------------------------------------
!42/43
!     7.6 DASH, 0.5 SPACE
!     SPURS: 0.5 LONG, 1.0 SPACE
PATTERN 42    0     0     0     0     8.1   7.6   0     0     0
PATTERN 43    11    0     0     0     1.0   1.0   0     0.5   0
!--------------------------------------------------------------
!44/45
!     7.6 DASH, 0.5 SPACE
!     SPURS: 0.5 LONG, 2.0 SPACE
PATTERN 44    0     0     0     0     8.1   7.6   0     0     0
PATTERN 45    11    0     0     0     2.0   2.0   0     0.5   0
!--------------------------------------------------------------
!46/47
!     7.6 DASH, 0.5 SPACE
!     SPURS: 0.5 LONG, 3.8 SPACE
PATTERN 46    0     0     0     0     8.1   7.6   0     0     0
PATTERN 47    11    0     0     0     3.8   3.8   0     0.5   0
!--------------------------------------------------------------
!
!  Define a AC_D table
!
ACD TABLE      1              
!
ACD R   1      Profile_bearing     0.0      360.0
ACD R   2      Profile_length      0.0      1.0E37
ACD I   3      Clutter_index       0        3
