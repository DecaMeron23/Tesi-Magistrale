################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/RGB_LED/tlc59731.c 

OBJS += \
./Drivers/RGB_LED/tlc59731.o 

C_DEPS += \
./Drivers/RGB_LED/tlc59731.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/RGB_LED/%.o Drivers/RGB_LED/%.su Drivers/RGB_LED/%.cyclo: ../Drivers/RGB_LED/%.c Drivers/RGB_LED/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32WB5Mxx -c -I"/home/emilio/Documenti/universita/tesi/STMCubeIDE/workspace/BLE_P2P_SERVER/Library/pwmsignal" -I../Core/Inc -I../STM32_WPAN/App -I../Drivers/STM32WBxx_HAL_Driver/Inc -I../Drivers/STM32WBxx_HAL_Driver/Inc/Legacy -I../Utilities/lpm/tiny_lpm -I../Middlewares/ST/STM32_WPAN -I../Middlewares/ST/STM32_WPAN/interface/patterns/ble_thread -I../Middlewares/ST/STM32_WPAN/interface/patterns/ble_thread/tl -I../Middlewares/ST/STM32_WPAN/interface/patterns/ble_thread/shci -I../Middlewares/ST/STM32_WPAN/utilities -I../Middlewares/ST/STM32_WPAN/ble/core -I../Middlewares/ST/STM32_WPAN/ble/core/auto -I../Middlewares/ST/STM32_WPAN/ble/core/template -I../Middlewares/ST/STM32_WPAN/ble/svc/Inc -I../Middlewares/ST/STM32_WPAN/ble/svc/Src -I../Drivers/CMSIS/Device/ST/STM32WBxx/Include -I../Utilities/sequencer -I../Middlewares/ST/STM32_WPAN/ble -I../Drivers/CMSIS/Include -I"/home/emilio/Documenti/universita/tesi/STMCubeIDE/workspace/BLE_P2P_SERVER/Drivers/RGB_LED" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-RGB_LED

clean-Drivers-2f-RGB_LED:
	-$(RM) ./Drivers/RGB_LED/tlc59731.cyclo ./Drivers/RGB_LED/tlc59731.d ./Drivers/RGB_LED/tlc59731.o ./Drivers/RGB_LED/tlc59731.su

.PHONY: clean-Drivers-2f-RGB_LED

