#include "pwmsignal.h"

uint32_t FREQ_CLK;
uint32_t PRE_SCALER;

void initialisePWMSignal(const uint32_t freq_clk, const uint32_t pre_scaler)
{
	FREQ_CLK = freq_clk;
	PRE_SCALER = pre_scaler;
}

void computeFrequency(PWMSignal *s, TIM_HandleTypeDef *htim ,int channel , uint8_t is_rising)
{
	uint32_t current = HAL_TIM_ReadCapturedValue(htim, channel);

	if (is_rising)
	{
		s->cycle_time = current - s->prec;
		s->prec = current;
	}
	else
	{
		s->up_time = current - s->prec;
	}
}

uint32_t getFrequency(PWMSignal *s)
{
	if (s->cycle_time == 0)
		return 0;
	return (FREQ_CLK / PRE_SCALER) / s->cycle_time;
}
uint32_t getDutyCycle(PWMSignal *s)
{
	if (s->cycle_time == 0)
		return 0;
	return ((float) s->up_time / s->cycle_time) * 100.0;
}

