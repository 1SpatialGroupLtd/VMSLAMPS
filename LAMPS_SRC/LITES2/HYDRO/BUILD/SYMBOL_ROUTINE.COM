$fortran draw_symbol.src
$fortran blank_symbol.src
$link/share=symbol_routine draw_symbol,blank_symbol,sys$input:/opt
universal=draw_symbol,blank_symbol
$delete draw_symbol.obj;*,blank_symbol.obj;*
$purge symbol_routine.exe
$exit
