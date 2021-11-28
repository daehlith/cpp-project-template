#[[
Provides the following utility functions for Qt 6 projects:

`target_run_qt_deploy_tool_post_build(<target>)` - runs either `windeployqt` or `macdeployqt` as a post-build step for
the provided target.
]]
function(target_run_qt_deploy_tool_post_build target)
    if(NOT Qt6_FOUND)
        find_package(Qt6 COMPONENTS Core REQUIRED)
    endif()

    set(_tool_name "windeployqt")
    if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
        set(_tool_name "macdeployqt")
    endif()
    find_program(_tool_path ${_tool_name}
        PATHS
        "${QT6_INSTALL_PREFIX}/bin"  # default location
        "${QT6_INSTALL_PREFIX}/tools/Qt6/bin" # when installed through vcpkg
        REQUIRED)
    get_target_property(target_binary_dir ${target} BINARY_DIR)
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND "${_tool_path}" "$<TARGET_FILE:${target}>"
        VERBATIM
        WORKING_DIRECTORY ${target_binary_dir})
endfunction()
