#include <iostream>

#include <version.h>
#include <bar/bar.h>

int main(int argc, char *argv[])
{
    std::cout << "Running " << PROJECT_NAME << " " << PROJECT_VERSION_STR << std::endl;
    std::cout << PROJECT_DESCRIPTION << std::endl;
    std::cout << "Visit " << PROJECT_HOMEPAGE_URL << " for more information." << std::endl << std::endl;

    printArguments(argc, argv);

    return 0;
}
