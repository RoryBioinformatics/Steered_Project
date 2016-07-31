#!/usr/bin/perl -wT
use strict;
use CGI qw(:cgi); #use CGI
use CGI::Carp qw(fatalsToBrowser); # Send error messages to browser
use Statistics::R; #send R commands

# Take value from post method
my $input = param("gene_name");
chomp $input;

#Take track choice from post method
my $input2 = param("track");
chomp $input2;
my $track;
my $pass;
my $fail;

#check the track choice
if ($input2 =~ /Control/){
$track = "control";
}
elsif ($input2 =~ /Test/){
$track = "test";
}

# Define environment pathway
$ENV{'PATH'} = '/bin:/usr/bin';

#send commands to cummeRund in R
my $R = Statistics::R->new();
$R->startR;
$R->send('library("cummeRbund")');
$R->send('setwd("/home/ss977/public_html/rn6_cuffdiff_out")');
$R->send('cuff<-readCufflinks()');
$R->send("myGeneID<-'$input'");
$R->send('myGene<-getGene(cuff,myGeneID)');
$R->send('gene.features<-annotation(myGene)');
$R->send('gene.features');
my $ret = $R->read;
$R->stopR;
my $taken;

#Use regex to find the chromosome locus in the returned values. If not, the user is informed of such.
if ($ret =~ m/(chr[1-20XM]:\d+\W?\d+)\s+/){
$taken = $1;
$pass = "The $input gene is visualised below.";
}
else {
$fail = "The Database does not contain the $input chromosome location. It may be due to a lack of expression or misspelling ;)";
}
my $locus = "$taken";

# Generate HTML template of IGV browser.
print <<END_OF_HTML;
Content-type: text/html

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/~ss977/style1.css" />
<title>RNA-Seq Analysis of BES on Rat Livers</title>
</head>

<body>
<div id="container">
		<div id="header">
            <h1>Finge<span class="off">RNA</span>ils</h>
            <h2>Database of BES action on the expression of <i>Rattus norvegicus</i> liver genes</h2>
        </div>   
        
        <div id="menu">
        	<ul>
            	<li class="menuitem"><a href="/~ss977/index.html">Home</a></li>
                <li class="menuitem"><a href="/~ss977/about.html">About</a></li>
                <li class="menuitem"><a href="http://143.210.153.168:3838/rn6_app/">Analysis and Visualisation</a></li>
 		<li class="menuitem"><a href="/~ss977/mapping.html">Annotation Mapping</a></li>
            </ul>
        </div>
        
        <div id="leftmenu">

        <div id="leftmenu_top"></div>

				<div id="leftmenu_main">    
                
                <h3>Links</h3>
                        
                <ul>
                    <li><a href="http://www.ncbi.nlm.nih.gov/pubmed/25150839">Wang Paper</a></li>
                    <li><a href="http://cole-trapnell-lab.github.io/cufflinks/">Cufflinks</a></li>
                    <li><a href="https://ccb.jhu.edu/software/tophat/index.shtml">TopHat</a></li>
                    <li><a href="https://github.com/RoryBioinformatics/Steered_Project">GitHub Resources</a></li>
                </ul>
</div>
                
                
              <div id="leftmenu_bottom"></div>
        </div>
        
		<div id="content">
        
        
        <div id="content_top"></div>
<div id="content_main">
	<h2>Gene Mapping Search</h2>
        	<p>&nbsp;</p>
           	<p>&nbsp;</p>
		<p> The below link will open a local IGV browser session with the specified gene locus after file download.</p>
		<p> $pass $fail</p>
		<p>&nbsp</p>
	<h3> Download</h3>
		<p>&nbsp;</p>
		<p>The IGV browser download below allows for the visualisation of your chosen gene.</p>
		<li><a href="http://www.broadinstitute.org/igv/projects/current/igv.php?sessionURL=http://bioinf6.bioc.le.ac.uk/~ss977/merged_$track.bam&genome=rn6&locus=$locus">IGV Gene Visualisation</a></li>
		<p>&nbsp;</p>
		<p>If you would like to view the whole $track alignment, please download and load the following files into your IGV browser.</p>
		<li><a href="/~ss977/merged_$track.bam.bai">Index File Download</a></li>
		<li><a href="/~ss977/merged_$track.bam">Bam File Download</a></li>
</div>
        <div id="content_bottom"></div>
            
            <div id="footer"><h3><a href="http://www.bryantsmith.com">florida web design</a></h3></div>
      </div>
   </div>
</body>
</html>

END_OF_HTML

