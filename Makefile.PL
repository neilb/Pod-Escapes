# This -*- perl -*- script writes the Makefile for Class::BlackHole
# Time-stamp: "2001-10-24 23:22:25 MDT"
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
require 5.004;
use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	=> 'Pod::Escapes',
    'VERSION_FROM' => 'Escapes.pm', # finds $VERSION
    'dist'        => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);

package MY;

sub libscan
{ # Determine things that should *not* be installed
    my($self, $path) = @_;
    return '' if $path =~ m/~/;
    $path;
}

__END__
