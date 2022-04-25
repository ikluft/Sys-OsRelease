# Sys::OsRelease
# ABSTRACT: read operating system details from FreeDesktop.Org standard /etc/os-release file
# Copyright (c) 2022 by Ian Kluft
# Open Source license Perl's Artistic License 2.0: <http://www.perlfoundation.org/artistic_license_2_0>
# SPDX-License-Identifier: Artistic-2.0

# This module must be maintained for minimal dependencies so it can be used to build systems and containers.

## no critic (Modules::RequireExplicitPackage)
# This solves a catch-22 where conflicting Perl::Critic rules want package and strictures each before the other
use strict;
use warnings;
use utf8;
## use critic (Modules::RequireExplicitPackage)

package Sys::OsRelease;

use Carp qw(carp croak);

# the instance - use Sys::OsRelease->instance() to get it
my $_instance;

# defined attributes from FreeDesktop's os-release standard - this needs to be kept up-to-date with the standard
my @std_attrs = qw(NAME ID ID_LIKE PRETTY_NAME CPE_NAME VARIANT VARIANT_ID VERSION VERSION_ID VERSION_CODENAME
    BUILD_ID IMAGE_ID IMAGE_VERSION HOME_URL DOCUMENTATION_URL SUPPORT_URL BUG_REPORT_URL PRIVACY_POLICY_URL
    LOGO ANSI_COLOR DEFAULT_HOSTNAME SYSEXT_LEVEL);

# fold case for case-insensitive matching
my $can_fc = CORE->can("fc"); # test fc() once and save result
sub fold_case
{
    my $str = shift;

    # use fc if available, otherwise lc to support older Perls
    return $can_fc ?  fc $str : lc $str;
}

# new method calls instance
sub new
{
    my ($class, @params) = @_;
    return $class->instance(@params);
}

# singleton class instance
sub instance
{
    my ($class, @params) = @_;

    # enforce class lineage
    if (not $class->isa(__PACKAGE__)) {
        croak "cannot find instance: ".(ref $class ? ref $class : $class)." is not a ".__PACKAGE__;
    }

    # initialize if not already done
    if (not defined $_instance) {
        $_instance = $class->_new_instance(@params);
    }

    # generate accessor methods
    $_instance->gen_accessors();

    # return singleton instance
    return $_instance;
}

# initialize a new instance
sub _new_instance
{
    my ($class, @params) = @_;

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
        if (-r "$search_dir/os-release") {
            $osrelease_path = $search_dir."/os-release";
            last;
        }
    }

    # If we didn't find os-release on this system, this module has no data to start. So don't.
    if (not defined $osrelease_path) {
        return;
    }
    $obj{config}{osrelease_path} = $osrelease_path;

    # read os-release file
    ## no critic (InputOutput::RequireBriefOpen)
    if (open my $fh, "<", $osrelease_path) {
        while (<$fh>) {
            chomp;

            # skip comments and blank lines
            if (/^ \s+ #/x or /^ \s+ $/x) {
                next;
            }

            # read attribute assignment lines
            if (/^ ([A-Z0-9_]+) = "(.*)" $/x
                or /^ ([A-Z0-9_]+) = '(.*)' $/x
                or /^ ([A-Z0-9_]+) = (.*) $/x)
            {
                next if $1 eq "config"; # don't overwrite config
                $obj{fold_case($1)} = $2;
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

# call destructor when program ends
END {
    # dereferencing will destroy singleton instance
    undef $_instance;
}

# config read/write accessor
# second purpose of this method: name matching %{$self->{config}} protects it from AUTOLOAD interference
sub config
{
    my ($self, $key, $value) = @_;
    if (defined $value) {
        $self->{config}{$key} = $value;
    }
    return $self->{config}{$key};
}

# generate accessor methods for all defined and standardized attributes
sub gen_accessors
{
    my $self = shift;
    my $class = (ref $self) ? ref $self : $self; 

    # generate read-only accessors for attributes actually found in os-release
    foreach my $key (sort keys %{$self}) {
        next if $key eq "config"; # protect special/reserved attribute
        my $method_name = "$class::$key";
        *{$method_name} = sub { return $self->{$key} // undef };
    }

    # generate undef accessors for standardized attributes which were not found in os-release
    foreach my $std_attr (@std_attrs) {
        next if $std_attr eq "config"; # protect special/reserved attribute
        my $fc_attr = fold_case($std_attr);
        next if exists $self->{$fc_attr};
        my $method_name = "$class::$fc_attr";
        *{$method_name} = sub { return; };
    }
    return;
}

1;

__END__

# POD documentation
=encoding utf8

=head1 NAME

Sys::OsRelease - read operating system details from FreeDesktop.Org standard /etc/os-release file

=head1 SYNOPSIS

my $osrelease = Sys::OsRelease->instance();
my $id = $osrelease->id();
my $id_like = $osrelease->id_like();

=head1 DESCRIPTION

Sys::OsRelease is a helper library to read the /etc/os-release file, as defined by FreeDesktop.Org.
The os-release file is used to define an operating system environment.
It was started on Linux systems which use the systemd software, but then spread to other Linux, BSD and
Unix-based systems.
Its purpose is to identify the system to any software which needs to know.
It differentiates between Unix-based operating systems and even between Linux distributions.

Sys::OsRelease is implemented with a singleton model, meaning there is only one instance of the class.
Instead of instantiating an object with new(), the instance() class method returns the one and only instance.
The first time it's called, it instantiates it.
On following calls, it returns a reference to the existing instance.

This module maintains minimal prerequisites, and only those which are usually included with Perl.
(Suggestions of new features and code will largely depend on following this rule.)
That it intended to make it acceptable for establishing system or container environments which contain Perl programs.
It can also be used for installing or configuring software that needs to know about the system environment.

=head1 SEE ALSO

FreeDesktop.Org's os-release standard: L<https://www.freedesktop.org/software/systemd/man/os-release.html>

GitHub repository for Sys::OsRelease: L<https://github.com/ikluft/Sys-OsRelease>

=head1 BUGS AND LIMITATIONS

Please report bugs via GitHub at L<https://github.com/ikluft/Sys-OsRelease/issues>

Patches and enhancements may be submitted via a pull request at L<https://github.com/ikluft/Sys-OsRelease/pulls>

=head1 LICENSE INFORMATION

Copyright (c) 2022 by Ian Kluft

This module is distributed in the hope that it will be useful, but it is provided “as is” and without any express or implied warranties. For details, see the full text of the license in the file LICENSE or at L<https://www.perlfoundation.org/artistic-license-20.html>.
