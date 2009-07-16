use inc::Module::Install;
name 'Algorithm-Bayon';
all_from 'lib/Algorithm/Bayon.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
