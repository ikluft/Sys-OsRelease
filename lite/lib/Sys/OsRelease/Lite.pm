# Sys::OsRelease::Lite
# alternative Sys::OsRelease for older Perl versions
#
# Copyright (c) 2026 by Ian Kluft
# Open Source license Perl's Artistic License 2.0: <http://www.perlfoundation.org/artistic_license_2_0>
# SPDX-License-Identifier: Artistic-2.0
use v5.10;
use strict;
use warnings;
use utf8;

package Sys::OsRelease::Lite;
$Sys::OsRelease::Lite::VERSION = '%VERSION%';

1;

__END__

# POD documentation
=encoding utf8

=head1 NAME

Sys::OsRelease::Lite - repackaged distribution to provide Sys::OsRelease on Perl older than 5.22

=head1 SYNOPSIS

none

=head1 DESCRIPTION

Sys::OsRelease::Lite serves only as an installation target for an alternative way to install L<Sys::OsRelease>
on Perl versions older than 5.22.
It provides no other functionality except to make Sys::OsRelease available as part of the distribution.

This is a repackaging of Sys::OsRelease for older versions of Perl before 5.22.
This was made because dependencies of Dist::Zilla forced it to bump its minimum Perl version to 5.22,
which in turn forced Sys::OsRelease to follow.
Sys::OsRelease::Lite provides Sys::OsRelease with the same source code,
implemented as a symbolic link in the common Git repository that houses both modules.
It is packaged with L<ExtUtils::MakeMaker> to maintain availability back to Perl 5.10.
Compatibility was at time time still being maintained via CPAN testing was back to 5.10.
The use case was systems with RHEL 6 on Perl 5.10.1 and RHEL 7 on Perl 5.16,
or similar variations.

=head1 SEE ALSO

L<Sys::OsRelease>

FreeDesktop.Org's os-release standard: L<https://www.freedesktop.org/software/systemd/man/os-release.html>

GitHub repository for Sys::OsRelease: L<https://github.com/ikluft/Sys-OsRelease>

=head1 BUGS AND LIMITATIONS

Please report bugs via GitHub at L<https://github.com/ikluft/Sys-OsRelease/issues>

Patches and enhancements may be submitted via a pull request at L<https://github.com/ikluft/Sys-OsRelease/pulls>

=head1 LICENSE INFORMATION

This module is distributed in the hope that it will be useful, but it is provided “as is” and without any express or implied warranties. For details, see the full text of the license in the file LICENSE or at L<https://www.perlfoundation.org/artistic-license-20.html>.

=head1 AUTHOR

Ian Kluft <https://github.com/ikluft>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2022-2026 by Ian Kluft.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

__END__

# POD documentation
