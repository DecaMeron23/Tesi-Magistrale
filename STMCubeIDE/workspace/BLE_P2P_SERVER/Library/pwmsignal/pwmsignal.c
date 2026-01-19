/*
 * pwmsignal.c
 *
 *  Created on: 24 dic 2025
 *      Author: emilio
 */

#include "pwmsignal.h"
#include <stdint.h>

#ifndef __MAIN_H
// Forward declaration della funzione HAL_TIM_ReadCapturedValue
uint32_t HAL_TIM_ReadCapturedValue(TIM_HandleTypeDef *htim, int channel);
#endif /* __MAIN_H */

void PWM_SIGNAL_Init(PWM_SIGNAL_TypeDef *s, uint32_t freq_clk, uint32_t pre_scaler,
                         uint8_t is_16_bit) {
  s->tim_freq = freq_clk / pre_scaler;
  s->is_16_bit = is_16_bit;
}

void PWM_SIGNAL_ComputePWM(PWM_SIGNAL_TypeDef *s, TIM_HandleTypeDef *htim, int channel,
                      uint8_t is_rising) {
  uint32_t counter = HAL_TIM_ReadCapturedValue(htim, channel);
  uint32_t diff = counter - s->prec;
  if (s->is_16_bit) {
    diff = (uint16_t)diff;
  }

  if (is_rising) {
    s->cycle_time = diff;
    s->prec = counter;
  } else {
    s->up_time = diff;
  }
}

uint32_t PWM_SIGNAL_GetFrequency(PWM_SIGNAL_TypeDef *s) {
  if (s->cycle_time == 0)
    return 0;
  return s->tim_freq / s->cycle_time;
}
uint32_t PWM_SIGNAL_GetDutyCycle(PWM_SIGNAL_TypeDef *s) {
  if (s->cycle_time == 0)
    return 0;
  return ((float)s->up_time / s->cycle_time) * 100.0;
}
