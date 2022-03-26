$util="TRIGRID"
$package="DTMCREATE"
$set noon
$SD LSL$SOURCE_ROOT:['PACKAGE'.'UTIL']
$CREATE/DIR [.CMSLIB]
$CREATE/DIR [.SRC]
$CMS CREATE LIBRARY [.CMSLIB]
$CMS SET LIBRARY [.CMSLIB]
$CMS CREATE ELEMENT *.F    "Fortran source for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.C    "C source for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.UPD  "Update file for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.SRC  "Fortran source for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.MAR  "Macro source for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.COM  "Procedure for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.CMN  "Common block for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.H    "Include file for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.PAR  "Parameters for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.OPT  "Linker options for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.CLD  "Command line definition for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.MES  "Message definitions for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.MAPID "Map ID listing for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.TREE  "Program structure tree created from mapid"
