#include <iostream>

#include <bar/bar.h>

void printArguments(int argc, char **argv)
{
    std::cout << "Received " << argc << (argc > 1 ? " arguments:" : " argument:") << std::endl;

    for (int i = 0; i < argc; ++i) {
        std::cout << "\t" << argv[i] << std::endl; // NOLINT(cppcoreguidelines-pro-bounds-pointer-arithmetic)
    }
}

FibonacciSequence::FibonacciSequence(size_t n)
{
    for (int i = 1; i < n; ++i) {
        next();
    }
}

uint64_t FibonacciSequence::at(size_t n)
{
    if (n < mState.size()) {
        return mState.at(n);
    }

    while (mState.size() <= n) {
        next();
    }

    return current();
}

uint64_t FibonacciSequence::current() const
{
    return mCurrent;
}

uint64_t FibonacciSequence::next()
{
    auto val = mState.back() + mState[mState.size() - 2];
    mState.emplace_back(val);
    mCurrent = val;
    return current();
}
