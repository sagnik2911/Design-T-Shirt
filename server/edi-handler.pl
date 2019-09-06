#!C:/Perl64/bin/perl.exe
use strict;
use DBD::Oracle qw(:ora_types);
use DBI;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::Simple;
use Data::Dumper;
my $c = new CGI;
print $c->header();
#print "hello";
my @q = $c->param;
#print "@q";
my $data = $c->param('POSTDATA');
my $ps = XMLin($data);
#print Dumper($ps);
my $xnm=$ps->{name};
#print "$xnm";
#print "$data";
my $dbh = DBI->connect('dbi:Oracle:host=localhost;sid=orcl1;port=1521', 'hr', 'rohit1') ||
           die( $DBI::errstr . "\n" );
		   
	$dbh->{AutoCommit}    = 0;

    $dbh->{RaiseError}    = 1;

    $dbh->{ora_check_sql} = 0;

    $dbh->{RowCacheSize}  = 16;
	$dbh->{LongReadLen} = 2*1024*1024; 
 my $SQL='insert into DESIGN values(?,?)';
 my $sth=$dbh->prepare($SQL );
  $sth->bind_param(1,$xnm);
  $sth->bind_param(2,$data,{ora_type=>SQLT_CHR});
  $sth->execute();
  
  END {
    $dbh->disconnect if defined($dbh);
}

	
