/*
 * MX25L4x.h
 *
 *  Created on: 14 Jan 2026
 *      Author: micro
 */

#ifndef SRC_FLASH_DRIVER_MX25L4X_H_
#define SRC_FLASH_DRIVER_MX25L4X_H_

#include "main.h"

// Parametri Flash MX25L4006E
#define FLASH_SECTOR_SIZE      4096    // 4 KB
#define FLASH_BLOCK_SIZE       65536   // 64 KB
#define EXT_FLASH_PAGE_SIZE    256     // 256 Byte
#define FLASH_TOTAL_SIZE       524288  // 512 KB (4 Megabit)

// Comandi (Dal Datasheet Macronix)
#define CMD_WREN           0x06    // Write Enable
#define CMD_WRDI           0x04    // Write Disable
#define CMD_RDSR           0x05    // Read Status Register
#define CMD_READ           0x03    // Read Data Bytes
#define CMD_PAGE_PROG      0x02    // Page Program
#define CMD_SECTOR_ERASE   0x20    // Sector Erase (4KB)
#define CMD_BLOCK_ERASE    0xD8    // Block Erase (64KB)
#define CMD_CHIP_ERASE     0x60    // Chip Erase (oppure 0xC7)
#define CMD_RDID           0x9F    // Read Identification

// Prototipi
uint32_t MX25L4_ReadID(void);
void     Flash_WaitBusy(void); // Utile esporla se vuoi controllare lo stato esternamente

// Funzioni di Erase
void     MX25L4_EraseSector(uint32_t addr);
void     MX25L4_EraseBlock(uint32_t addr);
void     MX25L4_EraseChip(void);

// Funzioni di I/O
void     MX25L4_WriteData(uint32_t addr, uint8_t* data, uint16_t size);
void     MX25L4_ReadData(uint32_t addr, uint8_t* buffer, uint16_t size);

#endif /* SRC_FLASH_DRIVER_MX25L4X_H_ */
