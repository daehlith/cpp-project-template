#include <iostream>

#include <bar/bar.h>

void printArguments(int argc, char **argv)
{
    std::cout << "Received " << argc << (argc > 1 ? " arguments:" : " argument:") << std::endl;

    for (int i = 0; i < argc; ++i) {
        std::cout << "\t" << argv[i] << std::endl; // NOLINT(cppcoreguidelines-pro-bounds-pointer-arithmetic)
    }
}
