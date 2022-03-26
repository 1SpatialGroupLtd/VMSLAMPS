$define lsl$polygons_polmax 10000
$define lsl$polygons_average_sides 10
$define lsl$fill_cutsmax 250000
$define lsl$fill_pointsmax 20000
$ipolygon=="$lsl$source_root:[polygons.ipolygon]ipolygon"
$si lsl$source_root:[polygons.ipolygon]
$!ilink/struct uk_urban.brk uk_urban.str
$IPOLYGON/ONEARM=DELETE/POLYGONS=(OUT:UK_URBAN.POL,LABEL)-
/LITES2/LOG/SEED=(USE:FSN,PAIR:HERE:uk_urban.PAIR,FC:(3755:3779)) UK_URBAN.STR
