
struct fc_type {
  short fc;
  char  *vpftable;
  char  *pname;
  int  	pval;
  char  *sname;
  int	sval;
  struct fc_type *next;
};

typedef struct fc_type fc_element;
typedef fc_element     *fc_ptr;

