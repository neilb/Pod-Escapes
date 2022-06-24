use strict;
use warnings;
use Test::More tests => 41;
use utf8;

use Pod::Escapes qw(:ALL);

eval " binmode(STDOUT, ':utf8') ";

print "# 'A' tests...\n";
is e2charnum('65'), '65';
is e2charnum('x41'), '65';
is e2charnum('x041'), '65';
is e2charnum('x0041'), '65';
is e2charnum('x00041'), '65';
is e2charnum('0101'), '65';
is e2charnum('00101'), '65';
is e2charnum('000101'), '65';
is e2charnum('0000101'), '65';

print "# '<' tests...\n";
is e2charnum('lt'), '60';
is e2charnum('60'), '60';
is e2charnum('074'), '60';
is e2charnum('0074'), '60';
is e2charnum('00074'), '60';
is e2charnum('000074'), '60';
is e2charnum('x3c'), '60';
is e2charnum('x3C'), '60';
is e2charnum('x03c'), '60';
is e2charnum('x003c'), '60';
is e2charnum('x0003c'), '60';
is e2charnum('x00003c'), '60';

ok e2charnum('65') ne e2charnum('lt');

print "# eacute tests...\n";
ok defined e2charnum('eacute');

print "#    eacute is <", e2charnum('eacute'), "> which is code ",
      ord(e2charnum('eacute')), "\n";

is e2charnum('eacute'), e2charnum('233');
is e2charnum('eacute'), e2charnum('0351');
is e2charnum('eacute'), e2charnum('xe9');
is e2charnum('eacute'), e2charnum('xE9');

print "# pi tests...\n";
ok defined e2charnum('pi');

print "#    pi is <", e2charnum('pi'), "> which is code ",
      e2charnum('pi'), "\n";

is e2charnum('pi'), e2charnum('960');
is e2charnum('pi'), e2charnum('01700');
is e2charnum('pi'), e2charnum('001700');
is e2charnum('pi'), e2charnum('0001700');
is e2charnum('pi'), e2charnum('x3c0');
is e2charnum('pi'), e2charnum('x3C0');
is e2charnum('pi'), e2charnum('x03C0');
is e2charnum('pi'), e2charnum('x003C0');
is e2charnum('pi'), e2charnum('x0003C0');


print "# %Name2character_number test...\n";

ok scalar keys %Name2character_number;
ok defined $Name2character_number{'eacute'};
is $Name2character_number{'lt'}, '60';

# e2charnum on BENGALI DIGIT SEVEN should return undef
ok(!defined(e2charnum('৭')));
