#!C:/Perl64/bin/perl.exe
use strict;
use DBD::Oracle qw(:ora_types);
use DBI;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
my $c = new CGI;
		#print $c->header();
		my $name = $c->param('name');
my $dbh = DBI->connect('dbi:Oracle:host=localhost;sid=orcl1;port=1521', 'hr', 'rohit1') ||
           die( $DBI::errstr . "\n" );
		   
	$dbh->{AutoCommit}    = 0;

    $dbh->{RaiseError}    = 1;

    $dbh->{ora_check_sql} = 0;

    $dbh->{RowCacheSize}  = 16;
	$dbh->{LongReadLen} = 2*1024*1024; #2 meg
	my $SEL='select designxml from design where name = ?';
  my $sth=$dbh->prepare($SEL,{ora_pers_lob=>1});
  $sth->bind_param(1,$name);
  $sth->execute();
 my $clob1=$sth->fetchrow();
  END {
    $dbh->disconnect if defined($dbh);
}
if($clob1 eq "")
{
   print "Content-type: text/html \n\n";
   print "<html><head><title>Sample Program </title></head>";
   print "<body><h1>No data found</h1></body></html>";
}
else
{

 print "Content-type: text/html \n\n";
 print <<PAGE
<html>
<head>
<title> View Page </title>
<script>
function showme(){
var str = '$clob1';
var pos=str.indexOf("<Sponsor>") + 9;
var pos1=str.indexOf("</Sponsor>");
var spo="http://localhost/Project(4.0)/"+str.slice(pos,pos1)+".jpg";
document.getElementById("sponsorimg").src = spo;
pos=str.indexOf("<Logo>") + 6;
pos1=str.indexOf("</Logo>");
var logo = "http://localhost/Project(4.0)/"+str.slice(pos,pos1) + ".png";
document.getElementById("logoimg").src = logo;
pos=str.indexOf("<name>") + 6;
pos1=str.indexOf("</name>");
var name=str.slice(pos,pos1);
document.getElementById("Name").innerHTML=name;
} 
</script>
</head>
<body onload="showme();">
<div>
<b> Name : </b> <span id="Name"></span><br>
</div>
<div style="position: relative; left: 0; top: 0;">
	<img src="http://localhost/Project(4.0)/Front.jpg" style="position: relative; top: 0; left:0;"/>
	<img  id="logoimg" style="position: absolute; top: 95px; left: 90px;" height="48" width="40"/>
	<img  id="sponsorimg" style="position: absolute; top: 200px; left: 110px;" height="55" width="100"/>
</div>	
</body>
</html>
PAGE
}