#!/usr/bin/perl
use strict;
use DBI;
use CGI;
my $page = CGI->new;

# TODO put crendentials into an external files with prtected permission
our @DBI = ("DBI:mysql:dbname=mysql;mysql_socket=/var/run/mysqld/mysqld.sock","root","");
our $sql = "SELECT * FROM help_category LIMIT 10";

my $db = DBI->connect(@DBI);
if (!$db) {
  print $page->header("text/plain"),
    $page->start_html("Error"),
    $page->h1("Can not connect to database"),
    $page->end_html
  ;
  Carp::confess "$0: ".$DBI[0].": $DBI::errstr";
  exit 1;
}

print $page->header("text/html"),
  $page->start_html($DBI[0]),
  $page->h1($DBI[0]),
;

print 
  $page->start_html("help_category"),
  $page->h1("Print first records of table help_category"),
;

my $st = $db->prepare($sql);
$st->execute() or die;


print $page->start_table()."\n";
print '<tr>',
  map {"<th>$_</th>"} @{$st->{NAME_lc}},
"</tr>\n";

while ($_ = $st->fetchrow_array) {
  print '<tr>',
    map {"<td>$_</td>"} @$_,
  "</tr>\n";
}

print $page->end_table()."\n";
print $page->end_html;
