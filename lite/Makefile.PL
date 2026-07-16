#!/usr/bin/env perl
# generate Makefile for Sys::OsRelease::Lite
#
# Copyright 2026 by Ian Kluft
# Open Source license Perl's Artistic License 2.0: <http://www.perlfoundation.org/artistic_license_2_0>
# SPDX-License-Identifier: Artistic-2.0
use v5.10.1;
use strict;
use warnings;
use utf8;
use Carp qw(croak);
use ExtUtils::MakeMaker;

my $semver;
open( my $fh, "-|", "perl", "build_tools/get_semver.pl" )
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
    MIN_PERL_VERSION => "5.10.1",
    PL_FILES         => {
        "build_tools/src_filter.pl" => {
            "lib/Sys/OsRelease/Lite.pm" => "build_tools/input/OsRelease.pm",
            "t/001_module_load.t" => "build_tools/input/001_module_load.t",
            "t/002_basic.t" => "build_tools/input/002_basic.t",
            "t/003_samples.t" => "build_tools/input/003_samples.t",
            "t/004_import.t" => "build_tools/input/004_import.t",
        }
    },
    #PREREQ_PM => {
    #    "CPAN::Changes" => 0,
    #    "Versioning::Scheme::Semantic" => 0,
    #},
    depend => {
        Makefile                    => 'build_tools/get_semver.pl',
    },
    postamble => "export VERSION",
);
