#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;
my $page = CGI->new;
#print $page->header("text/html");
print $page->header(-charset=>'utf-8',-content_type=>'text/html');

# TODO put crendentials into an external files with prtected permission
our @DBI = ("DBI:mysql:dbname=mysql;mysql_socket=/var/run/mysqld/mysqld.sock","root","change_me");
#our @DBI = ("DBI:mysql:dbname=mysql;host=192.168.33.10","root","");

our $sql = "SELECT * FROM help_keyword LIMIT 10";

my $db = DBI->connect(@DBI);
if (!$db) {
  print $page->start_html("Error"),
    $page->h1("Can not connect to database"),
  $page->end_html;
  Carp::confess "$0: ".$DBI[0].": $DBI::errstr";
  exit 1;
}

print 
  $page->start_html(
    -title => 'help_keyword',
    -style => {'src'=>'/default.css'},
  ),
  $page->h1('Print first records of table help_keyword'),
;

my $st = $db->prepare($sql);
$st->execute() or die;


print $page->start_table()."\n";

# Header
print '<tr>',
  ( map {'<th>'.($_ eq '' ? '&nbsp' : $_).'</th>'} @{$st->{NAME_lc}} ),
"</tr>\n";

# Body
while (@_ = $st->fetchrow_array) {
  print '<tr>',
    ( map {"<td>$_</td>"} @_ ),
  "</tr>\n";
}

print $page->end_table();

# Bye !
$_ = $DBI[0]; s/^DBI:[^:]+://; s/;/ | /g;
print qq{<div class="conn">$_</div>};
print $page->end_html;
