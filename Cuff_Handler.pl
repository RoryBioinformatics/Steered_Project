# Handles Cufflinks analysis outputs in form of .bam and .ctf files (?) and passes information on individual genes to a MySQL Database
 #!/usr/bin/perl

use DBI;
use strict;
use warnings;

# Database connection
$dsn = "DBI:mysql:database=$database;host=$host;port=$port";

print "Enter MySQL Username.";
$user = <STDIN>;
chomp $user

print "Enter MySQL Password";
$password = <STDIN>;
chomp $password


$dbh = DBI->connect($dsn, $user, $password {RaiseError => 1})or die $DBI::errstr;




# Database Disconnection.
$dbh->disconnect();
