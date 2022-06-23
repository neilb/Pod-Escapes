use strict;
use warnings;
use Test::More tests => 62;

use Pod::Escapes qw(:ALL);

eval " binmode(STDOUT, ':utf8') ";

foreach my $quotie (qw( \n \r \cm \cj \t \f \b \a \e )) {
  my $val = eval "\"$quotie\"";
  if($@) {
    ok 0;
    print "# Error in evalling quotie \"$quotie\"\n";
  } elsif(!defined $val) {
    ok 0;
    print "# \"$quotie\" is undef!?\n";
  } else {
    ok 1;
    print "# \"$quotie\" is ", ord($val), "\n";
  }
}

print "#\n#------------------------\n#\n";

print "# 'A' tests...\n";
is e2char('65'), 'A';
is e2char('x41'), 'A';
is e2char('x041'), 'A';
is e2char('x0041'), 'A';
is e2char('x00041'), 'A';
is e2char('0101'), 'A';
is e2char('00101'), 'A';
is e2char('000101'), 'A';
is e2char('0000101'), 'A';

print "# '<' tests...\n";
is e2char('lt'), '<';
is e2char('60'), '<';
is e2char('074'), '<';
is e2char('0074'), '<';
is e2char('00074'), '<';
is e2char('000074'), '<';

is e2char('x3c'), '<';
is e2char('x3C'), '<';
is e2char('x03c'), '<';
is e2char('x003c'), '<';
is e2char('x0003c'), '<';
is e2char('x00003c'), '<';
is e2char('0x3c'), '<';
is e2char('0x3C'), '<';
is e2char('0x03c'), '<';
is e2char('0x003c'), '<';
is e2char('0x0003c'), '<';
is e2char('0x00003c'), '<';

ok e2char('65') ne e2char('lt');

print "# eacute tests...\n";
ok defined e2char('eacute');

print "#    eacute is <", e2char('eacute'), "> which is code ",
      ord(e2char('eacute')), "\n";

is e2char('eacute'), e2char('233');
is e2char('eacute'), e2char('0351');
is e2char('eacute'), e2char('xe9');
is e2char('eacute'), e2char('xE9');

print "# pi tests...\n";
ok defined e2char('pi');

print "#    pi is <", e2char('pi'), "> which is code ",
      ord(e2char('pi')), "\n";

is e2char('pi'), e2char('960');
is e2char('pi'), e2char('01700');
is e2char('pi'), e2char('001700');
is e2char('pi'), e2char('0001700');
is e2char('pi'), e2char('x3c0');
is e2char('pi'), e2char('x3C0');
is e2char('pi'), e2char('x03C0');
is e2char('pi'), e2char('x003C0');
is e2char('pi'), e2char('x0003C0');


print "# various hash tests...\n";

ok scalar keys %Name2character;
ok defined $Name2character{'eacute'};
is $Name2character{'lt'}, '<';

ok scalar keys %Latin1Code_to_fallback;
ok defined $Latin1Code_to_fallback{233};

ok scalar keys %Latin1Char_to_fallback;
ok defined $Latin1Char_to_fallback{chr(233)};

ok scalar keys %Code2USASCII;
ok defined $Code2USASCII{65};
is $Code2USASCII{65}, 'A';
