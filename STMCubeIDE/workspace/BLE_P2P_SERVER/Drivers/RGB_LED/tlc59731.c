/*
 * tlc59731.c
 *
 *  Created on: 10 gen 2026
 *      Author: emilio
 */

#include "tlc59731.h"

#define TLC59731_MSB_MASK 0x000080
#define TLC59731_WRITE_COMMAND 0x0000003A
#define TLC59731_T_CYCLE 25u
#define TLC59731_PULSE_CYCLE 5u

void writeByte(uint8_t byte);
void writeBit_0();
void writeBit_1();
void pulsePin();
void delayMicro(uint32_t delay);
void startTimer();
void stopTimer();
void writeEOS();
void writeCommand();
void writeGSLAT();

uint8_t writeData(uint8_t *RGB);

enum RGB_LED_STATE
{
	RGB_LED_STATE_ON, RGB_LED_STATE_OFF
};

enum RGB_LED_COLOUR
{
	RGB_LED_RED, RGB_LED_GREEN, RGB_LED_BLUE, RGB_LED_NUM_COLOUR,
};

struct RGB_LED_TypeDef
{
	GPIO_TypeDef *pwm_port;
	uint16_t pwm_pin;
	GPIO_TypeDef *select_port;
	uint16_t select_pin;
	TIM_HandleTypeDef *tim;
	uint8_t RGB_value[RGB_LED_NUM_COLOUR];
	enum RGB_LED_STATE state;
};

struct RGB_LED_TypeDef led;

uint8_t TLC59731_Init(GPIO_TypeDef *led_pwm_port, uint16_t led_pwm_pin, GPIO_TypeDef *led_select_port,
		uint16_t led_select_pin, TIM_HandleTypeDef *tim)
{
	led.pwm_port = led_pwm_port;
	led.pwm_pin = led_pwm_pin;
	led.select_port = led_select_port;
	led.select_pin = led_select_pin;
	led.tim = tim;
	led.state = RGB_LED_STATE_OFF;
	TLC59731_SetRGB(0x00, 0x00, 0x00);
	TLC59731_Off();
	return 0;
}

uint8_t TLC59731_SendRGB(uint8_t red, uint8_t green, uint8_t blue)
{
	TLC59731_SetRGB(red, green, blue);
	TLC59731_On();
	return 0;
}

uint8_t TLC59731_SetRGB(uint8_t red, uint8_t green, uint8_t blue)
{
	led.RGB_value[RGB_LED_RED] = red;
	led.RGB_value[RGB_LED_GREEN] = green;
	led.RGB_value[RGB_LED_BLUE] = blue;
	return 0;
}

uint8_t TLC59731_On()
{
	led.state = RGB_LED_STATE_ON;
	return writeData(led.RGB_value);
}

uint8_t TLC59731_Off()
{
	uint8_t rgb[] =
	{ 0x00, 0x00, 0x00 };
	led.state = RGB_LED_STATE_OFF;
	return writeData(rgb);
}

uint8_t TLC59731_Toggle()
{
	if (led.state == RGB_LED_STATE_ON)
	{
		TLC59731_Off();
	}
	else
	{
		TLC59731_On();
	}
	return 0;
}

/**
 * RGB array lungo RGB_LED_NUM_COLOR
 */
uint8_t writeData(uint8_t *RGB)
{
	HAL_GPIO_WritePin(led.select_port, led.select_pin, GPIO_PIN_SET);

	startTimer();

	writeCommand();

	// Scrittura dei colori
	for (uint8_t i = 0; i < RGB_LED_NUM_COLOUR; i++)
	{
		writeByte(RGB[i]);
	}

//	writeEOS();
//	writeGSLAT();

	stopTimer();

	HAL_GPIO_WritePin(led.select_port, led.select_pin, GPIO_PIN_RESET);

	return 0;
}

/**
 * Il primo bite scritto deve essere il MSB
 */
void writeByte(uint8_t byte)
{
	uint8_t data = byte;
	for (uint8_t i = 0; i < 8; i++)
	{
		uint8_t val = data & TLC59731_MSB_MASK;
		if (val == 0)
		{
			writeBit_0();
		}
		else
		{
			writeBit_1();
		}
		data = data << 1;
	}
}

void writeCommand()
{
	writeByte(TLC59731_WRITE_COMMAND);
}

void writeGSLAT()
{
	pulsePin();
	delayMicro(TLC59731_T_CYCLE * 10);
	pulsePin();
}

void writeEOS()
{
	pulsePin();
	delayMicro(TLC59731_T_CYCLE * 4);
	pulsePin();
}

void writeBit_0()
{
	pulsePin();
	delayMicro(TLC59731_T_CYCLE);
}
void writeBit_1()
{
	pulsePin();
	delayMicro(TLC59731_T_CYCLE / 2);
	pulsePin();
	delayMicro(TLC59731_T_CYCLE / 2);
}

void pulsePin()
{
	HAL_GPIO_WritePin(led.pwm_port, led.pwm_pin, GPIO_PIN_SET);
	delayMicro(TLC59731_PULSE_CYCLE);
	HAL_GPIO_WritePin(led.pwm_port, led.pwm_pin, GPIO_PIN_RESET);
}

void startTimer()
{

	HAL_TIM_Base_Start(led.tim);
}

void stopTimer()
{
	HAL_TIM_Base_Stop(led.tim);
}



/**
 * Ipotesi Il timer va a 32MHz
 */
void delayMicro(uint32_t delay)
{
	delay *= 32;
	uint16_t start = __HAL_TIM_GET_COUNTER(led.tim);
	while (__HAL_TIM_GET_COUNTER(led.tim) - start < delay)
	{
	}
}
