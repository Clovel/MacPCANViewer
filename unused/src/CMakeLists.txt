# 
#          Copyright (C) 2019 Clovis Durand <cd.clovel19@gmail.com>
# 
# -----------------------------------------------------------------------------

# Headers ---------------------------------------
file(GLOB_RECURSE PUBLIC_HEADERS 
    ${CMAKE_SOURCE_DIR}/inc/*.h
    ${CMAKE_SOURCE_DIR}/inc/*.hpp
)

# Sources ---------------------------------------
file(GLOB_RECURSE SOURCES
    ${CMAKE_SOURCE_DIR}/src/*.c
    ${CMAKE_SOURCE_DIR}/src/*.cpp
)

# Target definition -----------------------------
add_library(${CMAKE_PROJECT_NAME} SHARED
    ${SOURCES}
)
target_link_libraries(
    ${PROJECT_NAME} PUBLIC
    PCBUSB
)
