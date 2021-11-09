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
    execute_process(
        COMMAND ${GIT_EXECUTABLE} diff-index --quiet HEAD --
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        ERROR_QUIET
        OUTPUT_QUIET
        RESULT_VARIABLE GIT_UNCOMMITTED_CHANGES
    )
    execute_process(
        COMMAND ${GIT_EXECUTABLE} ls-files --exclude-standard --other --error-unmatch
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        ERROR_QUIET
        OUTPUT_QUIET
        RESULT_VARIABLE GIT_UNTRACKED_UNIGNORED_FILES
    )
else()
    message(WARNING "Git was not found, version information will not contain git details")
endif()
if(NOT GIT_BRANCH)
    set(GIT_BRANCH "Unknown branch")
endif()
if(NOT GIT_COMMIT_HASH)
    set(GIT_COMMIT_HASH "Unknown commit")
endif()

set(PROJECT_VERSION_STR "${PROJECT_VERSION} / ${GIT_BRANCH} @ ${GIT_COMMIT_HASH}")

if(GIT_UNTRACKED_UNIGNORED_FILES OR GIT_UNCOMMITTED_CHANGES)
    set(GIT_DIRTY true)
    set(PROJECT_VERSION_STR "${PROJECT_VERSION_STR} (dirty)")
else()
    set(GIT_DIRTY false)
endif()

message(STATUS "Git current branch: ${GIT_BRANCH}")
message(STATUS "Git commit hash: ${GIT_COMMIT_HASH}")
message(STATUS "Git repository dirty: ${GIT_DIRTY}")

configure_file(
    cmake/version.h.in
    .generated/VersionInfo/version.h
    NEWLINE_STYLE UNIX)

add_library(VersionInfo INTERFACE)
target_include_directories(VersionInfo INTERFACE ${CMAKE_BINARY_DIR}/.generated/VersionInfo/)
