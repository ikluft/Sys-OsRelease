# Sys::OsRelease
# ABSTRACT: helper library in Perl for reading OS info from FreeDesktop.Org-standard /etc/os-release file
# Copyright (c) 2022 by Ian Kluft
# Open Source license under the same terms as Perl itself: <http://www.perl.com/perl/misc/Artistic.html>

# This module must be maintained for minimal dependencies so it can be used to build systems and containers.
use strict;
use warnings;
use utf8;

package Sys::OsRelease;

use Carp qw(carp croak);

# singleton class instance
my $_instance;
sub instance
{
    my $class = shift;
    my @params = @_;

    # enforce class lineage
    if (not $class->isa(__PACKAGE__)) {
        croak "cannot find instance: ".(ref $class ? ref $class : $class)." is not a ".__PACKAGE__;
    }

    # initialize if not already done
    if (not defined $_instance) {
        $_instance = $class->_new_instance(@params);
    }

    # return singleton instance
    return $_instance;
}

# initialize a new instance
sub _new_instance
{
    my $class = shift;
    my @params = @_;

    # enforce class lineage
    if (not $class->isa(__PACKAGE__)) {
        croak "cannot find instance: ".(ref $class ? ref $class : $class)." is not a ".__PACKAGE__;
    }

    # obtain parameters from array or hashref
    my %obj;
    if (scalar @params > 0) {
        if (ref $params[0] eq 'HASH') {
            $obj{config} = $params[0];
        } else {
            $obj{config} = {@params};
        }
    }

    # locate os-release file in standard places
    my $osrelease_path;
    my @search_path = ((exists $obj{config}{osr_path}) ? @{$obj{config}{osr_path}} : qw(/etc /usr/lib /run/host));
    foreach my $search_dir (@search_path) {
        if (-r $search_dir."/os-release") {
            $osrelease_path = $search_dir."/os-release";
            last;
        }
    }

    # if we didn't find os-release on this system, this module has no data to start
    if (not defined $osrelease_path) {
        return;
    }
    $obj{config}{osrelease_path} = $osrelease_path;

    # read os-release file
    ## no critic (InputOutput::RequireBriefOpen)
    if (open my $fh, "<", $osrelease_path) {
        while (<$fh>) {
            chomp;
            if (/^ ([A-Z0-9_]+) = "(.*)" $/x) {
                next if $1 eq "config"; # don't overwrite config
                $obj{$1} = $2;
            } elsif (/^ ([A-Z0-9_]+) = '(.*)' $/x) {
                next if $1 eq "config"; # don't overwrite config
                $obj{$1} = $2;
            } elsif (/^ ([A-Z0-9_]+) = (.*) $/x) {
                next if $1 eq "config"; # don't overwrite config
                $obj{$1} = $2;
            } else {
                carp "warning: unable to parse line from $osrelease_path: $_";
            }
        }
        close $fh;
    }
    ## use critic (InputOutput::RequireBriefOpen)

    # instantiate object
    return bless \%obj, $class;
}

# destructor when program ends
END {
    # dereferencing will destroy singleton instance
    undef $_instance;
}

1;
