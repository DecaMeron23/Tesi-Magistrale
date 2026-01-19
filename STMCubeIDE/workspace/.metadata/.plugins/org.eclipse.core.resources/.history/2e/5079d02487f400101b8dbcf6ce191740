/*
 * MX25L4.c
 *
 *  Created on: 14 Jan 2026
 *      Author: micro
 */

#include "MX25L4x.h"

extern SPI_HandleTypeDef hspi1; // Assicurati che il nome corrisponda a CubeMX

static void CS_Select(void) {
    HAL_GPIO_WritePin(CS_FLASH_GPIO_Port, CS_FLASH_Pin, GPIO_PIN_RESET);
}

static void CS_Unselect(void) {
    HAL_GPIO_WritePin(CS_FLASH_GPIO_Port, CS_FLASH_Pin, GPIO_PIN_SET);
}

// 1. Lettura ID: Il primo test da fare sempre
uint32_t MX25L4_ReadID(void) {
    uint8_t cmd = CMD_RDID;
    uint8_t id[3];
    CS_Select();
    HAL_SPI_Transmit(&hspi1, &cmd, 1, 100);
    HAL_SPI_Receive(&hspi1, id, 3, 100);
    CS_Unselect();
    return (id[0] << 16) | (id[1] << 8) | id[2]; // Deve restituire 0xC22013 per MX25L4006E
}

// 2. Controllo Busy (WIP)
void Flash_WaitBusy(void) {
    uint8_t status;
    uint8_t cmd = CMD_RDSR;
    do {
        CS_Select();
        HAL_SPI_Transmit(&hspi1, &cmd, 1, 100);
        HAL_SPI_Receive(&hspi1, &status, 1, 100);
        CS_Unselect();
    } while (status & 0x01);
}

// 3. Scrittura sicura (Gestisce il limite di 256 byte della pagina)
void MX25L4_WriteData(uint32_t addr, uint8_t* data, uint16_t size) {
    uint16_t sent = 0;
    while (sent < size) {
        // Calcola quanti byte rimangono alla fine della pagina corrente
        uint32_t page_offset = addr % EXT_FLASH_PAGE_SIZE;
        uint16_t can_write = EXT_FLASH_PAGE_SIZE - page_offset;
        uint16_t to_write = (size - sent < can_write) ? (size - sent) : can_write;

        // Esegui Page Program
        uint8_t cmd[4] = {CMD_WREN};
        CS_Select();
        HAL_SPI_Transmit(&hspi1, cmd, 1, 10); // Write Enable
        CS_Unselect();

        cmd[0] = CMD_PAGE_PROG;
        cmd[1] = (addr >> 16) & 0xFF;
        cmd[2] = (addr >> 8) & 0xFF;
        cmd[3] = addr & 0xFF;

        CS_Select();
        HAL_SPI_Transmit(&hspi1, cmd, 4, 100);
        HAL_SPI_Transmit(&hspi1, &data[sent], to_write, 500);
        CS_Unselect();

        Flash_WaitBusy();

        sent += to_write;
        addr += to_write;
    }
}

// 4. Lettura dati (Non ha limiti di pagina)
void MX25L4_ReadData(uint32_t addr, uint8_t* buffer, uint16_t size) {
    uint8_t cmd[4] = {CMD_READ, (addr >> 16) & 0xFF, (addr >> 8) & 0xFF, addr & 0xFF};
    CS_Select();
    HAL_SPI_Transmit(&hspi1, cmd, 4, 100);
    HAL_SPI_Receive(&hspi1, buffer, size, 1000);
    CS_Unselect();
}


void MX25L4_EraseSector(uint32_t addr) {
    uint8_t cmd[4];

    // 1. Write Enable: necessario prima di ogni operazione di cancellazione
    uint8_t wren = CMD_WREN;
    CS_Select();
    HAL_SPI_Transmit(&hspi1, &wren, 1, 10);
    CS_Unselect();

    // 2. Sector Erase (4KB)
    cmd[0] = CMD_SECTOR_ERASE; // 0x20
    cmd[1] = (addr >> 16) & 0xFF;
    cmd[2] = (addr >> 8) & 0xFF;
    cmd[3] = addr & 0xFF;

    CS_Select();
    HAL_SPI_Transmit(&hspi1, cmd, 4, 100);
    CS_Unselect();

    // 3. Attesa completamento
    Flash_WaitBusy();
}
