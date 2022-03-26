/* com package for SENDXYZ program */

#include <iodef.h>
#include <string.h>

#include "com.h"

unsigned long sys$assign();
void sys$dassgn();
unsigned long sys$qiow();

static unsigned int SI_CHAN=0;

int com_install(char *device)
{
  unsigned long desc[2];
  unsigned long ok;
  if (SI_CHAN!=0) return 0;	/* already assigned */
  desc[0] = strlen(device);
  desc[1] = device;
  ok = sys$assign(desc,&SI_CHAN,0,0,0);
  if (ok&1) return 0;
  return ok;
}

void com_deinstall()
{
  sys$dassgn(SI_CHAN);
  SI_CHAN = 0;
}

void com_tx(char c)
{
  com_txs(&c,1);
}

void com_txs(char *buf, int len)
{
  unsigned long ok;
  unsigned short int iosb[4];
  ok = sys$qiow(0,SI_CHAN,IO$_WRITEVBLK|IO$M_NOFORMAT,iosb,0,0,
		buf,len,0,0,0,0);
}

unsigned char com_rx()
{
  unsigned long ok;
  unsigned short int iosb[4];
  unsigned long termsk[2]={0,0};
  unsigned char c=0;
  ok = sys$qiow(0,SI_CHAN,IO$_TTYREADALL|IO$M_NOECHO|IO$M_TIMED,iosb,0,0,
		&c,1,2,termsk,0,0);
  if (iosb[0]!=1) printf("SI IO error %d\n",iosb[0]);
  return c;
}

void com_flush_rx()
{
  unsigned long ok;
  unsigned short int iosb[4];
  unsigned long termsk[2]={0,0};
  unsigned char c;
  ok = sys$qiow(0,SI_CHAN,
		IO$_TTYREADALL|IO$M_NOECHO|IO$M_PURGE|IO$M_TIMED,iosb,0,0,
		&c,1,0,termsk,0,0);
}
