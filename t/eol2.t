# t/eol2.t - check handling of \r, \n, and \r\n as line separators (again)

use strict;
use warnings;
use Test::More tests => 7;

use_ok('Pod::Simple::XHTML') or exit;

open(POD, ">$$.pod") or die "$$.pod: $!";
print POD <<__EOF__;
=pod

=head1 NAME

crlf

=head1 DESCRIPTION

crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf
crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf
crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf
crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf

    crlf crlf crlf crlf
    crlf crlf crlf crlf
    crlf crlf crlf crlf

crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf
crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf
crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf
crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf crlf

=cut
__EOF__
close(POD);

# --- CR ---

my $p1 = Pod::Simple::XHTML->new ();
isa_ok ($p1, 'Pod::Simple::XHTML');

open(POD, "<$$.pod") or die "$$.pod: $!";
my $i1 = '';
while (<POD>) {
  s/[\r\n]+/\r/g;
  $i1 .= $_;
}
close(POD);

$p1->output_string(\my $o1);
$p1->parse_string_document($i1);

# --- LF ---

my $p2 = Pod::Simple::XHTML->new ();
isa_ok ($p2, 'Pod::Simple::XHTML');

open(POD, "<$$.pod") or die "$$.pod: $!";
my $i2 = '';
while (<POD>) {
  s/[\r\n]+/\n/g;
  $i2 .= $_;
}
close(POD);

$p2->output_string(\my $o2);
$p2->parse_string_document($i2);

# --- CRLF ---

my $p3 = Pod::Simple::XHTML->new ();
isa_ok ($p3, 'Pod::Simple::XHTML');

open(POD, "<$$.pod") or die "$$.pod: $!";
my $i3 = '';
while (<POD>) {
  s/[\r\n]+/\r\n/g;
  $i3 .= $_;
}
close(POD);

$p3->output_string(\my $o3);
$p3->parse_string_document($i3);

# --- now test ---

my $cksum1 = unpack("%32C*", $o1);
my $cksum2 = unpack("%32C*", $o2);
my $cksum3 = unpack("%32C*", $o3);

ok($cksum1 == $cksum2, "CR vs LF");
ok($cksum1 == $cksum3, "CR vs CRLF");
ok($cksum2 == $cksum3, "LF vs CRLF");

END {
  1 while unlink("$$.pod", "$$.in");
}
