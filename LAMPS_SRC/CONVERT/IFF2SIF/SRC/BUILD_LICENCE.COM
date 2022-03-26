$ libr/create licence_lib
$ fort scitex_licence.src
$ libr/repl licence_lib scitex_licence
$ link/share=scitex_licence sys$input:/opt
licence_lib/include =(scitex_licence)
UNIVERSAL=scitex_licence
