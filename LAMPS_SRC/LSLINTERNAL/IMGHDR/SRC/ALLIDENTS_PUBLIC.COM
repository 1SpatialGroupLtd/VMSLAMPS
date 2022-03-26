$! command file to get IDENTs for all executables on the issue tree
$! to keep BAe happy for Saudi
$! Written 					PGH	09-Nov-1990
$! Public root version				PGH	03-Feb-1991
$!
$ last_dir=""
$ imghdr_read=="$lsl$source_root:[lslinternal.imghdr]imghdr_read"
$ write sys$output "Ident list for LSL$PUBLIC_ROOT:[*.EXE]*.EXE on ",f$time()
$ set noon
$ loop:
$ nextfile=f$search("LSL$PUBLIC_ROOT:[*.EXE]*.EXE")
$ if nextfile.eqs."" then goto exit
$ this_dir=f$parse(nextfile,,,"directory")-"["-".EXE]"
$ if this_dir.nes.last_dir
$ then
$    write sys$output ""
$    write sys$output "Package ",this_dir
$    write sys$output ""
$    last_dir=this_dir
$ endif
$ imghdr_read 'nextfile'
$ goto loop
$exit:
