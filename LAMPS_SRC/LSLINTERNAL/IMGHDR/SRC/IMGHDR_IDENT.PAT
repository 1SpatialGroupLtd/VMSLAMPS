$ PATCH IMGHDR_IDENT/ABS/NONEW
verify/long 1fc=0ffffffff
verify/word 0=0a8
verify/word 6=058
deposit/byte 80=6
deposit/ascii 81='V2.'
deposit/ascii 84='3-0'
update
exit
