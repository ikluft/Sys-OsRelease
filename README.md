# Sys-OsRelease
[![Perl](https://github.com/ikluft/Sys-OsRelease/actions/workflows/test-main.yml/badge.svg)](https://github.com/ikluft/Sys-OsRelease/actions/workflows/test-main.yml)
[![Perl](https://github.com/ikluft/Sys-OsRelease/actions/workflows/test-lite.yml/badge.svg)](https://github.com/ikluft/Sys-OsRelease/actions/workflows/test-lite.yml)

This is a Perl library for reading OS info from FreeDesktop.Org-standard /etc/os-release files
which describe the environment of a Linux or other Unix systems.

This is the source code repository. See also the distribution on CPAN. Each link contains module documentation.

* Sys::OsRelease - [source code](main), [CPAN distribution](https://metacpan.org/pod/Sys::OsRelease)
* Sys::OsRelease::Lite - [source code](lite), [CPAN distribution](https://metacpan.org/pod/Sys::OsRelease::Lite)

## Sys::OsRelease::Lite alternative for Perl versions older than 5.22

In Spring 2026, dependencies of Dist::Zilla forced it to increase its minimum Perl version to 5.22.
Sys::OsRelease had previously maintained compatibility back to 5.10 through CPAN testing.
When a user expressed interest in maintaining at least 5.16 compatibility, an alternative
repackaging called Sys::OsRelease::Lite was made.
It provides essentially the same module source code as Sys::OsRelease
with the module name filtered to Sys::OsRelease::Lite.
Using a lighter build process, it's packaged with ExtUtils::MakeMaker to preserve compatibility back to 5.10.

In summary, Sys::OsRelease remains the primary distribution.
For users whose system has Perl older than 5.22, install Sys::OsRelease::Lite.

# Presentations

November 3, 2022 at Silicon Valley Perl: [slides](https://github.com/ikluft/Sys-OsPackage/blob/main/doc/pres-2022-11-sys-ospackage.pdf) (PDF)

<a href="https://github.com/ikluft/Sys-OsPackage/blob/main/doc/pres-2022-11-sys-ospackage.pdf"><img src="https://github.com/ikluft/Sys-OsPackage/raw/main/doc/slide1-screenshot-scaled.png"/></a>
