/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    S.Townrow, 26-May-1992					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*                     V P F _ G E N E R A L                            */
/*									*/
/* Part of DCW (VPF) database interface library              		*/
/*									*/
/* All these routines have been written by ESRI who designed the VPF	*/
/* format. They are a mess but at least they work !			*/
/*									*/
/************************************************************************/

#module	VPF_GENERAL "26MY92"

/*----------------------------------------------------------------------*/
/*	Include definitions						*/
/*----------------------------------------------------------------------*/
#include <stat.h>
#include <stdio.h>
#include <string.h>
#include "mespar.h"
#include "vpf_table.h"
#include "dcw2imsg.h"

#define HEAP_OVERHEAD 4			     /* per heap block byte overhead */
int STORAGE_BYTE_ORDER = LEAST_SIGNIFICANT;  /* default */
extern int verbose;
extern int zone;
int prev_addr=0;


/*----------------------------------------------------------------------*/
/* VOID vpffree								*/
/*......................................................................*/
/*									*/
/* A free which reports failure						*/
/*----------------------------------------------------------------------*/
void *vpffree(void *p)
{
  int l= *(((int *)p)-1);
  int ok, *poslen;

  poslen = (int)p-4;
  ok = lib$free_vm(&l,&poslen);
}

/*----------------------------------------------------------------------*/
/* VOID vpfmalloc							*/
/*......................................................................*/
/*									*/
/* A malloc which reports failure					*/
/*----------------------------------------------------------------------*/
void *vpfmalloc( unsigned long size )
{
   int *p;
   int ok;
   int l = size+sizeof(int);
   ok = lib$get_vm(&l,&p);
   if (ok!=1) {
     lsl_putmsg(&DCW2I__NOMEMORY);
     lib$show_vm(&3);
     exit(1);
   }
   *p=l;
   prev_addr=p+1;
   return p+1;
 }



/*----------------------------------------------------------------------*/
/* CHAR rightjust							*/
/*......................................................................*/
/*									*/
/* Given a string, this routine will right justify it			*/
/*----------------------------------------------------------------------*/
char *rightjust( char *str )
{
   register int  len,i;

   len = strlen(str);
   i = len - 1;
   while ((i>0) && ((str[i]==0) || (str[i]==' '))) i--;
   if (i < (len-1)) str[i+1] = '\0';
   for (i=0;i<strlen(str);i++) if (str[i]=='\n') str[i] = '\0';
   return str;
}



/*----------------------------------------------------------------------*/
/* VOID swap_two							*/
/*......................................................................*/
/*									*/
/* To reverse two bytes							*/
/*----------------------------------------------------------------------*/
void swap_two ( char *in, char *out )
{
  out[0] = in[1] ;
  out[1] = in[0] ;
}



/*----------------------------------------------------------------------*/
/* VOID swap_four							*/
/*......................................................................*/
/*									*/
/* To reverse four bytes						*/
/*----------------------------------------------------------------------*/
void swap_four ( char *in, char *out )
{
  out[0] = in[3] ;
  out[1] = in[2] ;
  out[2] = in[1] ;
  out[3] = in[0] ;
}



/*----------------------------------------------------------------------*/
/* VOID swap_eight							*/
/*......................................................................*/
/*									*/
/* To reverse eight bytes						*/
/*----------------------------------------------------------------------*/
void swap_eight ( char *in, char *out )
{
  out[0] = in[7] ;
  out[1] = in[6] ;
  out[2] = in[5] ;
  out[3] = in[4] ;
  out[4] = in[3] ;
  out[5] = in[2] ;
  out[6] = in[1] ;
  out[7] = in[0] ;
}



/*----------------------------------------------------------------------*/
/* static CHAR cpy_del							*/
/*......................................................................*/
/*									*/
/* Function to get string until delimeter				*/
/*----------------------------------------------------------------------*/
static char *cpy_del(char *src, char delimiter, long int *ind )
{
  long int i, skipchar ;
  char *temp, *tempstr ;

  /* remove all blanks ahead of good data */

  skipchar = 0 ;
  while ( src[skipchar] == SPACE || src[skipchar] == TAB )
    skipchar++ ;

  temp = &src[skipchar];

  /* If the first character is a COMMENT, goto LINE_CONTINUE */

  if ( *temp == COMMENT ) {
    while ( *temp != LINE_CONTINUE && *temp != END_OF_FIELD && *temp != '\0'){
      temp++ ;
      skipchar ++ ;
    }
    skipchar++ ;
    temp++ ;		/* skip past LC, EOF, or NULL */
  }

  /* Start with temporary string value */

  tempstr = (char *)vpfmalloc ( strlen ( temp ) + 10 ) ;

  if ( *temp == '"' ) {	/* If field is quoted, do no error checks */

    temp++ ; 	  /* skip past quote character */
    skipchar++ ;  /* update the position pointer */

    for ( i=0 ; *temp != '\0'; temp++,i++) {
      if ( *temp == LINE_CONTINUE || *temp == TAB ) {
	temp++ ;
	skipchar++ ;
      } else if ( *temp == '"' )
	break ;
      /* Now copy the char into the output string */
      tempstr[i] = *temp ;
    }
    tempstr[i] = (char) NULL ;		/* terminate string */
    *ind += ( i + skipchar + 2) ;	/* Increment position locate past */
    return tempstr ;			/* quote and semicolon */
  }

  /* search for delimiter to end, or end of string */

  i=0 ;	/* initialize */

  if ( *temp != END_OF_FIELD ) {	/* backward compatability check */

    for ( i=0; *temp != '\0';temp++,i++){/* Stop on NULL*/

      if ( ( *temp == LINE_CONTINUE && *(temp+1) == '\n') ||  *temp == TAB ) {
	temp++ ;
	skipchar++ ;
      } else if ( *temp == delimiter )
	break ;					/* break for delimiter  */
      /* Now copy the char into the output string */
      tempstr[i] = *temp ;
    }
                             /* Eat the delimiter from ind also */
    *ind += ( i + skipchar + 1) ;	/* Increment position locate */
  }	
  tempstr[i] = (char) NULL ;		/* terminate string */   
  return tempstr;
}



/*----------------------------------------------------------------------*/
/* CHAR get_string							*/
/*......................................................................*/
/*									*/
/* Function to get string by calling cpy_del				*/
/*----------------------------------------------------------------------*/
char *get_string(long int *ind,char *src,char delimeter )
{ char *temp;
  temp  = cpy_del(&src[*ind],delimeter, ind);
  if( ! strcmp ( temp, TEXT_NULL ))
    strcpy ( temp, "" ) ;
  return temp;
}



/*----------------------------------------------------------------------*/
/* CHAR get_char							*/
/*......................................................................*/
/*									*/
/* Function to get a char ignoring whitespaces				*/
/*----------------------------------------------------------------------*/
char get_char(long int *ind, char *src)
{  char temp;
   while ( src[*ind] == SPACE || src[*ind] == TAB ) (*ind)++ ;
   temp  = src[*ind];
   *ind += 2;
   return temp;
}



/*----------------------------------------------------------------------*/
/* long INT get_number							*/
/*......................................................................*/
/*									*/
/* Function to covert text string into a number				*/
/*----------------------------------------------------------------------*/
long int get_number(long int *ind, char *src,char delimeter)
{  char *temp;
   long int  num;
   temp  = cpy_del(&src[*ind],delimeter, ind);
   if (strchr(temp, VARIABLE_COUNT ) == NULL)
      num = atoi(temp);
   else
      num = -1;
   free(temp);
   return num;
}




/*----------------------------------------------------------------------*/
/* LONG INT create_db_table						*/
/*......................................................................*/
/*									*/
/* Initialise table and read it's header and data			*/
/*----------------------------------------------------------------------*/
vpf_table_type create_db_table(char *filename)
{
  vpf_table_type table;
  char     *idxname;
  FILE     *fp, *fopen();
  long int len,i,j,count;
  long int tablesize,idxsize;
  long int mtemp,*mptr;
  unsigned long int ulval;
  stat_t   statbuf;

  fp = fopen(filename,"r");
  if (fp==NULL) {
    table.success = FAIL;
    return(table);
  }

  table.path = vpfmalloc(strlen(filename+1));
  strcpy(table.path,filename);
  if (verbose) printf("Reading %s\n",table.path);

  /* Populate table structure with correct data, either for read or write */

  table.fp = fp;
  table.mode = Read;
  table.reclen = parse_data_def(&table);
  if (!table.reclen) {
    fclose(fp);
    table.success = FAIL;
    return (table);
  }

  /* get the file length */
  if (stat(filename,&statbuf) < 0 ) {
    lsl_putmsg(&DCW2I__STATFILE,&filename[0]);
    free(table.path);
    fclose(table.fp);
    table.fp = NULL;
    table.success = FAIL;
    return (table);
    }
  tablesize = statbuf.st_size ;

  /* calculate number of rows in file */
  if (table.reclen > 0) {
    table.xstorage = COMPUTE;
    table.nrows = (tablesize - table.ddlen)/table.reclen;
    table.xfp = (FILE *) NULL ;
  }
  else { /* Index file */
    idxname = vpfmalloc(strlen(filename));
    strcpy(idxname,filename);
    idxname[strlen(filename)-1] = 'X';
    table.xfp = fopen(idxname,"rb");

    if (table.xfp) {
      Read_Vpf_Int (&(table.nrows), table.xfp, 1 ) ;
      Read_Vpf_Int (&ulval, table.xfp, 1 ) ;
      idxsize = table.nrows*sizeof(index_cell) + 10L;
      table.xstorage = RAM;
      table.index = (index_type)vpfmalloc(idxsize);
      for (i=0;i<table.nrows;i++) {
	Read_Vpf_Int (&(table.index[i].pos), table.xfp, 1) ;
	Read_Vpf_Int (&(table.index[i].length),table.xfp,1 ) ;
      }
      fclose(table.xfp);
    }
    else {
      perror(idxname);
      free(idxname);
      for (i = 0; i < table.nfields; i++)
	free(table.header[i].name);
      free(table.header);
      free(table.path);
      fclose(table.fp);
      table.fp = NULL;
      table.success = FAIL;
      return (table);
    }
    free(idxname);
  }

  /* read the data from the table */

  if (tablesize + table.nrows * table.nfields * HEAP_OVERHEAD < MAXINT) {
    fseek(table.fp,index_pos(1,table),SEEK_SET);
    /*context = 0;
    while (lib$find_vm_zone(&context,&z)==1) {
      lib$show_vm_zone(&z,&3);
    }*/
    /*lib$show_vm();*/
    table.row = (row_type *)vpfmalloc((table.nrows+1)*sizeof(row_type));
    /*lib$show_vm();*/
    for (i=0;i<table.nrows;i++) {
      table.row[i] = read_next_row(table);
      /*lib$show_vm();
      if ((i % 10000)==0) {
	printf("row = %d\n",i);
	lib$show_vm();
      }*/
    }
    fclose(table.fp);
  }

  table.status = OPENED;

  /*display_table(&table);*/

  /* determine maximum number of elements for variable length fields */
  /*table.maxwid = (long int *)vpfmalloc(sizeof(long int)*table.nfields);*/
  /*mptr = table.maxwid;*/
  /*for (i=0;i<table.nfields;i++) {*/
  /*mtemp = 0;*/
    /*for (j=0;j<table.nrows;j++)*/
      /*if (table.row[j][i].count>mtemp) mtemp = table.row[j][i].count;*/
      /*printf("Max width of field %4d is %4d\n",i,mtemp);*/
    /* *mptr = mtemp;*/
    /*mptr++;*/
  /*}*/

/*  if (writetable!=0) {
    write_db_table(&table);
  }*/

  fclose(fp);
  table.success = SUCCESS;
  return (table);
}



/*----------------------------------------------------------------------*/
/* VOID display_table							*/
/*......................................................................*/
/*									*/
/* Diplay table header and data - for debugging purposes		*/
/*----------------------------------------------------------------------*/
void display_table(vpf_table_type *table)
{
  int i,j,k,count;
  int yr,mon,day;

  coordinate_type ctemp,*cptr;
  id_triplet_type ktemp,*kptr;

  for (i=0;i<table->nfields;i++)
      printf("%-12s=%c,%2d,%c,%s\n",table->header[i].name,
	                           table->header[i].type,
	                           table->header[i].count,
	                           table->header[i].keytype,
	                           table->header[i].description);

  /*return;*/

  for (i=0;i<table->nrows;i++) {
    for (j=0;j<table->nfields;j++) {
      count = table->row[i][j].count;
      switch (table->header[j].type) {
	 case 'T':
	    printf(" %-20.20s ",(char *)table->row[i][j].ptr);
	    break;
	 case 'I':
	    printf("%4d ",*(long int *)table->row[i][j].ptr);
	    break;
	 case 'S':
	    printf("%4d ",*(short int *)table->row[i][j].ptr);
	    break;
	 case 'F':
	    printf("%10.5f",*(float *)table->row[i][j].ptr);
	    break;
	 case 'R':
	    printf("%10.5f",*(double *)table->row[i][j].ptr);
	    break;
	 case 'D':
	    sscanf((char *)table->row[i][j].ptr,"%4d%2d%2d",&yr,&mon,&day);
	    printf("%2d/%2d/%4d ",day,mon,yr);
	    break;
	 case 'C':
	    cptr = (coordinate_type *)table->row[i][j].ptr;
	    printf("\n");
	    ctemp = *cptr;
	    printf("%10.5f %10.5f\n",ctemp.x,ctemp.y);
	    cptr++;
	    for (k=1; k < count; k++ ) {
	      ctemp = *cptr;
	      cptr++;
	    }
	    if (count>2) printf(" ....\n");
	    if (count>1) printf("%10.5f %10.5f\n",ctemp.x,ctemp.y);
	    break;
	 case 'Z':
	    printf("%10.1e %10.1e ",*(tri_coordinate_type *)table->row[i][j].ptr);
	    break;
	 case 'B':
	    printf("%10.1e %10.1e ",*(double_coordinate_type *)table->row[i][j].ptr);
	    break;
	 case 'Y':
	    printf("%10.1e %10.1e ",*(double_tri_coordinate_type *)table->row[i][j].ptr);
	    break;
	 case 'K':   /* ID Triplet */
	    kptr = (id_triplet_type *)table->row[i][j].ptr;
	    ktemp = *kptr;
	    printf("(%d,%d,%d)",ktemp.id,ktemp.tile,ktemp.exid);

	    /* printf("%4d ",*(id_triplet_type *)table->row[i][j].ptr);*/
	    break;
	 case 'X':
	    break;
	  default:
	    printf("%s%s%s >>> read_next_row: no such type < %c >",C_ERROR,
		table->path,table->name,table->header[i].type ) ;
	    break ;
	  }   /* end of switch */
    }
    printf("\n");
  }
}



/*----------------------------------------------------------------------*/
/* long INT parse_data_def						*/
/*......................................................................*/
/*									*/
/* This function parses a table's data definition and creates a header	*/
/* in memory that is associated with the table.				*/
/*----------------------------------------------------------------------*/
long int parse_data_def( vpf_table_type *table )
{
   register long int n,i;
   long int p, k;
   char *buf,*des,*nar,*vdt, *tdx, *doc, byte ;/*temporary storage */
   char end_of_rec;
   int status;
   long int ddlen;
   long int reclen = 0;

   fread(&ddlen,sizeof(ddlen),1,table->fp);
   if ( ddlen < 0 ) {
     lsl_putmsg(&DCW2I__BADVPFLEN);
     return NULL ;
   }
   
   /* Check the next byte to see if the byte order is specified */
   fread(&byte,1,1,table->fp);
   p=0;
   table->byte_order = LEAST_SIGNIFICANT; /* default */
   switch (toupper(byte)) {
   case 'L':
     p++;
     break;
   case 'M':
     table->byte_order = MOST_SIGNIFICANT;
     p++;
     break;
   }
   if (MACHINE_BYTE_ORDER != table->byte_order) {
     k = ddlen;
     swap_four((char *)&k,(char *)&ddlen);
   }
   STORAGE_BYTE_ORDER = table->byte_order;
   
   /* header without first 4 bytes */
   table->ddlen = ddlen + sizeof (long int) ;
   buf = (char *)vpfmalloc((ddlen+3)*sizeof(char));
   buf[0] = byte; /* already have the first byte of the buffer */
   Read_Vpf_Char(&buf[1],table->fp,ddlen-1) ;
   

   buf[ddlen-1] = '\0'; /* mark end of string for reading functions */
   if ( buf[p] == ';' )
     p++; /* buf[p] is semi-colon */
   des = get_string(&p,buf,COMPONENT_SEPERATOR );
   strncpy(table->description,des,80);
   free(des);
   nar = get_string(&p,buf,COMPONENT_SEPERATOR );
   strncpy(table->narrative ,nar,12);
   free(nar);
   n = 0 ;
   /* get number of fields */
   for (i=p; i < ddlen;i++)
     if ( buf[i] == LINE_CONTINUE )
       i++ ;	/* skip past line continue, and next character */
     else if (buf[i] == END_OF_FIELD ) 		/* Found end of field */
	n++;					/* increment nfields */
     else if (buf[i] == COMMENT )		/* skip past comments */
       while ( buf[i] != LINE_CONTINUE &&
	       buf[i] != END_OF_FIELD &&
	       buf[i] != '\0')
	 i++ ;					/* increment i */

   table->nfields = n ;
   table->header = (header_type)vpfmalloc((n+1)*sizeof(header_cell));

   for(i=0;i<n;i++) {
     end_of_rec = FALSE;
     table->header[i].name  = get_string(&p,buf, FIELD_COUNT);  /*****/
     rightjust(table->header[i].name);
     table->header[i].type  = toupper(get_char  (&p,buf));
     table->header[i].count = get_number(&p,buf,FIELD_SEPERATOR );

     if ( i == 0 )
       if ( strcmp ( table->header[0].name, "ID" ) ) {
	 lsl_putmsg(&DCW2I__NOID);
	 return NULL ;
       }

     if(table->header[i].count == -1)
       reclen = -1;			/* set reclen to variable len flag */

     /* Now set null values and add up record length, if fixed length */

     status = 0;

     switch (table->header[i].type) {
     case 'I':
       if ( reclen >= 0 )
	 reclen += (sizeof(long int)*table->header[i].count);
       table->header[i].nullval.Int = NULLINT ;
       break;
     case 'S':
       if ( reclen >= 0 )
	 reclen += (sizeof(short int)*table->header[i].count);
       table->header[i].nullval.Short = NULLSHORT ;
       break;
     case 'F':
       if ( reclen >= 0 )
	 reclen += (sizeof(float)*table->header[i].count);
       table->header[i].nullval.Float = NULLFLOAT ;
       break;
     case 'R':
       if ( reclen >= 0 )
	 reclen += (sizeof(double)*table->header[i].count);
       table->header[i].nullval.Double = NULLDOUBLE ;
       break;
     case 'T':
       if ( reclen >= 0 ) { 		/* if fixed length */
	 reclen += (sizeof(char)*table->header[i].count);
	 table->header[i].nullval.Char =
	   (char *) vpfmalloc ( table->header[i].count + 1 ) ;
	 for ( k=0; k < table->header[i].count; k++ )
	   table->header[i].nullval.Char[k] = NULLCHAR ;
	 table->header[i].nullval.Char[k] = (char) NULL ;
       } else {			/* variable length */
	 table->header[i].nullval.Char =
	   (char *) vpfmalloc ( VARIABLE_STRING_NULL_LENGTH + 1 ) ;
	 for ( k=0; k < VARIABLE_STRING_NULL_LENGTH ; k++ )
	   table->header[i].nullval.Char[k] = NULLCHAR ;
	 table->header[i].nullval.Char[k] = (char) NULL ;
       }
       break;
     case 'C':
       if ( reclen >= 0 )
	 reclen += (sizeof(coordinate_type)*table->header[i].count);
       table->header[i].nullval.Other = (char) NULL ;
       break;
     case 'Z':
       if ( reclen >= 0 )
	 reclen += (sizeof(tri_coordinate_type)*table->header[i].count);
       table->header[i].nullval.Other = (char) NULL ;
       break;
     case 'B':
       if ( reclen >= 0 )
	 reclen += (sizeof(double_coordinate_type)*table->header[i].count);
       table->header[i].nullval.Other = (char) NULL ;
       break;
     case 'Y':
       if ( reclen >= 0 )
	 reclen +=
	   (sizeof(double_tri_coordinate_type)*table->header[i].count);
       table->header[i].nullval.Other =(char) NULL;
       break;
     case 'D':
       if ( reclen >= 0 )
	 reclen += ((sizeof(date_type)-1)*table->header[i].count);
       strcpy ( table->header[i].nullval.Date, NULLDATE ) ;
       break;
     case 'K':
       reclen = -1;
       table->header[i].nullval.Other = (char) NULL ;
       break;
     case 'X':
       /* do nothing */
       table->header[i].nullval.Other = (char) NULL ;
       break ;
     default:
       lsl_putmsg(&DCW2I__DATATYPE,&table->header[i].type);
       status = 1;
       break ;
     } /** switch type **/

     if (status) return NULL;

     table->header[i].keytype     = get_char  (&p,buf);
     des = get_string(&p,buf, FIELD_SEPERATOR );
     rightjust(des);
     strncpy(table->header[i].description,des,80);
     free(des);
     vdt = get_string(&p,buf, FIELD_SEPERATOR );
     strncpy(table->header[i].vdt,vdt,12);
     free(vdt);

     tdx = get_string(&p,buf, FIELD_SEPERATOR ) ;
     if ( ! strcmp ( tdx, "" ) ) {
       table->header[i].tdx = (char *) NULL ;
       end_of_rec = TRUE;
     } else {
       if (strcmp(tdx,"-") != 0) {
	  table->header[i].tdx = vpfmalloc ( strlen ( tdx ) ) ;
	  strcpy (table->header[i].tdx, tdx );
       } else table->header[i].tdx = (char *)NULL;
     }
     free(tdx);
     if (!end_of_rec) {
	doc = get_string(&p,buf, FIELD_SEPERATOR ) ;
	if ( ! strcmp ( doc, "" ) ) {
	  table->header[i].narrative = (char *) NULL ;
	  end_of_rec = TRUE;
	} else {
	  if (strcmp(doc,"-") != 0) {
	     table->header[i].narrative = vpfmalloc ( strlen(doc) ) ;
	     strcpy (table->header[i].narrative, doc );
	  } else table->header[i].narrative = (char *)NULL;
	}
	free(doc);
     } else table->header[i].narrative = (char *)NULL;
     p += 1; /** eat semicolon **/
    }
   free(buf);
   return reclen;
}




/*----------------------------------------------------------------------*/
/* long INT VpfRead							*/
/*......................................................................*/
/*									*/
/* Read the given datatype from the input file				*/
/*----------------------------------------------------------------------*/
long int VpfRead ( void *to, VpfDataType type, long int count, FILE *from )
{
  long int retval , i ;

  switch ( type ) {
  case VpfChar:
    retval = fread ( to, sizeof (char), count, from ) ;
    break ;
  case VpfShort:
    {
      short int stemp ,
                *sptr = (short *) to ;
      for ( i=0; i < count; i++ ) {
	retval = fread ( &stemp, sizeof (short), 1, from ) ;
	if (STORAGE_BYTE_ORDER != MACHINE_BYTE_ORDER)
	   swap_two ( &stemp, sptr ) ;
	else
	   *sptr = stemp;
        sptr++ ;
      }
    }  
    break ;
  case VpfInteger:
    {
      if (STORAGE_BYTE_ORDER != MACHINE_BYTE_ORDER) {
	long int itemp,
	  *iptr = (long int *) to ;
	for ( i=0; i < count; i++ ) {
	  retval = fread ( &itemp, sizeof (long int), 1, from ) ;
	  swap_four ( &itemp, iptr ) ;
	  iptr++ ;
	}
      } else {
	retval = fread ( to, sizeof (long int), count, from ) ;
      }
    }  
    break ;
  case VpfFloat:
    {
      unsigned char *ftemp;
      float *fptr = (float *) to ;
      float IEEE_VAX_S();
      for ( i=0; i < count; i++ ) {
        retval = fread ( &ftemp, sizeof (float), 1, from ) ;
	if (STORAGE_BYTE_ORDER != MACHINE_BYTE_ORDER)
	   swap_four ( &ftemp, fptr ) ;
	else
	  /*printf("%10.5f ",IEEE_VAX_S(&ftemp));*/
	  *fptr = IEEE_VAX_S(&ftemp);
	fptr++ ;
      }
    }
    break ;
  case VpfDouble:
    {
      double dtemp ,
             *dptr = (double *) to ;
      for ( i=0; i < count; i++ ) {
        retval = fread ( &dtemp, sizeof (double), 1, from ) ;
	if (STORAGE_BYTE_ORDER != MACHINE_BYTE_ORDER)
	   swap_eight ( &dtemp, dptr ) ;
	else
	   *dptr = dtemp;
	dptr++ ;
      }
    }
    break ;
  case VpfDate:
    {
      date_type *dp = (date_type *) to ;
      retval = fread(dp,sizeof(date_type)-1,count,from);
    }
    break ;
  case VpfCoordinate:
    {
      if (STORAGE_BYTE_ORDER != MACHINE_BYTE_ORDER) {
	 coordinate_type ctemp ,
		      *cptr = (coordinate_type *) to ;
	 for ( i=0; i < count; i++ ) {
	   retval = fread ( &ctemp, sizeof (coordinate_type), 1, from ) ;
	   swap_four ( &ctemp.x, &cptr->x ) ;
	   swap_four ( &ctemp.y, &cptr->y ) ;
	   cptr++ ;
	 }
      } else {
	 unsigned char *ctmp;
	 float IEEE_VAX_S();
	 coordinate_type ctemp , *cptr = (coordinate_type *) to ;
	 for ( i=0; i < count; i++ ) {
	   retval = fread ( &ctmp, sizeof (float), 1, from );
	   ctemp.x = IEEE_VAX_S(&ctmp) ;
	   retval = fread ( &ctmp, sizeof (float), 1, from );
	   ctemp.y = IEEE_VAX_S(&ctmp) ;
	   /*printf("%10.5f %10.5f",ctemp.x,ctemp.y);*/
	   *cptr = ctemp;
	   cptr++ ;
	 }
	 /*printf("\n");*/
       }
    }
    break ;
  case VpfDoubleCoordinate:
    {
      double_coordinate_type dctemp ,
                             *dcptr = (double_coordinate_type *) to ;
      for ( i=0; i < count; i++ ) {
        retval = fread ( &dctemp, sizeof (double_coordinate_type), 1, from ) ;
	if (STORAGE_BYTE_ORDER != MACHINE_BYTE_ORDER) {
	   swap_eight ( &dctemp.x, &dcptr->x ) ;
	   swap_eight ( &dctemp.y, &dcptr->y ) ;
	} else {
	   dcptr->x = dctemp.x;
	   dcptr->y = dctemp.y;
	}
	dcptr++ ;
      }
    }
    break ;
  case VpfTriCoordinate:
    {
      unsigned char *ttmp;
      float IEEE_VAX_S();
      tri_coordinate_type ttemp ,
                          *tptr = (tri_coordinate_type *) to ;
      for ( i=0; i < count; i++ ) {
	if (STORAGE_BYTE_ORDER != MACHINE_BYTE_ORDER) {
	  retval = fread ( &ttemp, sizeof (tri_coordinate_type), 1, from ) ;
	  swap_four ( &ttemp.x, &tptr->x ) ;
	  swap_four ( &ttemp.y, &tptr->y ) ;
	  swap_four ( &ttemp.z, &tptr->z ) ;
	} else {
	  retval = fread ( &ttmp, sizeof (float), 1, from );
	  ttemp.x = IEEE_VAX_S(&ttmp) ;
	  retval = fread ( &ttmp, sizeof (float), 1, from );
	  ttemp.y = IEEE_VAX_S(&ttmp) ;
	  retval = fread ( &ttmp, sizeof (float), 1, from );
	  ttemp.z = IEEE_VAX_S(&ttmp) ;
	  /*printf("%10.5f %10.5f %10.5f",ttemp.x,ttemp.y,ttemp.z);*/
	  *tptr = ttemp;
	}
	/*printf("\n");*/
	tptr++ ;
      }
    }
    break ;
  case VpfDoubleTriCoordinate:
    {
      double_tri_coordinate_type dttemp ,
                                 *dtptr = (double_tri_coordinate_type *) to ;
      for ( i=0; i < count; i++ ) {
        retval = fread ( &dttemp,sizeof (double_tri_coordinate_type), 1, from);
	if (STORAGE_BYTE_ORDER != MACHINE_BYTE_ORDER) {
	   swap_eight ( &dttemp.x, &dtptr->x ) ;
	   swap_eight ( &dttemp.y, &dtptr->y ) ;
	   swap_eight ( &dttemp.z, &dtptr->z ) ;
	} else {
	   dtptr->x = dttemp.x;
	   dtptr->y = dttemp.y;
	   dtptr->z = dttemp.z;
	}
	dtptr++ ;
      }
    }  
    break ;
  case VpfNull:
    /* Do Nothing */
    break ;
  default:
    /* This will never happen as any unknown datatypes will mean the table*/
    /* was rejected before getting this far  */
    /*printf("%s VpfRead: error on data type < %s >",C_ERROR, type ) ;*/
    break ;
  }   /* end of switch */

  return retval ;       /* whatever fread returns */

}



/*----------------------------------------------------------------------*/
/* long INT indx_pos							*/
/*......................................................................*/
/*									*/
/* This function returns the position of a specified row from the table */
/* index								*/
/*......................................................................*/
/*    row_number <input> == (long int) row number in the table.		*/
/*    table      <input> == (vpf_table_type) VPF table structure.	*/
/*    return    <output> == (long int) position of the table row 	*/
/*                          or zero on error.				*/
/*----------------------------------------------------------------------*/
long int index_pos( long int row_number,
		    vpf_table_type table )
{
   long int   recsize;
   unsigned long int pos;

   STORAGE_BYTE_ORDER = table.byte_order;

   if (row_number < 1) row_number = 1;
   if (row_number > table.nrows) row_number = table.nrows;

   switch (table.xstorage) {
      case COMPUTE:
	 pos = table.ddlen + ((row_number-1) * table.reclen);
	 break;
      case DISK:
	 recsize = sizeof(index_cell);
	 fseek( table.xfp, (long int)(row_number*recsize), SEEK_SET );
	 if ( ! Read_Vpf_Int(&pos,table.xfp,1) ) {
	   /* Never using DISK storage */
	   /*printf ("%s index_length: error reading index.",C_ERROR) ;*/
	   pos = NULL ;
	 }
	 break;
      case RAM:
	 pos = table.index[row_number-1].pos;
	 break;
      default:
	 if ( table.mode == Write && table.nrows != row_number ) {
	   /* Just an error check, should never get here in writing */
	   /* Never get here anyway. Always reading from RAM */
	   /*printf("%s index_length: error trying to access row %d",C_ERROR,*/
	   /*        row_number ) ;*/
	   pos = NULL;
	 }
	 break;
   }
   return pos;
}



/*----------------------------------------------------------------------*/
/* id_triplet_type read_key						*/
/*......................................................................*/
/*									*/
/* This function reads an id triplet key from a VPF table.	       	*/
/* The table must be open for read.					*/
/*......................................................................*/
/*    table    <input>  == (vpf_table_type) VPF table.			*/
/*    read_key <output> == (id_triplet_type) id triplet key.		*/
/*----------------------------------------------------------------------*/
id_triplet_type read_key( vpf_table_type table )
{
   id_triplet_type key;
   unsigned char ucval;
   unsigned short int uival;

   STORAGE_BYTE_ORDER = table.byte_order;

   key.id = 0L;
   key.tile = 0L;
   key.exid = 0L;

   /* just doing this to be consistent */
   Read_Vpf_Char (&(key.type),table.fp,1);

   switch (TYPE0(key.type)) {
      case 0:
	 break;
      case 1:

	 Read_Vpf_Char (&ucval, table.fp, 1 ) ;
	 key.id = (long int)ucval;
	 break;
      case 2:

	 Read_Vpf_Short (&uival, table.fp, 1 ) ;
	 key.id = (long int)uival;
	 break;
      case 3:

	 Read_Vpf_Int (&(key.id), table.fp, 1 ) ;
	 break;
   }
   switch (TYPE1(key.type)) {
   case 0:
     break;
   case 1:
     Read_Vpf_Char (&ucval, table.fp, 1 ) ;
     key.tile = (long int)ucval;
     break;
   case 2:
     Read_Vpf_Short (&uival, table.fp, 1 ) ;
     key.tile = (long int)uival;
     break;
   case 3:
     Read_Vpf_Int (&(key.tile), table.fp, 1 ) ;
     break;
   }

   switch (TYPE2(key.type)) {
   case 0:
     break;
   case 1:
     Read_Vpf_Char (&ucval, table.fp, 1 ) ;
     key.exid = (long int)ucval;
     break;
   case 2:
     Read_Vpf_Short (&uival, table.fp, 1 ) ;
     key.exid = (long int)uival;
     break;
   case 3:
     Read_Vpf_Int (&(key.exid), table.fp, 1 ) ;
     break;
   }

   return key;
 }




/*----------------------------------------------------------------------*/
/* row_type read_next_row						*/
/*......................................................................*/
/*									*/
/* This function reads the next row of the table.		       	*/
/*......................................................................*/
/* table      <input> == (vpf_table_type) vpf table structure.		*/
/* return    <output> == (row_type) the next row in the table.		*/
/*----------------------------------------------------------------------*/
row_type read_next_row( vpf_table_type table )
{
   register long int i,j;
   long int      status;
   char     *tptr;
   long int size,count,siz,context;
   row_type row;
   id_triplet_type * keys;
   coordinate_type dummycoord;

   if (feof(table.fp)) {
      return NULL;
   }

   STORAGE_BYTE_ORDER = table.byte_order;

   /*row = (row_type)vpfmalloc((table.nfields+1) * sizeof(column_type));*/
   row = (row_type)vpfmalloc((table.nfields) * sizeof(column_type));

   for (i=0;i<table.nfields;i++) row[i].ptr = NULL;

   for (i=0;i<table.nfields;i++) {
      if (table.header[i].count < 0) {

	 Read_Vpf_Int (&count,table.fp,1) ;

      } else {
	 count = table.header[i].count;
      }
      row[i].count = count;

      status = 0;
      switch (table.header[i].type) {
	 case 'T':
/*	    if (count == 1) {
	       row[i].ptr = (char *)vpfmalloc(sizeof(char));
	       Read_Vpf_Char(row[i].ptr, table.fp, 1) ;
	    } else { */
	       size = count*sizeof(char);
	       row[i].ptr = (char *)vpfmalloc(size+2);
	       tptr = (char *)vpfmalloc(size+2);
	       Read_Vpf_Char(tptr,table.fp,count) ;
	       tptr[count] = '\0';
	       strcpy(row[i].ptr,tptr);
	       free(tptr);
/*	    }*/
	    break;
	 case 'I':
	    siz =count*sizeof(long int);
	    row[i].ptr = (long int *)vpfmalloc(siz);
	    Read_Vpf_Int (row[i].ptr, table.fp, count ) ;
	    break;
	 case 'S':
	    row[i].ptr = (short int *)vpfmalloc(count*sizeof(short int));
	    Read_Vpf_Short (row[i].ptr, table.fp, count ) ;
	    break;
	 case 'F':
	    row[i].ptr = (float *)vpfmalloc(count*sizeof(float));
	    Read_Vpf_Float (row[i].ptr, table.fp, count ) ;
	    break;
	 case 'R':
	    row[i].ptr = (double *)vpfmalloc(count*sizeof(double));
	    Read_Vpf_Double (row[i].ptr, table.fp, count ) ;
	    break;
	 case 'D':
	    row[i].ptr = (date_type *)vpfmalloc(count*sizeof(date_type));
	    Read_Vpf_Date (row[i].ptr, table.fp, count ) ;
	    break;
	 case 'C':
	    /* Coordinate strings may be quite large.          */
	    /* Allow for null coordinate string pointer if     */
	    /* not enough memory that can be handled one       */
	    /* coordinate at a time in higher level functions. */
	    row[i].ptr = (coordinate_type *)malloc(count*
			 sizeof(coordinate_type));
	    if (row[i].ptr)
	       Read_Vpf_Coordinate(row[i].ptr,table.fp,count);
	    else
	       for (j=0;j<count;j++)
		  Read_Vpf_Coordinate(&dummycoord,table.fp,1);
	    break;
	 case 'Z':
	    row[i].ptr = (tri_coordinate_type *)vpfmalloc(count*
			 sizeof(tri_coordinate_type));
	    Read_Vpf_CoordinateZ(row[i].ptr,table.fp,count);
	    break;
	 case 'B':
	    row[i].ptr = (double_coordinate_type *)vpfmalloc(count*
			 sizeof(double_coordinate_type));
	    Read_Vpf_DoubleCoordinate(row[i].ptr,table.fp,count);
	    break;
	 case 'Y':
	    row[i].ptr = (double_tri_coordinate_type *)vpfmalloc(count*
			 sizeof(double_tri_coordinate_type));
	    Read_Vpf_DoubleCoordinateZ(row[i].ptr,table.fp,count);
	    break;
	 case 'K':   /* ID Triplet */
	    row[i].ptr = (id_triplet_type *)vpfmalloc(count*
			 sizeof(id_triplet_type));
	    keys = (id_triplet_type *)vpfmalloc(count*
		   sizeof(id_triplet_type));
	    for (j=0;j<count;j++) {
	       keys[j] = read_key(table);
	    }
	    memcpy(row[i].ptr,keys,count*sizeof(id_triplet_type));
	    free(keys);
	    break;
	 case 'X':
	    row[i].ptr = NULL;
	    break;
	  default:
	    lsl_putmsg(&DCW2I__DATATYPE,&table.header[i].type);
	    status = 1;
	    break ;
	  }   /* end of switch */
      if (status == 1) {
	 free_row ( row, table ) ;
	 return (row_type) NULL;
      }
   }
   return row;
}




/*----------------------------------------------------------------------*/
/* void free_row							*/
/*......................................................................*/
/*									*/
/* This function frees the memory that was dynamically allocated for	*/
/* the specified row.							*/
/*......................................................................*/
/*    row   <input> == (row_type) row to be freed.			*/
/*    table <input> == (vpf_table_type) vpf table structure.		*/
/*----------------------------------------------------------------------*/
void free_row( row_type row,
	       vpf_table_type table)
{
   register long int i;

   if (!row) return;
   if (table.nfields>0) {
     for (i=0;i<table.nfields;i++)
       if (row[i].ptr) free(row[i].ptr);
   }
   free(row);
}




/*----------------------------------------------------------------------*/
/* void free_table							*/
/*......................................................................*/
/*									*/
/* This function frees the memory that was dynamically allocated for	*/
/* a table.								*/
/*......................................................................*/
/*    table <input> == (vpf_table_type *) vpf table structure.		*/
/*----------------------------------------------------------------------*/
void free_table(vpf_table_type *table)
{
   register long int i;

   if (!table->row) return;
   if (table->nrows>0) {
     for (i=0;i<table->nrows;i++) free_row(table->row[i],*table);
   }
   free(table->row);

   if (table->nfields>0) {
     for (i = 0; i < table->nfields; i++) {
       free(table->header[i].name);
       /* free up null text string */
       if ( table->header[i].type == 'T')
	 free(table->header[i].nullval.Char);
       /* free up index file string */
       if (table->header[i].tdx!=(char *)NULL)
	 free ( table->header[i].tdx ) ;
       /* free up narrative table string */
       if (table->header[i].narrative!=(char *)NULL) {
	 free ( table->header[i].narrative ) ;
       }
     }
   }
   free(table->header);
   free(table->path);
   fclose(table->fp);
   table->nfields = 0;
   table->status = CLOSED;
   table->fp = NULL;
   table->success = FAIL;
   /*printf("Freed table....\n");*/
 }
