#pragma once

#include <bar/bar_export.h> // Provides symbol visbility helper macros

/*! \file
 *  \brief This library serves no purposes other than to be an example for structuring a project.
 *
 *  OK, that brief description is not entirely correct. It also provides documentation strings to test the
 *  doxygen integration. Take note that the `\file` directive is necessary to have doxygen include documentation on
 *  global functions like `printArguments()`.
 */

/*! \brief A simple utility function to print a program's command-line arguments
 *
 * This function's purpose is to simply aid in providing a library example in the template project.
 * Much like this comment really only provides value in that it demonstrates doxygen integration.
 *
 * @param argc Count of command-line arguments passed to the application
 * @param argv Array with strings representing the command-line arguments passed to the application
 */
BAR_EXPORT void printArguments(int argc, char **argv);
