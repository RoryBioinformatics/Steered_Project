# !/usr/bin/perl 

# script to replace all uppercase with lowercase letters
# place the script in the folder containing the file/s and run it
# kenneth condon - university of leicester - Msc bioinformatics - 31/7/2016

use strict;use warnings;

#################################################################
# for single files ##############################################
#################################################################

#open (IN,"$ARGV[0]") or die("Usage: perl lowercase.pl filename.extension\n");		# user command line argument defines the input file
#open (OUT, ">$ARGV[0]_lc");								# creates output file
#	while (<IN>)									# while the file is open do the following:
#		{		
#		$_ =~ tr/[a-z]/[a-z]/;							# replaces all uppercase with lower case
#		print OUT $_;								# prints to the output file
#		rename "$ARGV[0]_lc", "$ARGV[0]";					# overwrites the input file with the output file (so no duplicate files)
#		}
#close IN; close OUT;									# closes the input and ouput files

################################################################
# for all files in a cuffdiff_out directory ####################
# WARNING: The cummeRbund database creation fails ##############
################################################################
opendir(DIR, ".");									# opens the current directory and creates a file handle
my @files = readdir(DIR);								# stores all file names contained in the directory in an array
my @sorted = sort (@files);								# sorts by alphabetical order --> putting "." and ".." first and also "uppercase_remover.pl" last in the array
shift @sorted;										# removes "." from the array
shift @sorted;										# removes ".." from the array
pop @sorted;										# removes "uppercase_remover.pl" from the array to avoid overwritting this script							
close DIR;										# closes the directory
print "@sorted\n";

foreach my $file(@sorted)								# iterates through each file in the array
	{
   	open(FH,"$file");								# creates a file handle for the file
	open(OUT, ">$file.lc");								# creates an output file and file handle
   	while(<FH>)									# while the file is open do the following:
		{ 
		$_ =~ tr/[A-Z]/[a-z]/;							# replaces all uppercase with lower case
     		print OUT $_;								# prints to the output file
		rename "$file.lc", "$file";						# overwrites the input file with the output file (so no duplicate files)
   		}
   	close(FH);									# closes the input file to return to the start of the foreach loop to handle the next file in the array.
	}

################################################################
exit;											# exits perl
