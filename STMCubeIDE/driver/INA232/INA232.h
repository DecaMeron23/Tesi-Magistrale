/**
 * @file    INA232.h
 * @author  Matteo Verzeroli - matteo.verzeroli@unibg.it
 * @version V1.0
 * @date    18 September 2025
 * @brief   Header file of the INA232 power monitor driver
 * @details Edit this file at your own risk
 * @copyright Matteo Verzeroli
 **/

#ifndef APP_INA232_INA232_H_
#define APP_INA232_INA232_H_


#include "main.h"
#include "stdbool.h"

/**
 * Handle of the I2C interface
 *  */
#define hi2c_ina232 hi2c1

/**
 * INA232 register addresses
 */
#define INA232_CMD_CONFIG       0x00  /**< Configuration register */
#define INA232_CMD_SHUNT_V      0x01  /**< Shunt voltage register */
#define INA232_CMD_BUS_V        0x02  /**< Bus voltage register */
#define INA232_CMD_POWER        0x03  /**< Power register */
#define INA232_CMD_CURRENT      0x04  /**< Current register */
#define INA232_CMD_CALIBRATION  0x05  /**< Calibration register */
#define INA232_CMD_MASK_ENABLE  0x06  /**< Mask/Enable register */
#define INA232_CMD_ALERT_LIMIT  0x07  /**< Alert limit register */
#define INA232_CMD_MANUF_ID     0x3E  /**< Manufacturer ID register */

/**
 * Reset mode
 */
typedef enum{
	INA232_RESET_OFF,
	INA232_RESET_ON,
} INA232_Reset_Mode;

/**
 * ADC range
 */
typedef enum{
	INA232_ADC_RANGE_81_92MV = 0x00, /**< +-81.92 mV shunt full scale input across IN+ and IN- */
	INA232_ADC_RANGE_20_48MV = 0x01  /**< +-20.48 mV shunt full scale input across IN+ and IN- */
} INA232_ADC_Range;

/**
 * Averaging options for ADC measurements
 */
typedef enum {
    INA232_AVG_1   = 0b000, /**< Average 1 sample */
    INA232_AVG_4   = 0b001, /**< Average 4 samples */
    INA232_AVG_16  = 0b010, /**< Average 16 samples */
    INA232_AVG_64  = 0b011, /**< Average 64 samples */
    INA232_AVG_128 = 0b100, /**< Average 128 samples */
    INA232_AVG_256 = 0b101, /**< Average 256 samples */
    INA232_AVG_512 = 0b110, /**< Average 512 samples */
    INA232_AVG_1024= 0b111, /**< Average 1024 samples */
} INA232_Avg;

/**
 * Conversion time options
 */
typedef enum {
    INA232_140US   = 0b000,  /**< 140 µs conversion time */
    INA232_204US   = 0b001,  /**< 204 µs conversion time */
    INA232_332US   = 0b010,  /**< 332 µs conversion time */
    INA232_588US   = 0b011,  /**< 588 µs conversion time */
    INA232_1100US  = 0b100,  /**< 1.1 ms conversion time */
    INA232_2116US  = 0b101,  /**< 2.1 ms conversion time */
    INA232_4156US  = 0b110,  /**< 4.1 ms conversion time */
    INA232_8244US  = 0b111,  /**< 8.2 ms conversion time */
} INA232_ConvTime;

/**
 * Operating modes of the device
 */
typedef enum {
    INA232_MODE_SHUTDOWN        = 0b000, /**< Power-down mode */
    INA232_MODE_TRIG_SHUNT      = 0b001, /**< Triggered shunt voltage only */
    INA232_MODE_TRIG_BUS        = 0b010, /**< Triggered bus voltage only */
    INA232_MODE_TRIG_SHUNT_BUS  = 0b011, /**< Triggered shunt + bus voltage */
    INA232_MODE_CONT_SHUNT      = 0b101, /**< Continuous shunt voltage */
    INA232_MODE_CONT_BUS        = 0b110, /**< Continuous bus voltage */
    INA232_MODE_CONT_SHUNT_BUS  = 0b111, /**< Continuous shunt + bus voltage */
} INA232_Mode;

/**
 * Driver context structure.
 */
typedef struct {
	uint16_t address;        	/**< I2C address of the device */
	float shunt_value; 			/**< Shunt resistor value in Ohm */
	float shunt_voltage_lsb;    /**< Current resolution for the shunt voltage */
} INA232_HandleTypeDef;

/**
 * INA232 output data struct
 */
typedef struct{
	float read_shunt_current; 	/**< Voltage drop over the shunt resistor */
	float read_bus_voltage;		/**< Voltage on VIN- pin */
	bool new_data;
}INA232_Output_data;

/**
 * Check the manufacturer ID of the INA232.
 * @param hdev Pointer to device handle
 * @param check_result True if manufacturer ID matches 0x5449
 * @return true if operation succeeded
 */

bool INA232_Check_Manufacture_Id(INA232_HandleTypeDef* hdev, bool* check_result);

/**
 * Initialize INA232 with configuration parameters.
 * @param hdev Pointer to device handle
 * @param rst Reset bit (0 or 1)
 * @param adcRange ADC range selection
 * @param adcAvg ADC averaging setting
 * @param vbusConvTime Bus voltage conversion time
 * @param shuntConvTime Shunt voltage conversion time
 * @param opMode Operating mode
 * @return true if operation succeeded
 */
bool INA232_Init(INA232_HandleTypeDef* hdev,
				 INA232_Reset_Mode rst,
                 INA232_ADC_Range adcRange,
                 INA232_Avg adcAvg,
                 INA232_ConvTime vbusConvTime,
                 INA232_ConvTime shuntConvTime,
                 INA232_Mode opMode);

/**
 * Reset the INA232 device.
 * @param hdev Pointer to device handle
 * @return true if operation succeeded
 */
bool INA232_Reset(INA232_HandleTypeDef* hdev);

/**
 * Get both current consumption and bus voltage at VIN- pin.
 * @param hdev Pointer to device handle
 * @param output_data output data read by the sensor
 * @return true if operation succeeded
 */
bool INA232_Get_Current_And_Voltage(INA232_HandleTypeDef* hdev, INA232_Output_data* output_data);

#endif /* APP_INA232_INA232_H_ */
