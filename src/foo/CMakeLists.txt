add_executable(foo main.cpp)
target_add_version_info(foo)
target_link_libraries(foo PRIVATE bar)
