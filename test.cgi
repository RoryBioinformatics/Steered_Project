#!/usr/bin/perl -wT
use strict;
use CGI qw(:cgi); #use CGI
use CGI::Carp qw(fatalsToBrowser);      # Send error messages to browser
use Statistics::R;

# First take the value entered into the text field and put it into a variable.

my $who  = param("gene_name");
# Then generate an HTML page which prints the contents of the variable.
$ENV{'PATH'} = '/bin:/usr/bin';

my $R = Statistics::R->new();
$R->startR;
$R->send('x = 123');
$R->send('print(x)');
my $ret = $R->read;
$R->stopR;
#exit;
print <<END_of_HTML;
Content-type: text/html

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="style1.css" />
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
            	<li class="menuitem"><a href="index.html">Home</a></li>
                <li class="menuitem"><a href="about.html">About</a></li>
                <li class="menuitem"><a href="gene_search.html">Gene Search</a></li>
                <li class="menuitem"><a href="gene_list.html">Gene List</a></li>
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
                    <li><a href="#">Contact</a></li>
                    <li><a href="#">Annotation Mapping</a></li>
                </ul>
</div>
                
                
              <div id="leftmenu_bottom"></div>
        </div>
        
        
        
        
		<div id="content">
        
        
        <div id="content_top"></div>
        <div id="content_main">
        	<p>&nbsp;</p>
           	<p>&nbsp;</p>
       	  <h3>Gene Search</h3>
	<p>Your Gene is $who. 
	The returned value was: $ret.</p>
</div>
        <div id="content_bottom"></div>
            
            <div id="footer"><h3><a href="http://www.bryantsmith.com">florida web design</a></h3></div>
      </div>
   </div>
</body>

</html>
END_of_HTML
