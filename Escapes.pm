
require 5;
#                        The documentation is at the end.
# Time-stamp: "2001-10-24 23:20:49 MDT"
package Pod::Escapes;
require Exporter;
@ISA = ('Exporter');
$VERSION = '1.01';
@EXPORT_OK = qw(
  %Code2USASCII
  %Name2character
  %Latin1Code_to_fallback
  %Latin1Char_to_fallback
  e2char
);
%EXPORT_TAGS = ('ALL' => \@EXPORT_OK);

#==========================================================================

use strict;
use vars qw(
  %Code2USASCII
  %Name2character
  %Latin1Code_to_fallback
  %Latin1Char_to_fallback
  $FAR_CHAR
  $NOT_ASCII
);

$FAR_CHAR = "?" unless defined $FAR_CHAR;
$NOT_ASCII = 'A' ne chr(65) unless defined $NOT_ASCII;

#--------------------------------------------------------------------------
sub e2char {
  my $in = $_[0];
  return undef unless defined $in and length $in;
  
  # Convert to decimal:
  if($in =~ m/^(0[0-7]*)$/s ) {
    $in = oct $in;
  } elsif($in =~ m/^x([0-9a-fA-F]+)$/s ) {
    $in = hex $1;
  } # else it's decimal, or named

  if($NOT_ASCII) {
    # We're in bizarro world of not-ASCII!
    # Cope with US-ASCII codes, use fallbacks for Latin-1, or use FAR_CHAR.
    unless($in =~ m/^\d+$/s) {
      # It's a named character reference.  Get its numeric Unicode value.
      $in = $Name2character{$in};
      return undef unless defined $in;  # (if there's no such name)
      $in = ord $in; # (All ents must be one character long.)
        # ...So $in holds the char's US-ASCII numeric value, which we'll
        #  now go get the local equivalent for.
    }

    # It's numeric, whether by origin or by mutation from a known name
    return $Code2USASCII{$in} # so "65" => "A" everywhere
        || $Latin1Code_to_fallback{$in} # Fallback.
        || $FAR_CHAR; # Fall further back
  }
  
  # Normal handling:
  if($in =~ m/^\d+$/s) {
    if($in > 255 and $] < 5.007) { # can't be trusted with Unicode
      return $FAR_CHAR;
    } else {
      return chr($in);
    }
  } else {
    return $Name2character{$in}; # returns undef if unknown
  }
}

#--------------------------------------------------------------------------

%Name2character = (
 # General XML/XHTML:
 'lt'   => '<',
 'gt'   => '>',
 'quot' => '"',
 'amp'  => '&',
 'apos' => "'",

 # POD-specific:
 'sol'    => '/',
 'verbar' => '|',
 'lchevron' => chr(171), # legacy for laquo
 'rchevron' => chr(187), # legacy for raquo

 # Remember, grave looks like \ (as in virtu\)
 #           acute looks like / (as in re/sume/)
 #           circumflex looks like ^ (as in papier ma^che/)
 #           umlaut/dieresis looks like " (as in nai"ve, Chloe")

 # From the XHTML 1 .ent files:
 'nbsp'     , chr(160),
 'iexcl'    , chr(161),
 'cent'     , chr(162),
 'pound'    , chr(163),
 'curren'   , chr(164),
 'yen'      , chr(165),
 'brvbar'   , chr(166),
 'sect'     , chr(167),
 'uml'      , chr(168),
 'copy'     , chr(169),
 'ordf'     , chr(170),
 'laquo'    , chr(171),
 'not'      , chr(172),
 'shy'      , chr(173),
 'reg'      , chr(174),
 'macr'     , chr(175),
 'deg'      , chr(176),
 'plusmn'   , chr(177),
 'sup2'     , chr(178),
 'sup3'     , chr(179),
 'acute'    , chr(180),
 'micro'    , chr(181),
 'para'     , chr(182),
 'middot'   , chr(183),
 'cedil'    , chr(184),
 'sup1'     , chr(185),
 'ordm'     , chr(186),
 'raquo'    , chr(187),
 'frac14'   , chr(188),
 'frac12'   , chr(189),
 'frac34'   , chr(190),
 'iquest'   , chr(191),
 'Agrave'   , chr(192),
 'Aacute'   , chr(193),
 'Acirc'    , chr(194),
 'Atilde'   , chr(195),
 'Auml'     , chr(196),
 'Aring'    , chr(197),
 'AElig'    , chr(198),
 'Ccedil'   , chr(199),
 'Egrave'   , chr(200),
 'Eacute'   , chr(201),
 'Ecirc'    , chr(202),
 'Euml'     , chr(203),
 'Igrave'   , chr(204),
 'Iacute'   , chr(205),
 'Icirc'    , chr(206),
 'Iuml'     , chr(207),
 'ETH'      , chr(208),
 'Ntilde'   , chr(209),
 'Ograve'   , chr(210),
 'Oacute'   , chr(211),
 'Ocirc'    , chr(212),
 'Otilde'   , chr(213),
 'Ouml'     , chr(214),
 'times'    , chr(215),
 'Oslash'   , chr(216),
 'Ugrave'   , chr(217),
 'Uacute'   , chr(218),
 'Ucirc'    , chr(219),
 'Uuml'     , chr(220),
 'Yacute'   , chr(221),
 'THORN'    , chr(222),
 'szlig'    , chr(223),
 'agrave'   , chr(224),
 'aacute'   , chr(225),
 'acirc'    , chr(226),
 'atilde'   , chr(227),
 'auml'     , chr(228),
 'aring'    , chr(229),
 'aelig'    , chr(230),
 'ccedil'   , chr(231),
 'egrave'   , chr(232),
 'eacute'   , chr(233),
 'ecirc'    , chr(234),
 'euml'     , chr(235),
 'igrave'   , chr(236),
 'iacute'   , chr(237),
 'icirc'    , chr(238),
 'iuml'     , chr(239),
 'eth'      , chr(240),
 'ntilde'   , chr(241),
 'ograve'   , chr(242),
 'oacute'   , chr(243),
 'ocirc'    , chr(244),
 'otilde'   , chr(245),
 'ouml'     , chr(246),
 'divide'   , chr(247),
 'oslash'   , chr(248),
 'ugrave'   , chr(249),
 'uacute'   , chr(250),
 'ucirc'    , chr(251),
 'uuml'     , chr(252),
 'yacute'   , chr(253),
 'thorn'    , chr(254),
 'yuml'     , chr(255),

 ($] >= 5.007) ? (
   'fnof'     , chr(402),
   'Alpha'    , chr(913),
   'Beta'     , chr(914),
   'Gamma'    , chr(915),
   'Delta'    , chr(916),
   'Epsilon'  , chr(917),
   'Zeta'     , chr(918),
   'Eta'      , chr(919),
   'Theta'    , chr(920),
   'Iota'     , chr(921),
   'Kappa'    , chr(922),
   'Lambda'   , chr(923),
   'Mu'       , chr(924),
   'Nu'       , chr(925),
   'Xi'       , chr(926),
   'Omicron'  , chr(927),
   'Pi'       , chr(928),
   'Rho'      , chr(929),
   'Sigma'    , chr(931),
   'Tau'      , chr(932),
   'Upsilon'  , chr(933),
   'Phi'      , chr(934),
   'Chi'      , chr(935),
   'Psi'      , chr(936),
   'Omega'    , chr(937),
   'alpha'    , chr(945),
   'beta'     , chr(946),
   'gamma'    , chr(947),
   'delta'    , chr(948),
   'epsilon'  , chr(949),
   'zeta'     , chr(950),
   'eta'      , chr(951),
   'theta'    , chr(952),
   'iota'     , chr(953),
   'kappa'    , chr(954),
   'lambda'   , chr(955),
   'mu'       , chr(956),
   'nu'       , chr(957),
   'xi'       , chr(958),
   'omicron'  , chr(959),
   'pi'       , chr(960),
   'rho'      , chr(961),
   'sigmaf'   , chr(962),
   'sigma'    , chr(963),
   'tau'      , chr(964),
   'upsilon'  , chr(965),
   'phi'      , chr(966),
   'chi'      , chr(967),
   'psi'      , chr(968),
   'omega'    , chr(969),
   'thetasym' , chr(977),
   'upsih'    , chr(978),
   'piv'      , chr(982),
   'bull'     , chr(8226),
   'hellip'   , chr(8230),
   'prime'    , chr(8242),
   'Prime'    , chr(8243),
   'oline'    , chr(8254),
   'frasl'    , chr(8260),
   'weierp'   , chr(8472),
   'image'    , chr(8465),
   'real'     , chr(8476),
   'trade'    , chr(8482),
   'alefsym'  , chr(8501),
   'larr'     , chr(8592),
   'uarr'     , chr(8593),
   'rarr'     , chr(8594),
   'darr'     , chr(8595),
   'harr'     , chr(8596),
   'crarr'    , chr(8629),
   'lArr'     , chr(8656),
   'uArr'     , chr(8657),
   'rArr'     , chr(8658),
   'dArr'     , chr(8659),
   'hArr'     , chr(8660),
   'forall'   , chr(8704),
   'part'     , chr(8706),
   'exist'    , chr(8707),
   'empty'    , chr(8709),
   'nabla'    , chr(8711),
   'isin'     , chr(8712),
   'notin'    , chr(8713),
   'ni'       , chr(8715),
   'prod'     , chr(8719),
   'sum'      , chr(8721),
   'minus'    , chr(8722),
   'lowast'   , chr(8727),
   'radic'    , chr(8730),
   'prop'     , chr(8733),
   'infin'    , chr(8734),
   'ang'      , chr(8736),
   'and'      , chr(8743),
   'or'       , chr(8744),
   'cap'      , chr(8745),
   'cup'      , chr(8746),
   'int'      , chr(8747),
   'there4'   , chr(8756),
   'sim'      , chr(8764),
   'cong'     , chr(8773),
   'asymp'    , chr(8776),
   'ne'       , chr(8800),
   'equiv'    , chr(8801),
   'le'       , chr(8804),
   'ge'       , chr(8805),
   'sub'      , chr(8834),
   'sup'      , chr(8835),
   'nsub'     , chr(8836),
   'sube'     , chr(8838),
   'supe'     , chr(8839),
   'oplus'    , chr(8853),
   'otimes'   , chr(8855),
   'perp'     , chr(8869),
   'sdot'     , chr(8901),
   'lceil'    , chr(8968),
   'rceil'    , chr(8969),
   'lfloor'   , chr(8970),
   'rfloor'   , chr(8971),
   'lang'     , chr(9001),
   'rang'     , chr(9002),
   'loz'      , chr(9674),
   'spades'   , chr(9824),
   'clubs'    , chr(9827),
   'hearts'   , chr(9829),
   'diams'    , chr(9830),
   'OElig'    , chr(338),
   'oelig'    , chr(339),
   'Scaron'   , chr(352),
   'scaron'   , chr(353),
   'Yuml'     , chr(376),
   'circ'     , chr(710),
   'tilde'    , chr(732),
   'ensp'     , chr(8194),
   'emsp'     , chr(8195),
   'thinsp'   , chr(8201),
   'zwnj'     , chr(8204),
   'zwj'      , chr(8205),
   'lrm'      , chr(8206),
   'rlm'      , chr(8207),
   'ndash'    , chr(8211),
   'mdash'    , chr(8212),
   'lsquo'    , chr(8216),
   'rsquo'    , chr(8217),
   'sbquo'    , chr(8218),
   'ldquo'    , chr(8220),
   'rdquo'    , chr(8221),
   'bdquo'    , chr(8222),
   'dagger'   , chr(8224),
   'Dagger'   , chr(8225),
   'permil'   , chr(8240),
   'lsaquo'   , chr(8249),
   'rsaquo'   , chr(8250),
   'euro'     , chr(8364),
 ) : (
   # for people who don't have Unicode support 
   'fnof'     , $FAR_CHAR,
   'Alpha'    , $FAR_CHAR,
   'Beta'     , $FAR_CHAR,
   'Gamma'    , $FAR_CHAR,
   'Delta'    , $FAR_CHAR,
   'Epsilon'  , $FAR_CHAR,
   'Zeta'     , $FAR_CHAR,
   'Eta'      , $FAR_CHAR,
   'Theta'    , $FAR_CHAR,
   'Iota'     , $FAR_CHAR,
   'Kappa'    , $FAR_CHAR,
   'Lambda'   , $FAR_CHAR,
   'Mu'       , $FAR_CHAR,
   'Nu'       , $FAR_CHAR,
   'Xi'       , $FAR_CHAR,
   'Omicron'  , $FAR_CHAR,
   'Pi'       , $FAR_CHAR,
   'Rho'      , $FAR_CHAR,
   'Sigma'    , $FAR_CHAR,
   'Tau'      , $FAR_CHAR,
   'Upsilon'  , $FAR_CHAR,
   'Phi'      , $FAR_CHAR,
   'Chi'      , $FAR_CHAR,
   'Psi'      , $FAR_CHAR,
   'Omega'    , $FAR_CHAR,
   'alpha'    , $FAR_CHAR,
   'beta'     , $FAR_CHAR,
   'gamma'    , $FAR_CHAR,
   'delta'    , $FAR_CHAR,
   'epsilon'  , $FAR_CHAR,
   'zeta'     , $FAR_CHAR,
   'eta'      , $FAR_CHAR,
   'theta'    , $FAR_CHAR,
   'iota'     , $FAR_CHAR,
   'kappa'    , $FAR_CHAR,
   'lambda'   , $FAR_CHAR,
   'mu'       , $FAR_CHAR,
   'nu'       , $FAR_CHAR,
   'xi'       , $FAR_CHAR,
   'omicron'  , $FAR_CHAR,
   'pi'       , $FAR_CHAR,
   'rho'      , $FAR_CHAR,
   'sigmaf'   , $FAR_CHAR,
   'sigma'    , $FAR_CHAR,
   'tau'      , $FAR_CHAR,
   'upsilon'  , $FAR_CHAR,
   'phi'      , $FAR_CHAR,
   'chi'      , $FAR_CHAR,
   'psi'      , $FAR_CHAR,
   'omega'    , $FAR_CHAR,
   'thetasym' , $FAR_CHAR,
   'upsih'    , $FAR_CHAR,
   'piv'      , $FAR_CHAR,
   'bull'     , $FAR_CHAR,
   'hellip'   , $FAR_CHAR,
   'prime'    , $FAR_CHAR,
   'Prime'    , $FAR_CHAR,
   'oline'    , $FAR_CHAR,
   'frasl'    , $FAR_CHAR,
   'weierp'   , $FAR_CHAR,
   'image'    , $FAR_CHAR,
   'real'     , $FAR_CHAR,
   'trade'    , $FAR_CHAR,
   'alefsym'  , $FAR_CHAR,
   'larr'     , $FAR_CHAR,
   'uarr'     , $FAR_CHAR,
   'rarr'     , $FAR_CHAR,
   'darr'     , $FAR_CHAR,
   'harr'     , $FAR_CHAR,
   'crarr'    , $FAR_CHAR,
   'lArr'     , $FAR_CHAR,
   'uArr'     , $FAR_CHAR,
   'rArr'     , $FAR_CHAR,
   'dArr'     , $FAR_CHAR,
   'hArr'     , $FAR_CHAR,
   'forall'   , $FAR_CHAR,
   'part'     , $FAR_CHAR,
   'exist'    , $FAR_CHAR,
   'empty'    , $FAR_CHAR,
   'nabla'    , $FAR_CHAR,
   'isin'     , $FAR_CHAR,
   'notin'    , $FAR_CHAR,
   'ni'       , $FAR_CHAR,
   'prod'     , $FAR_CHAR,
   'sum'      , $FAR_CHAR,
   'minus'    , $FAR_CHAR,
   'lowast'   , $FAR_CHAR,
   'radic'    , $FAR_CHAR,
   'prop'     , $FAR_CHAR,
   'infin'    , $FAR_CHAR,
   'ang'      , $FAR_CHAR,
   'and'      , $FAR_CHAR,
   'or'       , $FAR_CHAR,
   'cap'      , $FAR_CHAR,
   'cup'      , $FAR_CHAR,
   'int'      , $FAR_CHAR,
   'there4'   , $FAR_CHAR,
   'sim'      , $FAR_CHAR,
   'cong'     , $FAR_CHAR,
   'asymp'    , $FAR_CHAR,
   'ne'       , $FAR_CHAR,
   'equiv'    , $FAR_CHAR,
   'le'       , $FAR_CHAR,
   'ge'       , $FAR_CHAR,
   'sub'      , $FAR_CHAR,
   'sup'      , $FAR_CHAR,
   'nsub'     , $FAR_CHAR,
   'sube'     , $FAR_CHAR,
   'supe'     , $FAR_CHAR,
   'oplus'    , $FAR_CHAR,
   'otimes'   , $FAR_CHAR,
   'perp'     , $FAR_CHAR,
   'sdot'     , $FAR_CHAR,
   'lceil'    , $FAR_CHAR,
   'rceil'    , $FAR_CHAR,
   'lfloor'   , $FAR_CHAR,
   'rfloor'   , $FAR_CHAR,
   'lang'     , $FAR_CHAR,
   'rang'     , $FAR_CHAR,
   'loz'      , $FAR_CHAR,
   'spades'   , $FAR_CHAR,
   'clubs'    , $FAR_CHAR,
   'hearts'   , $FAR_CHAR,
   'diams'    , $FAR_CHAR,
   'OElig'    , $FAR_CHAR,
   'oelig'    , $FAR_CHAR,
   'Scaron'   , $FAR_CHAR,
   'scaron'   , $FAR_CHAR,
   'Yuml'     , $FAR_CHAR,
   'circ'     , $FAR_CHAR,
   'tilde'    , $FAR_CHAR,
   'ensp'     , $FAR_CHAR,
   'emsp'     , $FAR_CHAR,
   'thinsp'   , $FAR_CHAR,
   'zwnj'     , $FAR_CHAR,
   'zwj'      , $FAR_CHAR,
   'lrm'      , $FAR_CHAR,
   'rlm'      , $FAR_CHAR,
   'ndash'    , $FAR_CHAR,
   'mdash'    , $FAR_CHAR,
   'lsquo'    , $FAR_CHAR,
   'rsquo'    , $FAR_CHAR,
   'sbquo'    , $FAR_CHAR,
   'ldquo'    , $FAR_CHAR,
   'rdquo'    , $FAR_CHAR,
   'bdquo'    , $FAR_CHAR,
   'dagger'   , $FAR_CHAR,
   'Dagger'   , $FAR_CHAR,
   'permil'   , $FAR_CHAR,
   'lsaquo'   , $FAR_CHAR,
   'rsaquo'   , $FAR_CHAR,
   'euro'     , $FAR_CHAR,
 )
);

#--------------------------------------------------------------------------

%Code2USASCII = (
# mostly generated by
#  perl -e "printf qq{  \x25 3s, '\x25s',\n}, $_, chr($_) foreach (32 .. 126)"
   32, ' ',
   33, '!',
   34, '"',
   35, '#',
   36, '$',
   37, '%',
   38, '&',
   39, "'", #!
   40, '(',
   41, ')',
   42, '*',
   43, '+',
   44, ',',
   45, '-',
   46, '.',
   47, '/',
   48, '0',
   49, '1',
   50, '2',
   51, '3',
   52, '4',
   53, '5',
   54, '6',
   55, '7',
   56, '8',
   57, '9',
   58, ':',
   59, ';',
   60, '<',
   61, '=',
   62, '>',
   63, '?',
   64, '@',
   65, 'A',
   66, 'B',
   67, 'C',
   68, 'D',
   69, 'E',
   70, 'F',
   71, 'G',
   72, 'H',
   73, 'I',
   74, 'J',
   75, 'K',
   76, 'L',
   77, 'M',
   78, 'N',
   79, 'O',
   80, 'P',
   81, 'Q',
   82, 'R',
   83, 'S',
   84, 'T',
   85, 'U',
   86, 'V',
   87, 'W',
   88, 'X',
   89, 'Y',
   90, 'Z',
   91, '[',
   92, "\\", #!
   93, ']',
   94, '^',
   95, '_',
   96, '`',
   97, 'a',
   98, 'b',
   99, 'c',
  100, 'd',
  101, 'e',
  102, 'f',
  103, 'g',
  104, 'h',
  105, 'i',
  106, 'j',
  107, 'k',
  108, 'l',
  109, 'm',
  110, 'n',
  111, 'o',
  112, 'p',
  113, 'q',
  114, 'r',
  115, 's',
  116, 't',
  117, 'u',
  118, 'v',
  119, 'w',
  120, 'x',
  121, 'y',
  122, 'z',
  123, '{',
  124, '|',
  125, '}',
  126, '~',
);

#--------------------------------------------------------------------------

%Latin1Code_to_fallback = ();
@Latin1Code_to_fallback{0xA0 .. 0xFF} = (
# Copied from Text/Unidecode/x00.pm:

' ', qq{!}, qq{C/}, 'PS', qq{\$?}, qq{Y=}, qq{|}, 'SS', qq{"}, qq{(c)}, 'a', qq{<<}, qq{!}, "", qq{(r)}, qq{-},
'deg', qq{+-}, '2', '3', qq{'}, 'u', 'P', qq{*}, qq{,}, '1', 'o', qq{>>}, qq{1/4}, qq{1/2}, qq{3/4}, qq{?},
'A', 'A', 'A', 'A', 'A', 'A', 'AE', 'C', 'E', 'E', 'E', 'E', 'I', 'I', 'I', 'I',
'D', 'N', 'O', 'O', 'O', 'O', 'O', 'x', 'O', 'U', 'U', 'U', 'U', 'U', 'Th', 'ss',
'a', 'a', 'a', 'a', 'a', 'a', 'ae', 'c', 'e', 'e', 'e', 'e', 'i', 'i', 'i', 'i',
'd', 'n', 'o', 'o', 'o', 'o', 'o', qq{/}, 'o', 'u', 'u', 'u', 'u', 'y', 'th', 'y',

);

{
  # Now stuff %Latin1Char_to_fallback:
  %Latin1Char_to_fallback = ();
  my($k,$v);
  while( ($k,$v) = each %Latin1Code_to_fallback) {
    $Latin1Char_to_fallback{chr $k} = $v;
    #print chr($k), ' => ', $v, "\n";
  }
}

#--------------------------------------------------------------------------
1;
__END__

=head1 NAME

Pod::Escapes -- for resolving Pod EE<lt>...E<gt> sequences

=head1 SYNOPSIS

  use Pod::Escapes qw(e2char);
  ...la la la, parsing POD, la la la...
  $text = e2char($e_node->label);
  unless(defined $text) {
    print "Unknown E sequence \"", $e_node->label, "\"!";
  }
  ...else print/interpolate $text...

=head1 DESCRIPTION

This module provides things that are useful in decoding
Pod EE<lt>...E<gt> sequences.  Presumably, it should be used
only by Pod parsers and/or formatters.

By default, Pod::Escapes exports none of its symbols.  But
you can request any of them to be exported.
Either request them individually, as with
C<use Pod::Escapes qw(symbolname symbolname2...);>,
or you can do C<use Pod::Escapes qw(:ALL);> to get all
exportable symbols.

=head1 GOODIES

=over

=item e2char($e_content)

Given a name or number that could appear in a
C<EE<lt>name_or_numE<gt>> sequence, this returns the string that
it stands for.  For example, C<e2char('sol')>, C<e2char('47')>,
C<e2char('x2F')>, and C<e2char('057')> all return "/",
because C<EE<lt>solE<gt>>, C<EE<lt>47E<gt>>, C<EE<lt>x2fE<gt>>,
and C<EE<lt>057E<gt>>, all mean "/".  If
the name has no known value (as with a name of "qacute") or is
syntactally invalid (as with a name of "1/4"), this returns undef.

=item $Name2character{I<name>}

Maps from names (as in C<EE<lt>I<name>E<gt>>) like "eacute" or "sol"
to the string that each stands for.  Note that this does not
include numerics (like "64" or "x981c").

=item $Latin1Code_to_fallback{I<integer>}

For numbers in the range 160 (0x00A0) to 255 (0x00FF), this maps
from the character code for a Latin-1 character (like 233 for
lowercase e-acute) to the US-ASCII character that best aproximates
it (like "e").  You may find this useful if you are rendering
POD in a format that you think deals well only with US-ASCII
characters.

=item $Latin1Char_to_fallback{I<character>}

Just as above, but maps from characters (like "\xE9", 
lowercase e-acute) to characters (like "e").

=item $Code2USASCII{I<integer>}

This maps from US-ASCII codes (like 32) to the corresponding
character (like space, for 32).  Only characters 32 to 126 are
defined.  This is meant for use by C<e2char($x)> when it senses
that it's running on a non-ASCII platform (where chr(32) doesn't
get you a space -- but $Code2USASCII{32} will).  It's
documented here just in case you might find it useful.

=back

=head1 CAVEATS

On Perl versions before 5.7, Unicode characters with a value
over 255 (like lambda or emdash) can't be conveyed.  This
module does work under such early Perl versions, but in the
place of each such character, you get a "?".  Latin-1
characters (characters 160-255) are unaffected.

=head1 SEE ALSO

L<perlpod|perlpod>

L<perlpodspec|perlpodspec>

L<Text::Unidecode|Text::Unidecode>

=head1 COPYRIGHT AND DISCLAIMERS

Copyright (c) 2001 Sean M. Burke.  All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

Portions of the data tables in this module are derived from the
entity declarations in the W3C XHTML specification.

Currently (October 2001), that's these three:

 http://www.w3.org/TR/xhtml1/DTD/xhtml-lat1.ent
 http://www.w3.org/TR/xhtml1/DTD/xhtml-special.ent
 http://www.w3.org/TR/xhtml1/DTD/xhtml-symbol.ent

=head1 AUTHOR

Sean M. Burke C<sburke@cpan.org>

=cut

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# What I used for reading the XHTML .ent files:

use strict;
my(@norms, @good, @bad);
my $dir = 'c:/sgml/docbook/';
my %escapes;
foreach my $file (qw(
  xhtml-symbol.ent
  xhtml-lat1.ent
  xhtml-special.ent
)) {
  open(IN, "<$dir$file") or die "can't read-open $dir$file: $!";
  print "Reading $file...\n";
  while(<IN>) {
    if(m/<!ENTITY\s+(\S+)\s+"&#([^;]+);">/) {
      my($name, $value) = ($1,$2);
      next if $name eq 'quot' or $name eq 'apos' or $name eq 'gt';
    
      $value = hex $1 if $value =~ m/^x([a-fA-F0-9]+)$/s;
      print "ILLEGAL VALUE $value" unless $value =~ m/^\d+$/s;
      if($value > 255) {
        push @good , sprintf "   %-10s , chr(%s),\n", "'$name'", $value;
        push @bad  , sprintf "   %-10s , \$bad,\n", "'$name'", $value;
      } else {
        push @norms, sprintf " %-10s , chr(%s),\n", "'$name'", $value;
      }
    } elsif(m/<!ENT/) {
      print "# Skipping $_";
    }
  
  }
  close(IN);
}

print @norms;
print "\n ( \$] .= 5.006001 ? (\n";
print @good;
print " ) : (\n";
print @bad;
print " )\n);\n";

__END__
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


