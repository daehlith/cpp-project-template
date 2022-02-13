#[[
Provides a `target_add_version_info(<target>)` function that can be used to generate a `<version.h>` header file for the
given target. The generated `<version.h>` header contains useful build environment and project information, f.e. the
CMake `project()` details and - if applicable - the Git repository status at the time of building.

See `cmake/version.h.in` for details about available constants.
]]

function(target_add_version_info target)
    message(STATUS "Adding version info to target ${target}")

    if(NOT PROJECT_NAME)
        message(FATAL_ERROR "Cannot generate version information without a `project()`")
    endif()

    if(NOT GIT_FOUND)
        find_package(Git)
    endif()

    if(GIT_FOUND)
        get_target_property(TARGET_SOURCE_DIR ${target} SOURCE_DIR)
        execute_process(
            COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
            WORKING_DIRECTORY ${TARGET_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_BRANCH
            OUTPUT_STRIP_TRAILING_WHITESPACE)
        execute_process(
            COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
            WORKING_DIRECTORY ${TARGET_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_COMMIT_HASH
            OUTPUT_STRIP_TRAILING_WHITESPACE)
        execute_process(
            COMMAND ${GIT_EXECUTABLE} diff-index --quiet HEAD --
            WORKING_DIRECTORY ${TARGET_SOURCE_DIR}
            ERROR_QUIET
            OUTPUT_QUIET
            RESULT_VARIABLE GIT_UNCOMMITTED_CHANGES
        )
        execute_process(
            COMMAND ${GIT_EXECUTABLE} ls-files --exclude-standard --other --error-unmatch
            # git ls-files only works correctly when run against the git repository root
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

    get_target_property(TARGET_BINARY_DIR ${target} BINARY_DIR)
    set(GENERATED_HEADER_PATH ${TARGET_BINARY_DIR}/.generated/VersionInfo)

    string(TIMESTAMP PROJECT_BUILD_DATETIME UTC)

    configure_file(
        ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/version.h.in
        ${GENERATED_HEADER_PATH}/version.h
        NEWLINE_STYLE UNIX)

    target_include_directories(${target} PRIVATE ${GENERATED_HEADER_PATH})
endfunction()
