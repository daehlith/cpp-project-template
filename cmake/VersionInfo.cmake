#[[
Generates a `<version.h>` header file with useful build environment and project information, f.e. the version number
and Git status. See `cmake/version.h.in` for details about available constants.

Additionally a `VersionInfo` target is provided. Other targets can link against this target to add the relevant include
directory containing the `<version.h>` header file.
]]

if(NOT CMAKE_PROJECT_NAME)
    message(FATAL_ERROR "Cannot generate version information without a `project()`")
endif()

if(NOT GIT_FOUND)
    find_package(Git)
endif()

if(GIT_FOUND)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE)
else()
    message(WARNING "Git was not found, version information will not contain git details")
endif()
if(NOT GIT_BRANCH)
    set(GIT_BRANCH "Unknown branch")
endif()
if(NOT GIT_COMMIT_HASH)
    set(GIT_COMMIT_HASH "Unknown commit")
endif()

message(STATUS "Git current branch: ${GIT_BRANCH}")
message(STATUS "Git commit hash: ${GIT_COMMIT_HASH}")

configure_file(
    cmake/version.h.in
    .generated/VersionInfo/version.h
    NEWLINE_STYLE UNIX)

add_library(VersionInfo INTERFACE)
target_include_directories(VersionInfo INTERFACE ${CMAKE_BINARY_DIR}/.generated/VersionInfo/)
