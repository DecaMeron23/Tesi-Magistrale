################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
/home/emilio/Documenti/universita/tesi/STMCubeIDE/workspace/LIB_PWM_SIGNAL/pwmsignal/pwmsignal.c 

OBJS += \
./pwmsignal/pwmsignal.o 

C_DEPS += \
./pwmsignal/pwmsignal.d 


# Each subdirectory must supply rules for building sources it contributes
pwmsignal/pwmsignal.o: /home/emilio/Documenti/universita/tesi/STMCubeIDE/workspace/LIB_PWM_SIGNAL/pwmsignal/pwmsignal.c pwmsignal/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32WB5Mxx -c -I../Core/Inc -I../Drivers/STM32WBxx_HAL_Driver/Inc -I../Drivers/STM32WBxx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32WBxx/Include -I../Drivers/CMSIS/Include -I/home/emilio/Documenti/universita/tesi/STMCubeIDE/workspace/LIB_PWM_SIGNAL -I"/home/emilio/Documenti/universita/tesi/STMCubeIDE/workspace/LIB_PWM_SIGNAL/pwmsignal" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-pwmsignal

clean-pwmsignal:
	-$(RM) ./pwmsignal/pwmsignal.cyclo ./pwmsignal/pwmsignal.d ./pwmsignal/pwmsignal.o ./pwmsignal/pwmsignal.su

.PHONY: clean-pwmsignal

