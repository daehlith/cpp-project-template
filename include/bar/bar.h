#pragma once

#include <vector>

#include <bar/bar_export.h> // Provides symbol visibility helper macros

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

/*! \brief A class to calculate the Fibonacci sequence
 *
 */
class BAR_EXPORT FibonacciSequence
{
public:
    //! Constructs a Fibonacci sequence up to, and including, the Nth number
    explicit FibonacciSequence(size_t n = 0);

    //! returns the Nth Fibonacci number
    uint64_t at(size_t n);

    //! return the generators current Fibonacci number
    uint64_t current() const;

    //! return the next Fibonacci number in the sequence
    uint64_t next();

private:
    // Avoid dealing with the special case of the first two numbers
    std::vector<uint64_t> mState { 0, 1 };
    uint64_t mCurrent { 0 };
};
