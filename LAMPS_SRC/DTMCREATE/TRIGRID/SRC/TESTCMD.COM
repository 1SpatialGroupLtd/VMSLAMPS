FILEIN NCC_DTM
ZLIMITS 150 500
TRIANGLE_LIMITS 5 15
ENABLE DIAGNOSTICS
WINDOW 0 0 200 200
SIDELENGTH 2.1 1.5
SHOW ENABLE
SHOW LIMITS
SHOW FILES
SHOW WINDOW
FILEOUT TESTDTM
GO