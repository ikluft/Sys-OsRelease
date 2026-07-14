#!/usr/bin/env perl
# generate Makefile for Sys::OsRelease::Lite
#
# Copyright 2026 by Ian Kluft
# Open Source license Perl's Artistic License 2.0: <http://www.perlfoundation.org/artistic_license_2_0>
# SPDX-License-Identifier: Artistic-2.0
use v5.10;
use strict;
use warnings;
use utf8;
use Carp qw(croak);
use ExtUtils::MakeMaker;

my $semver;
open( my $fh, "-|", "./build_bin/get_semver.pl" )
    or croak "failed to run build/get_semver.pl to get version number: $!";
while (<$fh>) {
    $semver .= $_;
}
close $fh
    or croak "failed to close pipe from build/get_semver.pl: $!";
chomp $semver;

WriteMakefile(
    NAME             => "Sys::OsRelease::Lite",
    VERSION          => $semver,
    MIN_PERL_VERSION => "5.10.0",
    #PL_FILES         => {
    #    "lib/Sys/OsRelease/Lite.pm.PL" => { "templates/Lite.pm" => "lib/Sys/OsRelease/Lite.pm" }
    #},
    #PREREQ_PM => {
    #    "CPAN::Changes" => 0,
    #    "Versioning::Scheme::Semantic" => 0,
    #},
    #depend => {
    #    Makefile                    => 'lib/Sys/OsRelease/Lite.pm',
    #    "lib/Sys/OsRelease/Lite.pm" => "lib/Sys/OsRelease/Lite.pm.PL"
    #},
);
