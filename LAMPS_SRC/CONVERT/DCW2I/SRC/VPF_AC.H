
struct ac_type {
  short	ac;
  short	fc;
  char *acname;
  char  actype;
  struct ac_type *next;
};

typedef struct ac_type ac_element;
typedef ac_element     *ac_ptr;

