/* header file for com package for SENDXYZ program */

int com_install(char *device);
void com_deinstall();
void com_tx(char c);
void com_txs(char *buf, int len);
unsigned char com_rx();
void com_flush_rx();
