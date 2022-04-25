#
#===============================================================================
#         FILE: 002_basic.t
#  DESCRIPTION: basic tests for Sys::OsRelease 
#       AUTHOR: Ian Kluft (IKLUFT)
#      VERSION: 1.0
#      CREATED: 04/25/2022 03:28:18 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use Sys::OsRelease;

use Test::More tests => 4;                      # last test to print

# instantiation (2 tests)
my $osrelease = Sys::OsRelease->instance();
isa_ok($osrelease, "Sys::OsRelease", "correct type from instance()");
my $osrelease2 = Sys::OsRelease->instance();
is($osrelease, $osrelease2, "same instance from 2nd call to instance()");

# module data (2 tests)
my @std_osr_path = Sys::OsRelease::std_osr_path();
ok(scalar @std_osr_path > 0, "std_osr_path() returned non-empty list");
my @std_attrs = Sys::OsRelease::std_attrs();
ok(scalar @std_attrs > 0, "std_attrs() returned non-empty list");
