# Let CMake decide the type of library based upon the `BUILD_SHARED_LIBS` variable.
# See https://cmake.org/cmake/help/latest/variable/BUILD_SHARED_LIBS.html
add_library(bar bar.cpp)

# Provide macros that can be used for exporting symbols in case a shared library is built as opposed to a static one.
include(GenerateExportHeader)
get_target_property(TARGET_BINARY_DIR bar BINARY_DIR)
set(GENERATED_HEADER_PATH ${TARGET_BINARY_DIR}/.generated/bar/bar_export.h)

# Ensure that generated and public header directories are valid include directories.
target_include_directories(bar PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/.generated>)
generate_export_header(bar EXPORT_FILE_NAME "${GENERATED_HEADER_PATH}")
