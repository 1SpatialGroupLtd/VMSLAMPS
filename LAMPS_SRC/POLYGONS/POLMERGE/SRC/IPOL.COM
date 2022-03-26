$ SET NOON
$ SI LSL$SOURCE_ROOT:[POLYGONS.POLMERGE]
$ ipolygon /log ptst2.ifj /OUTPUT = PTST2IPOL
$ ipolygon /log ptst9.ifj /OUTPUT = PTST9IPOL
