cmake_minimum_required(VERSION 3.21)

# Ensure our cmake scripts are available
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# it's useful to have the print helpers around for debugging purposes
include(CMakePrintHelpers)

# Source information from vcpkg.json
include(VcpkgHelpers)
load_vcpkg_json_information()

project(${VCPKG_PROJECT_NAME}
    VERSION ${VCPKG_PROJECT_VERSION}
    DESCRIPTION ${VCPKG_PROJECT_DESCRIPTION}
    HOMEPAGE_URL ${VCPKG_PROJECT_HOMEPAGE_URL}
    LANGUAGES CXX)

# Expose project and version information to C++ code
include(VersionInfo)

# Boilerplate for automated testing
include(CTest)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ... add targets here ...
