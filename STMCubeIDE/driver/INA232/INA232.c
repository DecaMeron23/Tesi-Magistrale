/**
 * @file    INA232.c
 * @author  Matteo Verzeroli - matteo.verzeroli@unibg.it
 * @version V1.0
 * @date    18 September 2025
 * @brief   Implementation of the INA232 power monitor driver
 * @details Edit this file at your own risk
 * @copyright Matteo Verzeroli
 **/
#include "INA232.h"
#include <stdint.h>
#include <stdio.h>


extern I2C_HandleTypeDef hi2c_ina232;

static bool INA232_Send_CMD(INA232_HandleTypeDef* hdev, uint8_t cmd, uint16_t regValue)
{
	bool result = true;

	uint8_t buf[3];
	buf[0] = cmd;
	buf[1] = (regValue >> 8);
	buf[2] = (regValue & 0xFF);

	result &= HAL_I2C_Master_Transmit(&hi2c_ina232, hdev->address, buf, 3, HAL_MAX_DELAY) == HAL_OK;

	return result;
}


static bool INA232_Read_Data(INA232_HandleTypeDef* hdev, uint8_t cmd, uint16_t* reg_value)
{
	bool result = true;
	uint8_t buf[2];

	buf[0] = cmd;

	result &= HAL_I2C_Master_Transmit(&hi2c_ina232, hdev->address, buf, 1, HAL_MAX_DELAY) == HAL_OK;

	if(!result)
	{
		return false;
	}

	result &= HAL_I2C_Master_Receive(&hi2c_ina232, hdev->address, buf, 2, HAL_MAX_DELAY) == HAL_OK;

	if(!result)
	{
		return false;
	}

	uint8_t temp = buf[0];
	buf[0] = buf[1];
	buf[1] = temp;

	memcpy(reg_value, buf, 2);

	return result;
}


bool INA232_Check_Manufacture_Id(INA232_HandleTypeDef* hdev, bool* check_result)
{
	bool result = true;
	uint16_t buf;

	result &= INA232_Read_Data(hdev, INA232_CMD_MANUF_ID, &buf);

	if(!result)
	{
		return false;
	}

	*check_result = buf == 0x5449;

	return result;
}

bool INA232_Init(INA232_HandleTypeDef* hdev, INA232_Reset_Mode rst, INA232_ADC_Range adcRange, INA232_Avg adcAvg, INA232_ConvTime vbusConvTime, INA232_ConvTime shuntConvTime, INA232_Mode opMode)
{
	bool result = true;
	uint16_t buf;

	buf = ((rst & 0x01) << 15) | (0x10 << 13) | ((adcRange & 0x01) << 12) | ((adcAvg & 0x07) << 9) | ((vbusConvTime & 0x07) << 6) | ((shuntConvTime & 0x07) << 3) | (opMode & 0x07);

	result &= INA232_Send_CMD(hdev, INA232_CMD_CONFIG, buf);

	if(!result)
	{
		return false;
	}

	hdev->shunt_voltage_lsb = (adcRange == INA232_ADC_RANGE_20_48MV) ? 625e-9f : 2.5e-6f;

	return result;
}


bool INA232_Reset(INA232_HandleTypeDef* hdev)
{
	bool result = true;

	result &= INA232_Init(hdev, INA232_RESET_ON, 0, 0, 0, 0, 0);

	return result;
}

static bool INA232_Read_Shunt_Voltage(INA232_HandleTypeDef* hdev, float* shunt_voltage)
{
	bool result = true;
	uint16_t buf;

	result &= INA232_Read_Data(hdev, INA232_CMD_SHUNT_V, &buf);

	if(!result)
	{
		return false;
	}

	*shunt_voltage = (int16_t)buf * hdev->shunt_voltage_lsb;

	return result;
}

static bool INA232_Read_Bus_Voltage(INA232_HandleTypeDef* hdev, float* bus_voltage)
{
	bool result = true;
	uint16_t buf;

	result &= INA232_Read_Data(hdev, INA232_CMD_BUS_V, &buf);

	if(!result)
	{
		return false;
	}

	*bus_voltage = buf * 1.6e-3;

	return result;
}

bool INA232_Get_Current_And_Voltage(INA232_HandleTypeDef* hdev, INA232_Output_data* output_data)
{
	bool result = true;
	float buf[2];

	result &= INA232_Read_Shunt_Voltage(hdev, buf);
	result &= INA232_Read_Bus_Voltage(hdev, buf + 1);

	output_data->new_data = false;

	if(!result)
	{
		return false;
	}

	output_data->read_shunt_current = buf[0] / hdev->shunt_value;
	output_data->read_bus_voltage = buf[1];
	output_data->new_data = true;

	return result;
}
