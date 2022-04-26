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

use Test::More tests => 6;                      # last test to print

# instantiation (2 tests)
my $osrelease = Sys::OsRelease->instance();
isa_ok($osrelease, "Sys::OsRelease", "correct type from instance()");
my $osrelease2 = Sys::OsRelease->instance();
is($osrelease, $osrelease2, "same instance from 2nd call to instance()");

# module data (2 tests)
my @std_search_path = Sys::OsRelease::std_search_path();
ok(scalar @std_search_path > 0, "std_search_path() returned non-empty list");
my @std_attrs = Sys::OsRelease::std_attrs();
ok(scalar @std_attrs > 0, "std_attrs() returned non-empty list");

# check if os-release exists on the system performing the tests (2 tests)
SKIP: {
    my $osr_found;
    foreach my $dir (@std_search_path) {
        if ( -f "$dir/os-release" ) {
            $osr_found = "$dir/os-release";
            last;
        }
    }
    skip("os-release not found on test system", 2) if not $osr_found;

    ok($osrelease->can("id"), "id() method exists");
    my $id = $osrelease->id();
    ok(defined $id, "id() method returned a value");
}
