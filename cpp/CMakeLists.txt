cmake_minimum_required(VERSION 3.21)

project(FingerprintModule LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Qml
    DBus
)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_qml_module(FingerprintModule
    URI Fingerprint
    VERSION 1.0

    OUTPUT_DIRECTORY
        ${CMAKE_SOURCE_DIR}/../Fingerprint

    SOURCES
        FingerprintManager.cpp
        FingerprintManager.h
        VerifyStatus.h
        proxies/manager_proxy.h
        proxies/device_proxy.cpp
        proxies/manager_proxy.cpp
        proxies/device_proxy.h
)

target_include_directories(FingerprintModule PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(FingerprintModule PRIVATE
    Qt6::Core
    Qt6::Qml
    Qt6::DBus
)

set_target_properties(FingerprintModule PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY
        ${CMAKE_SOURCE_DIR}/../Fingerprint
)

set_target_properties(FingerprintModuleplugin PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY
        ${CMAKE_SOURCE_DIR}/../Fingerprint
)