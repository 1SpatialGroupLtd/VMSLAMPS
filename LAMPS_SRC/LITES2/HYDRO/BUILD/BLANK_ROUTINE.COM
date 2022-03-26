$fort blank_routine.src
$link/share blank_routine,obj:lites2/include=packer,sys$input:/opt
universal=draw_text,draw_symbol,blank_text,blank_symbol
lsl$library:lsllib/lib
$exit
