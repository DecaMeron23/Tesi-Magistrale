################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../STM32_WPAN/App/PWM_SIGNAL/pwm_signal.c 

OBJS += \
./STM32_WPAN/App/PWM_SIGNAL/pwm_signal.o 

C_DEPS += \
./STM32_WPAN/App/PWM_SIGNAL/pwm_signal.d 


# Each subdirectory must supply rules for building sources it contributes
STM32_WPAN/App/PWM_SIGNAL/%.o STM32_WPAN/App/PWM_SIGNAL/%.su STM32_WPAN/App/PWM_SIGNAL/%.cyclo: ../STM32_WPAN/App/PWM_SIGNAL/%.c STM32_WPAN/App/PWM_SIGNAL/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32WB5Mxx -c -I../Core/Inc -I../Drivers/STM32WBxx_HAL_Driver/Inc -I../Drivers/STM32WBxx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32WBxx/Include -I../Drivers/CMSIS/Include -I../STM32_WPAN/App -I../Utilities/lpm/tiny_lpm -I../Middlewares/ST/STM32_WPAN -I../Middlewares/ST/STM32_WPAN/interface/patterns/ble_thread -I../Middlewares/ST/STM32_WPAN/interface/patterns/ble_thread/tl -I../Middlewares/ST/STM32_WPAN/interface/patterns/ble_thread/shci -I../Middlewares/ST/STM32_WPAN/utilities -I../Middlewares/ST/STM32_WPAN/ble/core -I../Middlewares/ST/STM32_WPAN/ble/core/auto -I../Middlewares/ST/STM32_WPAN/ble/core/template -I../Middlewares/ST/STM32_WPAN/ble/svc/Inc -I../Middlewares/ST/STM32_WPAN/ble/svc/Src -I../Utilities/sequencer -I../Middlewares/ST/STM32_WPAN/ble -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-STM32_WPAN-2f-App-2f-PWM_SIGNAL

clean-STM32_WPAN-2f-App-2f-PWM_SIGNAL:
	-$(RM) ./STM32_WPAN/App/PWM_SIGNAL/pwm_signal.cyclo ./STM32_WPAN/App/PWM_SIGNAL/pwm_signal.d ./STM32_WPAN/App/PWM_SIGNAL/pwm_signal.o ./STM32_WPAN/App/PWM_SIGNAL/pwm_signal.su

.PHONY: clean-STM32_WPAN-2f-App-2f-PWM_SIGNAL

