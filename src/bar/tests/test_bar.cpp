#include <bar/bar.h>

#include <gtest/gtest.h>

TEST(FibonacciSequence, Construction)
{
    FibonacciSequence s1;
    EXPECT_EQ(s1.current(), 0);
}

TEST(FibonacciSequence, RandomAccess)
{
    FibonacciSequence seq;
    EXPECT_EQ(seq.at(0), 0);
    EXPECT_EQ(seq.at(9), 34);
}

TEST(FibonacciSequence, Current)
{
    FibonacciSequence seq(8);
    EXPECT_EQ(seq.current(), 21);
}

TEST(FibonacciSequence, Next)
{
    FibonacciSequence seq(6);
    EXPECT_EQ(seq.next(), 13);
}
