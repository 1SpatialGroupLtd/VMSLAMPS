$i2ntf/wat/ou=test2/lo -
/par=here:test.par -
 here:collect_test1.iff ntfspr2.ntf
$!/dbname="jmcdb" -
$!/fix -
$!/fr=here:nww  
$!/att=nww_ntf.ntf_attr -
$!/FEAT=X.CLS
$!/xy_l=15/xy_m=1.0/z_m=1.0/z_le=10/z_u=3/z_d=888
