################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Drivers/STM32WBxx_HAL_Driver/subdir.mk
-include Drivers/CMSIS/subdir.mk
-include Drivers/BSP/P-NUCLEO-WB55.Nucleo/subdir.mk
-include Application/User/subdir.mk
-include Application/Startup/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

OPTIONAL_TOOL_DEPS := \
$(wildcard ../makefile.defs) \
$(wildcard ../makefile.init) \
$(wildcard ../makefile.targets) \


BUILD_ARTIFACT_NAME := STM32WB55_NUCLEO_HAL_TimeBase
BUILD_ARTIFACT_EXTENSION := elf
BUILD_ARTIFACT_PREFIX :=
BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
STM32WB55_NUCLEO_HAL_TimeBase.elf \

MAP_FILES += \
STM32WB55_NUCLEO_HAL_TimeBase.map \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
STM32WB55_NUCLEO_HAL_TimeBase.list \


# All Target
all: main-build

# Main-build Target
main-build: STM32WB55_NUCLEO_HAL_TimeBase.elf secondary-outputs

# Tool invocations
STM32WB55_NUCLEO_HAL_TimeBase.elf STM32WB55_NUCLEO_HAL_TimeBase.map: $(OBJS) $(USER_OBJS) /home/emilio/Documenti/universita/tesi/STMCubeIDE/STM32Cube_FW_WB_V1.24.0/Projects/P-NUCLEO-WB55.Nucleo/Examples/HAL/HAL_TimeBase/STM32CubeIDE/STM32WB55RGVX_FLASH.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-gcc -o "STM32WB55_NUCLEO_HAL_TimeBase.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m4 -T"/home/emilio/Documenti/universita/tesi/STMCubeIDE/STM32Cube_FW_WB_V1.24.0/Projects/P-NUCLEO-WB55.Nucleo/Examples/HAL/HAL_TimeBase/STM32CubeIDE/STM32WB55RGVX_FLASH.ld" --specs=nosys.specs -Wl,-Map="STM32WB55_NUCLEO_HAL_TimeBase.map" -Wl,--gc-sections -static --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

STM32WB55_NUCLEO_HAL_TimeBase.list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "STM32WB55_NUCLEO_HAL_TimeBase.list"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) STM32WB55_NUCLEO_HAL_TimeBase.elf STM32WB55_NUCLEO_HAL_TimeBase.list STM32WB55_NUCLEO_HAL_TimeBase.map default.size.stdout
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST)

fail-specified-linker-script-missing:
	@echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
	@exit 2

warn-no-linker-script-specified:
	@echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

.PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified

-include ../makefile.targets
