################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/MX25L4x/MX25L4x.c 

OBJS += \
./Core/Src/MX25L4x/MX25L4x.o 

C_DEPS += \
./Core/Src/MX25L4x/MX25L4x.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/MX25L4x/%.o Core/Src/MX25L4x/%.su Core/Src/MX25L4x/%.cyclo: ../Core/Src/MX25L4x/%.c Core/Src/MX25L4x/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DCORE_CM4 -DUSE_HAL_DRIVER -DSTM32WL5Mxx -c -I../Core/Inc -I../Drivers/STM32WLxx_HAL_Driver/Inc -I../Drivers/STM32WLxx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32WLxx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-MX25L4x

clean-Core-2f-Src-2f-MX25L4x:
	-$(RM) ./Core/Src/MX25L4x/MX25L4x.cyclo ./Core/Src/MX25L4x/MX25L4x.d ./Core/Src/MX25L4x/MX25L4x.o ./Core/Src/MX25L4x/MX25L4x.su

.PHONY: clean-Core-2f-Src-2f-MX25L4x

