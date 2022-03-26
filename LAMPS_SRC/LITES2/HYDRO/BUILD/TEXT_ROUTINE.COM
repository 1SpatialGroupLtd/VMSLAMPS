$fortran draw_text.src
$fortran blank_text.src
$link/share=text_routine draw_text,blank_text,sys$input:/opt
universal=draw_text,blank_text
$delete draw_text.obj;*,blank_text.obj;*
$purge text_routine.exe
$exit
