#ifndef STRDESC
#  define STRDESC

extern void desc_to_str (struct dsc$descriptor *desc, char *instr);
extern void str_to_desc (char *instr, struct dsc$descriptor *desc);

#endif
