/*
 * main.c
 *
 *  Created on: May 29, 2018
 *      Author: max
 */

//#include <altera_generic_quad_spi_controller2.h>
#include <io.h>
#include <string.h>
#include <system.h>
#include <linker.h>

#include "mb.h"
#include "gfx.h"
#include "sign.h"

void platformSetup(void);
void platformCmd(void);

void sftest(void)
{
	alt_u32 volatile *rpc = (alt_u32*)DPRAM_BASE;
	// read
	memset(rpc, 0, 32);
	rpc[1] = 0;
	rpc[2] = 16;
	rpc[0] = MB_DEV_SF | 0x05;
	platformCmd();

	// read
	memset(rpc, 0, 32);
	rpc[1] = 64*1024;
	rpc[2] = 16;
	rpc[0] = MB_DEV_SF | 0x05;
	platformCmd();

	// erase first 64K
	rpc[1] = 2;
	rpc[2] = 0;
	rpc[0] = MB_DEV_SF | 0x03;
	platformCmd();

	// erase second 64K
	rpc[1] = 2;
	rpc[2] = 64*1024;
	rpc[0] = MB_DEV_SF | 0x03;
	platformCmd();
return;
	// program
	rpc[1] = 0;
	rpc[2] = 16;
	strcpy(&rpc[3], "01234567890abcdef");
	rpc[0] = MB_DEV_SF | 0x04;
	platformCmd();

	// program
	rpc[1] = 64*1024;
	rpc[2] = 16;
	strcpy(&rpc[3], "fedcba9876543210");
	rpc[0] = MB_DEV_SF | 0x04;
	platformCmd();

	// read
	memset(rpc, 0, 32);
	rpc[1] = 0;
	rpc[2] = 32;
	rpc[0] = MB_DEV_SF | 0x05;
	platformCmd();

	// read
	memset(rpc, 0, 32);
	rpc[1] = 64*1024;
	rpc[2] = 32;
	rpc[0] = MB_DEV_SF | 0x05;
	platformCmd();

}

/**
 *
 */
int main()
{
	int ret;
//sftest();
	// logo iniziale
	gfxInit(0);

	// calcola la firma
	ret = sign();

	// cancella il codice eseguito fin qui
	memset((void*)BOOT_REGION_BASE, 0, BOOT_REGION_SPAN);

	// TODO abilitazione bridge jtag

	// verifica la validità della firma
/*	if(ret){
		while(1);
	}
*/

	platformSetup();
	while (1) {
		platformCmd();
	};

	return 0;
}