################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/flash_driver/MX25L4.c 

OBJS += \
./Core/Src/flash_driver/MX25L4.o 

C_DEPS += \
./Core/Src/flash_driver/MX25L4.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/flash_driver/%.o Core/Src/flash_driver/%.su Core/Src/flash_driver/%.cyclo: ../Core/Src/flash_driver/%.c Core/Src/flash_driver/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DCORE_CM4 -DUSE_HAL_DRIVER -DSTM32WL5Mxx -c -I../Core/Inc -I../Drivers/STM32WLxx_HAL_Driver/Inc -I../Drivers/STM32WLxx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-flash_driver

clean-Core-2f-Src-2f-flash_driver:
	-$(RM) ./Core/Src/flash_driver/MX25L4.cyclo ./Core/Src/flash_driver/MX25L4.d ./Core/Src/flash_driver/MX25L4.o ./Core/Src/flash_driver/MX25L4.su

.PHONY: clean-Core-2f-Src-2f-flash_driver

