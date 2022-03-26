struct edge_type {
  coordinate_type *st_ptr;
  coordinate_type *end_ptr;
  int 	reverse;
  int 	npts;
  struct edge_type *next;
};

struct check_type {
  int 	edge;
  struct check_type *next;
};

typedef struct check_type check_element;
typedef check_element     *check_ptr;
typedef struct edge_type edge_element;
typedef edge_element     *edge_ptr;
