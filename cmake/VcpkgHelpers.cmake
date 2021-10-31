#[[
Ensures that the vcpkg toolchain file is used.

Additionally, a `load_vcpkg_json_information()` function is provided. This function exposes the following information
from the `vcpkg.json` manifest file to CMake:

    `VCPKG_PROJECT_NAME` - the `name` attribute
    `VCPKG_PROJECT_VERSION` - the `version-semver` attribute
    `VCPKG_PROJECT_DESCRIPTION` - the `description` attribute
    `VCPKG_PROJECT_HOMEPAGE_URL` - the `homepage` attribute
    `VCPKG_PROJECT_DEPENDENCIES` - a list of the names of all `dependencies`
]]

if(DEFINED ENV{VCPKG_TARGET_TRIPLET} AND NOT DEFINED VCPKG_TARGET_TRIPLET)
    set(VCPKG_TARGET_TRIPLET "$ENV{VCPKG_TARGET_TRIPLET}" CACHE STRING "")
endif()

if(DEFINED ENV{VCPKG_ROOT} AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
        CACHE STRING "")
endif()

function(load_vcpkg_json_information)
    file(READ "${CMAKE_SOURCE_DIR}/vcpkg.json" _RAW_VCPKG)
    set(PROJECT_VCPKG_JSON ${_RAW_VCPKG})

    string(JSON VCPKG_PROJECT_NAME GET ${PROJECT_VCPKG_JSON} "name")
    string(JSON VCPKG_PROJECT_VERSION GET ${PROJECT_VCPKG_JSON} "version")
    string(JSON VCPKG_PROJECT_DESCRIPTION GET ${PROJECT_VCPKG_JSON} "description")
    string(JSON VCPKG_PROJECT_HOMEPAGE_URL GET ${PROJECT_VCPKG_JSON} "homepage")
    string(JSON PROJECT_DEPENDENCIES_JSON GET ${PROJECT_VCPKG_JSON} "dependencies")
    string(JSON PROJECT_DEPENDENCIES_LENGTH LENGTH ${PROJECT_VCPKG_JSON} "dependencies")

    foreach(PROJECT_DEPENDENCY_INDEX RANGE ${PROJECT_DEPENDENCIES_LENGTH})
        if(${PROJECT_DEPENDENCY_INDEX} EQUAL ${PROJECT_DEPENDENCIES_LENGTH})
            break()
        endif()
        string(JSON CURRENT_DEPENDENCY_TYPE TYPE ${PROJECT_VCPKG_JSON} "dependencies" ${PROJECT_DEPENDENCY_INDEX})
        if(CURRENT_DEPENDENCY_TYPE STREQUAL OBJECT)
            string(JSON CURRENT_DEPENDENCY GET ${PROJECT_VCPKG_JSON} "dependencies" ${PROJECT_DEPENDENCY_INDEX} "name")
        elseif(CURRENT_DEPENDENCY_TYPE STREQUAL STRING)
            string(JSON CURRENT_DEPENDENCY GET ${PROJECT_VCPKG_JSON} "dependencies" ${PROJECT_DEPENDENCY_INDEX})
        else()
            message(FATAL_ERROR "Unexpected vcpkg dependencies entry ${CURRENT_DEPENDENCY_TYPE} at index ${PROJECT_DEPENDENCY_INDEX}")
        endif()
        list(APPEND VCPKG_PROJECT_DEPENDENCIES ${CURRENT_DEPENDENCY})
    endforeach()

    set(VCPKG_PROJECT_NAME ${VCPKG_PROJECT_NAME} PARENT_SCOPE)
    set(VCPKG_PROJECT_DESCRIPTION ${VCPKG_PROJECT_DESCRIPTION} PARENT_SCOPE)
    set(VCPKG_PROJECT_HOMEPAGE_URL ${VCPKG_PROJECT_HOMEPAGE_URL} PARENT_SCOPE)
    set(VCPKG_PROJECT_VERSION ${VCPKG_PROJECT_VERSION} PARENT_SCOPE)
    set(VCPKG_PROJECT_DEPENDENCIES ${VCPKG_PROJECT_DEPENDENCIES} PARENT_SCOPE)
endfunction()
