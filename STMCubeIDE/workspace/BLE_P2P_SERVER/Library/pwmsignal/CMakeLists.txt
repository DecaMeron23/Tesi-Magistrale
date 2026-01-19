add_library(pwmsignal STATIC
    pwmsignal.c
)

target_include_directories(pwmsignal PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)