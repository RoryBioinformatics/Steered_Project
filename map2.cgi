#!/usr/bin/perl -wT
use strict;
use CGI qw(:cgi); #use CGI
use CGI::Carp qw(fatalsToBrowser); # Send error messages to browser
use Statistics::R;

# Take value from post method
my $input = param("gene_name");
chomp $input;

# Define environment pathway
$ENV{'PATH'} = '/bin:/usr/bin';

my $R = Statistics::R->new();
$R->startR;
$R->send('library("cummeRbund")');
$R->send('setwd("/home/rc283/Documents/BS_Group_Project/rn6_cuffdiff_out")');
$R->send('cuff<-readCufflinks()');
$R->send("myGeneID<-'$input'");
$R->send('myGene<-getGene(cuff,myGeneID)');
$R->send('gene.features<-annotation(myGene)');
$R->send('gene.features');
my $ret = $R->read;
$R->stopR;
my $taken;
if ($ret =~ m/(chr[1-20XM]:\d+\W?\d+)\s+/){
$taken = $1;
}
# http://www.broadinstitute.org/igv/projects/current/igv.php?sessionURL=localhost/C1_SRR1178016.bam&sessionURL=localhost/C1_SRR1178016.bam.bai&genome=rn6&locus=$locus
my $locus = "$taken";
# Generate HTML template of IGV browser.
print <<END_OF_HTML;
Content-type: text/html

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/style1.css" />
<title>RNA-Seq Analysis of BES on Rat Livers</title>
</head>

<body>
<div id="container">
		<div id="header">
            <h1>Beta-<span class="off">EstradiolDB</span></h>
            <h2>Database of BES action on the expression of <i>Rattus norvegicus</i> liver genes</h2>
        </div>   
        
        <div id="menu">
        	<ul>
            	<li class="menuitem"><a href="/index.html">Home</a></li>
                <li class="menuitem"><a href="/about.html">About</a></li>
                <li class="menuitem"><a href="/gene_search.html">Gene Search</a></li>
                <li class="menuitem"><a href="/gene_list.html">Gene List</a></li>
 		<li class="menuitem"><a href="#">Contact Us!</a></li>
 		<li class="menuitem"><a href="/mapping.html">Annotation Mapping</a></li>
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
		<p>&nbsp</p>
		<p> The Trip13 output is visualised below. </p>
	<h3> Download</h3>
		<li><a href="http://www.broadinstitute.org/igv/projects/current/igv.php?sessionURL=/var/www/html/C1_SRR1178016.bam&genome=rn6&locus=$locus">Bam File</a></li>
		<p>&nbsp;</p>
</div>
        <div id="content_bottom"></div>
            
            <div id="footer"><h3><a href="http://www.bryantsmith.com">florida web design</a></h3></div>
      </div>
   </div>
</body>
</html>

END_OF_HTML

