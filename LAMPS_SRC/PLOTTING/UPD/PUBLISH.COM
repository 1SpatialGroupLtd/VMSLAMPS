$open pubdat publish.dat
$assign pubdat sys$command
$publish
$deas sys$command
$close pubdat
