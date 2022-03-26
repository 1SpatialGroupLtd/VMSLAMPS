$ SET NOON
$ SI LSL$SOURCE_ROOT:[POLYGONS.POLMERGE]
$ ASS LSL$SOURCE_ROOT:[POLYGONS.POLMERGE] LSL$LOOKUP
$ POLMERGE polmelutp1 polmelutp2 /mer=by_loo/elim=by_loo -
 /area=(mer:10,elim:10) /lookup=two.dat
$ POLMERGE polmelutp2 polmelutp3 /mer=by_loo/elim=by_loo -
 /area=(mer:10,elim:10) /lookup=three.dat
