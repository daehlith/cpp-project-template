cmake_minimum_required(VERSION 3.21)

# Ensure our cmake scripts are available
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Source information from `vcpkg.json` manifest
include(VcpkgHelpers)
setup_vcpkg_before_project()
load_vcpkg_json_information()

# We use vcpkg manifest information here to avoid duplicating this information here.
project(${VCPKG_PROJECT_NAME}
    VERSION ${VCPKG_PROJECT_VERSION}
    DESCRIPTION ${VCPKG_PROJECT_DESCRIPTION}
    HOMEPAGE_URL ${VCPKG_PROJECT_HOMEPAGE_URL}
    LANGUAGES CXX)

# C++17 is the latest version that is almost completely supported by major compilers (AppleClang, Clang, GCC and MSVC)
# See https://en.cppreference.com/w/cpp/17 vs. https://en.cppreference.com/w/cpp/20
set(CMAKE_CXX_STANDARD 17 CACHE STRING "The C++ standard to use")
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Force library symbol visibility to be the same as when compiling MSVC, unless explicitly overridden.
# NB: MSVC hides library symbols by default and requires explicit export annotations in code.
if(NOT MSVC)
    if(NOT DEFINED CMAKE_CXX_VISIBILITY_PRESET)
        set(CMAKE_CXX_VISIBILITY_PRESET hidden)
    endif()
    if(NOT DEFINED CMAKE_VISIBILITY_INLINES_HIDDEN)
        set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)
    endif()
endif()

# Useful to have the print helpers around for debugging purposes
include(CMakePrintHelpers)

# So that targets can add version information to themselves
include(VersionInfo)

# Provide full support for CTest, assuming that we're the top level project. Otherwise it's down to any project that
# includes us. See https://cliutils.gitlab.io/modern-cmake/chapters/testing.html
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    include(CTest)
endif()


# An example application target to illustrate how the project could be structured
add_subdirectory(src/foo)

# An example library target to illustrate how the project could be structured
add_subdirectory(src/bar)
