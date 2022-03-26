$ macro hw_names
$ if f$getsyi("arch_name").eqs."Alpha"
$ then
$   link/sysexe hw_names/exe=hw_names_axp.exe
$ else
$   link hw_names,sys$system:sys.stb
$ endif
$ purge/log hw_names*.*
