#!/usr/bin/perl -w

use strict;
use warnings;
use Statistics::R;
use Tk;
use Tk::NoteBook;
use Tk::FileSelect;
use Tk::ProgressBar;
use Tk::PNG;

my $mw = MainWindow->new();
$mw->geometry( "933x400" );
my $book = $mw->NoteBook()->pack( -fill=>'both', -expand=>1);
my $R = Statistics::R->new();

my $tab = $book->add( "Sheet 1", -label=>"Metabolite Statistical Processing App", -anchor=> 'center', -createcmd=>\&getStartTime);
my $tab1 = $book->add( "Sheet 2", -label=>"Pareto Removal");
my $tab2 = $book->add( "Sheet 3", -label=>"Outlier Removal");
my $tab3 = $book->add( "Sheet 4", -label=>"Ranked Inverse Normalised Transformation");
my $tab4 = $book->add( "Sheet 5", -label=>"Modelling");
my $tab5 = $book->add( "Sheet 6", -label=>"Discovery and Analysis");



# MSPA
# Text box to describe function of the program and provide links to github etc.
my $update = "Ready.";
my $starttime;
my $Timestart = $tab->Label(-textvariable=>\$starttime )->pack();
my $text1 = $tab->Label(-text=>('This is the Metabolite Statistical Processing App. ADD FURTHER INFORMATION SOON'))->pack();



# Pareto Removal
# File input, SD cutoff entry and progress bar.
my ($file2, $txt, @files, $percent_done);
my $frame1 = $tab1 -> Frame();
my $pareto_label = $frame1 -> Label(-text=> "The Pareto Removal widget allows for the removal of any rows within the
dataset that have a number of zero values equal to or above the chosen parameter.");
my $lab = $frame1 -> Label(-text=>"Find your file:   ");
my $ent = $frame1 -> Entry(-width=>60);
my $but2 = $frame1 -> Button(-text=>"Choose file", -command =>\&file_list_par);

my $Zero_cutoff_label = $frame1 -> Label(-text=>'Max percentage of 0 values
allowed (in decimal format):  ');
my $Zero_cutoff_entry = $frame1 -> Entry();

my $but3 = $frame1 -> Button(-text=>"Submit for Removal", -command =>\&pareto);
my $progress = $frame1->ProgressBar(-width => 30, -height => 10, -from => 0, -to => 100, -blocks => 50, -colors => [0, 'green', 50, 'yellow' , 80, 'red'], -variable => \$percent_done, -relief=>'raised', -borderwidth=>2);
my $proglabPR = $frame1 -> Label(-textvariable=>\$update);

# Pareto Removal Grid
$pareto_label -> grid(-row=>1, -column=>1, -columnspan=>3);
$lab -> grid("x",-row=>2,-column=>1, -sticky=>'w');
$ent -> grid(-row=>2,-column=>2, -sticky=>'w,e');
$but2 -> grid(-row=>2,-column=>3, -pady=>10, -padx=>5);
$Zero_cutoff_label-> grid("x",-row=>3,-column=>1, -sticky=>'w');
$Zero_cutoff_entry-> grid(-row=>3,-column=>2, -sticky=>'w,e');
$progress -> grid(-row=>5,-column=>1, -sticky=>'w,e',-pady=>5, -columnspan=>3, -padx=>20);
$but3 -> grid(-row=>4,-column=>1, -columnspan=>3, -ipadx=>50, -pady=>5);
$frame1 -> grid(-row=>1,-column=>1,-sticky=>'w,e');
$proglabPR -> grid(-row=>6, -column=>1, -columnspan=>3);


# OR
# File input and parameter box.
my ($txtOR, $percent_doneOR,$file3);
my $frame2 = $tab2 -> Frame();
my $Outlier_label = $frame2 -> Label(-text=> "The Outlier Removal tool uses the given standard deviation to apply
NA labels to both outliers (above or below the given SD) and zero values.");
my $labOR = $frame2 -> Label(-text=>"Find your file:   ");
my $entOR = $frame2 -> Entry(-width=>60, -textvariable=>\$file3);
#my $but = $frame1 -> Button(-text=>"Submit file", -command =>\&push_button);
my $but2OR = $frame2 -> Button(-text=>"Choose file", -command =>\&file_list_OR);

my $SD_label = $frame2 -> Label(-text=>'Set the Standard Deviation
 from the mean cutoff:   ');
my $SD_entry = $frame2 -> Entry();

my $update1 = "Ready.";
my $but3OR = $frame2 -> Button(-text=>"Submit for Removal", -command =>\&NA);
my $progressOR = $frame2->ProgressBar(-width => 30, -height => 10, -from => 0, -to => 100, -blocks => 50, -colors => [0, 'green', 50, 'yellow' , 80, 'red'], -variable => \$percent_doneOR, -relief=>'raised', -borderwidth=>2);
my $proglabOR = $frame2 -> Label(-textvariable=>\$update1);

# Outlier Removal Grid
$Outlier_label -> grid(-row=>1, -column=>1, -columnspan=>3);
$labOR -> grid("x",-row=>2,-column=>1, -sticky=>'w');
$entOR -> grid(-row=>2,-column=>2, -sticky=>'w,e');
#$but -> grid(-row=>1,-column=>4);
$but2OR -> grid(-row=>2,-column=>3, -pady=>10, -padx=>5);
$SD_label-> grid("x",-row=>3,-column=>1, -sticky=>'w');
$SD_entry-> grid(-row=>3,-column=>2, -sticky=>'w,e');
$progressOR -> grid(-row=>5,-column=>1, -sticky=>'w,e',-pady=>10, -columnspan=>3);
$but3OR -> grid(-row=>4,-column=>1, -columnspan=>3, -ipadx=>50);
$frame2 -> grid(-row=>1,-column=>1,-sticky=>'w,e');
$proglabOR -> grid(-row=>6, -column=>1, -columnspan=>3);



# RINT
# A file input and potential progress bar.
my ($txtRINT, $percent_doneRINT, $file4, $update2);
my $frame3 = $tab3 -> Frame();
my $rINT_label = $frame3 -> Label(-text=> "The Rank Inverse Normalised Transformation tool normalises
a dataset per row based on the deviation from the mean.");
my $labRINT = $frame3 -> Label(-text=>"Find your file:   ");
my $entRINT = $frame3 -> Entry(-width=>60, -textvariable=>\$file4);
#my $but = $frame1 -> Button(-text=>"Submit file", -command =>\&push_button);
my $but2RINT = $frame3 -> Button(-text=>"Choose file", -command =>\&file_list_RINT);

my $but3RINT = $frame3 -> Button(-text=>"Submit to Normalise", -command =>\&RINT);
my $progressRINT = $frame3->ProgressBar(-width => 30, -height => 10, -from => 0, -to => 100, -blocks => 50, -colors => [0, 'green', 50, 'yellow' , 80, 'red'], -variable => \$percent_doneRINT, -relief=>'raised', -borderwidth=>2);
my $proglabRINT = $frame3 -> Label(-textvariable=>\$update2);

# rINT Grid
$rINT_label -> grid(-row=>1, -column=>1, -columnspan=>3);
$labRINT -> grid(-row=>2,-column=>1, -sticky=>'w', -pady=>5);
$entRINT -> grid(-row=>2,-column=>2, -sticky=>'w,e', -pady=>5);
#$but -> grid(-row=>1,-column=>4);
$but2RINT -> grid(-row=>2,-column=>3, -pady=>10, -padx=>5);
$progressRINT -> grid(-row=>5,-column=>1, -sticky=>'w,e',-pady=>10, -columnspan=>3);
$but3RINT -> grid(-row=>4,-column=>2, -pady=>10, -ipady=>5);
$frame3 -> grid(-row=>1,-column=>1,-sticky=>'w,e');
$proglabRINT -> grid(-row=>6, -column=>1, -columnspan=>3);


# MO
# A large array of input boxes, a file input and a label that describes the current model.
my (@IVr, $DVr, $MODr, $percent_doneMOD, $file5, $file6, $IVvis, $update3);
$MODr = "lm";
my $modvisual = "Your Model is: $MODr ($DVr ~ @IVr Metabolite)";
my $frame4 = $tab4 -> Frame()->pack();
my $mod_label = $frame4 -> Label(-text=> "The Model tool can be used to run a linear or logistic regression model of the dependent variable as a model of a number of independent variables.
The tool requires the separation of variables measured and the independent metabolite variable into two tables to work.");
my $labMOD = $frame4 -> Label(-text=>"Variable File:   ");
my $entMOD = $frame4 -> Entry(-width=>60, -text=>"$file5");
my $but2MOD = $frame4 -> Button(-text=>"Choose file", -command =>\&file_list_MOD);
my $labMOD_met = $frame4 -> Label(-text=>"Metabolite File:   ");
my $entMOD_met = $frame4 -> Entry(-width=>60, -text=>"$file6");
my $but2MOD_met = $frame4 -> Button(-text=>"Choose file", -command =>\&file_list_MOD_met);
my $frame5 = $tab4 -> Frame()->pack(-anchor=>'n', -side=>'bottom');
my $model = 'Linear';
my $model_label = $tab4 -> Label(-text=>'Set Model Type:')->pack(-side=>'left',-padx=>48);
foreach(qw/Linear Logistic/){
	$tab4 -> Radiobutton(-text=>$_, -value=>$_, -variable=>\$model, -command=>\&Model_type)->pack(-side=>'left', -expand=>1);
}

my $DV_label = $frame5 -> Label(-text=>'Add dependent variable to model:');
my $DV = $frame5 -> Entry(-width=>15);
my $but_DV = $frame5 -> Button(-text=>"Submit", -command =>\&push_button_DV);
my $IV_label = $frame5 -> Label(-text=>'Add independent variable to model:');
my $IV = $frame5 -> Entry(-width=>15);
my $but_IV = $frame5 -> Button(-text=>"Submit", -command =>\&IV_submit);
my $model_rep = $frame5-> Label(-textvariable=>\$modvisual,-relief=>'ridge', -borderwidth=>2, -pady=>5, -padx=>5);
my $cancel = $frame5 -> Button(-text=>"Clear Model", -command => \&Clear);
my $but3MOD = $frame5 -> Button(-text=>"Submit Model", -command =>\&Model);
my $progressMOD = $frame5->ProgressBar(-width => 30, -height => 10, -from => 0, -to => 100, -blocks => 50, -colors => [0, 'green', 50, 'yellow' , 80, 'red'], -variable => \$percent_doneMOD, -relief=>'raised', -borderwidth=>2);
my $proglabMOD = $frame5 -> Label(-textvariable=>\$update3);

# MO Grid
$mod_label -> grid(-row=>1, -column=>1, -columnspan=>3);
$labMOD -> grid(-row=>2,-column=>1, -sticky=>'w', -pady=>5);
$entMOD -> grid(-row=>2,-column=>2, -sticky=>'w,e', -pady=>5);
$but2MOD -> grid(-row=>2,-column=>3, -pady=>10, -padx=>5);
$labMOD_met -> grid(-row=>3, -column=>1, -sticky=>'w', -pady=>5);
$entMOD_met -> grid(-row=>3,-column=>2, -sticky=>'w,e', -pady=>5);
$but2MOD_met -> grid(-row=>3,-column=>3, -pady=>10, -padx=>5);

$DV_label-> grid(-row=>1,-column=>1, -sticky=>'w', -pady=>10);
$DV-> grid(-row=>1,-column=>2, -pady=>10, -padx=>5);
$but_DV-> grid(-row=>1,-column=>3, -pady=>10, -padx=>5);
$IV_label-> grid(-row=>1,-column=>4, -pady=>10, -padx=>5);
$IV-> grid(-row=>1,-column=>5, -pady=>10, -padx=>5);
$but_IV-> grid(-row=>1,-column=>6, -pady=>10, -padx=>5);
$model_rep-> grid(-row=>3,-column=>1, -columnspan=>3, -pady=>10, -padx=>5, -sticky=>'e');
$cancel-> grid(-row=>3, -column=>4);
$progressMOD -> grid(-row=>4,-column=>4, -sticky=>'we',-pady=>10, -columnspan=>3);
$but3MOD -> grid(-row=>4,-column=>1, -columnspan=>2, -pady=>10, -ipady=>5, -ipadx=>10);
$proglabMOD -> grid(-row=>3, -column=>5, -columnspan=>2);



# DA
# 3 images, a scrollbar and a listbox. Potential labels to describe the images and output too.
my $frm_gen = $tab5 -> Frame();
my $frm_list = $tab5 -> Frame();
my $frm_phist = $tab5 -> Frame();
my $frm_fhist = $tab5 -> Frame();
my $frm_plot = $tab5 -> Frame();

my $genent = $frm_gen -> Entry();
my $genchoose = $frm_gen -> Button(-text=>"Choose file", -command=>\&file_list_DA);
my $genbutton = $frm_gen -> Button(-text=>"Generate Results", -command=>\&generate_results);
my $list = $frm_list -> Listbox(-width=>28, -height=>16);
my $list2 = $frm_list -> Listbox(-width=>28, -height=>16);
my $list3 = $frm_list -> Listbox(-width=>28, -height=>16);
my @txtboxes = ($list, $list2, $list3);
#$list->insert('end', "one", "two", "three", "four", "five", "six", 
#                       "seven", "eight", "nine", "ten", "eleven");
#$list2->insert('end', "one", "two", "three", "four", "five", "six", 
#                       "seven", "eight", "nine", "ten", "eleven");
#$list3->insert('end', "one", "two", "three", "four", "five", "six", 
#                       "seven", "eight", "nine", "ten", "eleven");
my $p_hist;
my $f_hist;
my $_plot;

my $srl_y = $frm_list -> Scrollbar(-orient=>'v', -command=>sub { 
	foreach (@txtboxes) {
		$_->yview(@_);
	}
});
$list -> configure(-yscrollcommand=>['set', $srl_y]);
$list2 -> configure(-yscrollcommand=>['set', $srl_y]);
$list3 -> configure(-yscrollcommand=>['set', $srl_y]);
my $phist = $frm_phist->Photo(-file => "$p_hist");
my $phist_lab = $frm_phist -> Label(-image=>$phist);
my $fhist = $frm_fhist->Photo(-file => "$f_hist");
my $fhist_lab = $frm_fhist -> Label(-image=>$fhist);
my $plot = $frm_plot->Photo(-file => "$_plot");
my $plot_lab = $frm_plot -> Label(-image=>$plot);

# DA Grid
$frm_gen-> grid(-row=>1,-column=>1,-columnspan=>6);
$frm_list -> grid(-row=>2,-column=>1,-columnspan=>3);
$frm_phist -> grid(-row=>3,-column=>1,-columnspan=>3);
$frm_fhist -> grid(-row=>3,-column=>4,-columnspan=>3);
$frm_plot -> grid(-row=>2,-column=>4,-columnspan=>3);
$genent -> grid(-row=>1,-column=>1, -columnspan=>2, -sticky=>'nsew');
$genchoose -> grid(-row=>1,-column=>3, -columnspan=>2, -sticky=>'nsew');
$genbutton -> grid(-row=>1,-column=>5, -columnspan=>2, -sticky=>'nsew');
$list -> grid(-row=>1,-column=>2);
$list2 -> grid(-row=>1,-column=>3);
$list3 -> grid(-row=>1,-column=>4);
$srl_y -> grid(-row=>1,-column=>1, -ipady=>134);
$phist_lab -> grid(-row=>1,-column=>1);
$fhist_lab -> grid(-row=>1,-column=>1);
$plot_lab -> grid(-row=>1,-column=>1);



MainLoop;

sub getStartTime {
  $starttime = "Welcome. MSPA widget started at " . localtime;
}


sub file_list_par {
	my $FSref = $mw->FileSelect();
	my $file2 = $FSref->Show;
	$ent -> insert('end',"$file2");
}



sub pareto {
# Program to handle csv files and clean according to the 80% rule using the R program. 
	$update = "Running.";
	my $percentage = $Zero_cutoff_entry -> get();
	print $percentage;
	if ($percentage =~ m/^0.[0-9]{1,3}$/){
		$update = "Allowed Percentage.";
		print "Allowed Percentage.\n";
	}
	else {
		$update = "Disallowed percentage. Please specify between 0 and 1.";
		print "\nDisallowed percentage. Please specify between 0 and 1.\n";
		return;
	}
	$Zero_cutoff_entry -> delete(0,'end');
	my $filename = $ent ->get();
	$ent -> delete(0,'end');
	print $filename;
	

# Handle input file and store in a scalar.
my @infile = split ('/', $filename);
shift @infile;
shift @infile;
shift @infile;
unshift @infile, '~';
$filename = join ('/', @infile);
my $infile = pop @infile;

$R->startR;
print "Reading file. ";
$update = "Reading file.";
# Read the dataframe into the R program
$R->run("$infile <- read.csv('$filename', row.names=1)");
print "Done.\n";

print "\nChatting with R. ";
$update = "Chatting with R.";
# Uses plyr module for the counting function
$R->run("library(plyr)");

# Takes column and row data from the dataset and takes the file name into a scalar
$R->run("a<-colnames($infile)");
$R->run("a");
my $colnames = $R->read;
$R->run("b<-rownames($infile)");
$R->run("b");
my $rownames = $R->read;
$R->run("length(a)");
my $collength = $R->read;
$R->run("length(b)");
my $rowlength = $R->read;
$R->run("myFile <-$infile");
print "Done.";
$update = "Done.";
# Cuts the [1] response from R row length reads.
my $lengthrow = reverse ($rowlength);
chop $lengthrow;
chop $lengthrow;
chop $lengthrow;
chop $lengthrow;
$rowlength = reverse ($lengthrow);

# Reads each row to determine amount of empty results in each (equal to 0)
my $count = 0;
my @rows = split (" ", $rownames);
my @names;
print "\nLearning names. ";
$update = "Learning names.";
foreach (@rows){
	if ($_ =~ m/\d+_\d+/|| $_ =~ m/\d+.\d+m.z/|| $_ =~ m/\d+.\d+n/){
		print $_;
		push (@names, $_);
	}
}
print "Done.\n";

# Cuts the [1] response from R column length reads.
my $lengthcol = reverse ($collength);
chop $lengthcol;
chop $lengthcol;
chop $lengthcol;
chop $lengthcol;
$collength = reverse ($lengthcol);
print "\nLocating Mop.\n";
$update = "Cleaning.";
while ($count < $rowlength){
	my $freq = 0;
	my $row = $names[$count];
	print "$row\n";
	$R->run("count(as.numeric(myFile [$row,]))");
	my $countfunc = $R->read;
	# Float search in the count function for values of 0.00 etc
	if ($countfunc =~ m/1\s+0.0+\s+(\d+)/){
		$freq = $1;
		print ".";
	}
	# Int search for values of 0
	elsif($countfunc =~ m/1\s+0\s+(\d+)/){
		$freq = $1;
		print ".";
	}
	elsif($countfunc =~ m/1\s+0.0{4,6}\w{1}\W{1}00\s+(\d+)/){
		$freq = $1;
		print ".";
	}
	my $rule = ($collength - $freq);
	if (($rule/$collength) < $percentage||($rule/$collength) == 0){
		$R->run("myFile <- data.frame(myFile[!rownames(myFile) %in% $row, ])");
		print $row;
	}
	$count ++;
	print $count;
	for (my $i = $count; $i <= $rowlength; $i++) { 
		$percent_done = ($i/$rowlength)*100;
		$frame1 ->update;
	}
}

chop $infile;
chop $infile;
chop $infile;
chop $infile;
print "\nData Polished!";
$R->run("write.csv(myFile, file='$infile.clean.csv')");
print "Finished!";
$update = "File written- $infile.clean.csv.";
$R->stopR;
return;
}



sub NA {
	$update1 = "Running.";
	$percent_doneOR = 0;
	my $filename = $entOR -> get();
	$entOR -> delete(0,'end');
	print $filename;
	my $SD = $SD_entry -> get();
	print $SD;
	if ($SD =~ m/^[0-9]{1}$/){
		$update1 = "Allowed Percentage.";
		print "Allowed Percentage.\n";
	}
	else {
		$update1 = "Disallowed percentage. Please specify integer between 0 and 9.";
		print "\nDisallowed percentage. Please specify integer between 0 and 9.\n";
		return;
	}
	$SD_entry -> delete(0,'end');

	use Statistics::R;

	# Handle input file and store in a scalar.
	my @infile = split ('/', $filename);
	shift @infile;
	shift @infile;
	shift @infile;
	unshift @infile, '~';
	$filename = join ('/', @infile);
	my $infile = pop @infile;
	chop $infile;
	chop $infile;
	chop $infile;
	chop $infile;

	$R->startR;
	for (my $j = 0; $j <= 1000; $j++) { 
			$percent_doneOR = $j/10;
			$frame1 ->update;
	}
	$update1 = "Reading Files";
	$frame2 -> update;
	# Runs NA script- removes scores 3*SD and equal to 0 and gives them NA. 
	$R->run("infile <- read.csv('$filename', row.names=1)");
	print $filename;

	$update1 = "Running data...";
	$frame2 -> update;
	$R->run("df  <- data.frame()
	sdremove <- function(j) {
		if (j > under||j < over || j == 0 || is.na(j)){
			j <- NA
		}
		return (j)
	}
	for (i in 1:nrow(infile)){
		SD <- sd(as.numeric(infile[i,]))
		SD3 <- (SD*$SD)
		mean <- mean(as.numeric(infile[i,]))
		over <- (mean - SD3)
		under <- (mean + SD3)
		ret <- lapply(as.matrix(infile[i,]),sdremove)
		df <- rbind(df, ret)
	}
	write.csv(df, file='$infile.NA.csv')");
	$update1 = "Created file: $infile.NA.csv";
	$frame2 -> update;
	print "Created file: $infile.NA.csv";
	$R -> stopR;
	return;
}

sub RINT{
	$update2 = "Running.";
	$percent_doneRINT = 0;
	$R->startR;
	my $filename = $entRINT -> get();
	$entRINT -> delete(0,'end');
	my @infile = split ('/', $filename);
	shift @infile;
	shift @infile;
	shift @infile;
	unshift @infile, '~';
	$filename = join ('/', @infile);
	my $infile = pop @infile;
	chop $infile;
	chop $infile;
	chop $infile;
	chop $infile;
	
	for (my $j = 0; $j <= 1000; $j++) { 
			$percent_doneRINT = $j/10;
			$frame1 ->update;
	}
	# Gives file location for R use
	my $location = `pwd`;
	chomp $location;
	
	$update2 = "Ranking.";
	# Used to rank inverse normalise transform
	$R->run("infile <- read.csv('$filename', row.names=1)
	df  <- data.frame()
	for (i in 1:nrow(infile)){
		var2int <- infile[i,]
		int<-qnorm((rank(var2int,na.last='keep')-0.5)/sum(!is.na(var2int)))
		df <- rbind(df, int)
	}	
	write.csv (df, file='$infile.rank.csv')");

	$update2 = "Finished. File $infile.rank.csv saved.";
	$R -> stopR;
}

sub Model{
	print "$modvisual\n";
	$update3 = "Running.";
	my $logistic;
	$R->startR;
	my $filename = $entMOD -> get();
	$entMOD -> delete(0,'end');
	my $metab = $entMOD_met -> get();
	$entMOD_met -> delete(0,'end');
	my @infile = split ('/', $filename);
	shift @infile;
	shift @infile;
	shift @infile;
	unshift @infile, '~';
	$filename = join ('/', @infile);
	my $infile = pop @infile;
	chop $infile;
	chop $infile;
	chop $infile;
	chop $infile;
	my @infile2 = split ('/', $metab);
	shift @infile2;
	shift @infile2;
	shift @infile2;
	unshift @infile2, '~';
	$metab = join ('/', @infile2);
	$update3 = "Preparing Files.";

	$R->run("infile <- read.csv('$filename', row.names=1)");

	$R->run("variables <- read.csv('$metab', row.names=1)");

	$update3 = "Preparing Command.";
	foreach (@IVr) {
	$R->run("$_ <-(as.numeric(variables['$_',]))");
	}

	$R->run("$DVr <-(as.numeric(variables['$DVr',]))");
	$R->run('library(plyr)
	df <-data.frame()');

	if ($MODr eq "glm"){ 
			$logistic = "family=binomial(link='logit'),";
	}
	elsif ($MODr eq "lm"){ 
			$logistic = "";
	}
	for (my $j = 0; $j <= 1000; $j++) { 
			$percent_doneMOD = $j/10;
			$frame5 ->update;
	}
	$update3 = "Running Command.";
	# Create and run for loop in R via evaluation
	$R->run('for (i in 1:nrow(infile)){
	Metabolite <-(as.numeric(infile[i,]))'."
	model = $MODr($DVr~$IVvis Metabolite,$logistic na.action=na.omit)".'
	coe <-summary(model)$coefficients
	df <- rbind(df, coe)
	rsq <-summary(model)$r.squared
	df <- rbind(df, rsq)
	Identifier <- rownames(infile[i,])
	df <- rbind(df, Identifier)
	}');

	$update3 = "Writing to file.";
	$R->run("write.csv(df, file='pval.$DVr.$infile.metab.csv')");
	$update3 = "Complete. ";
	print "Complete.\n";
	return;
}

sub push_button_par {
	my $file = $ent -> get();
	push (@files, $file2);
	$txt -> insert('end',"$file\n");
	print @files;
	$ent -> delete(0,'end');
}
sub file_list_OR {
	my $FSref = $mw->FileSelect();
	my $file2 = $FSref->Show;
	$entOR -> insert('end',"$file2");
}

sub file_list_RINT {
	my $FSref = $mw->FileSelect();
	my $file4 = $FSref->Show;
	$entRINT -> insert('end',"$file4");
}

sub file_list_MOD {
	my $FSref = $mw->FileSelect();
	my $file5 = $FSref->Show;
	$entMOD -> insert('end',"$file5");
}

sub file_list_MOD_met {
	my $FSref = $mw->FileSelect();
	my $file6 = $FSref->Show;
	$entMOD_met -> insert('end',"$file6");
}

sub Model_type {
	print $model;
	if ($model eq "linear"){
		$MODr = "lm";
	$modvisual = "Your Model is: $MODr ($DVr ~ $IVvis Metabolite)";
	$frame5 ->update;
	}
	elsif ($model eq "logistic"){
		$MODr = "glm";
	$modvisual = "Your Model is: $MODr ($DVr ~ $IVvis Metabolite)";
	$frame5 ->update;
	}
}

sub push_button_DV {
	$DVr = $DV -> get();
	if ($DVr eq ""){print "Enter a legitimate varible."; return;}
	$modvisual = "Your Model is: $MODr ($DVr ~ $IVvis Metabolite)";
	$frame5 ->update;
	$DV -> delete(0,'end');
}

sub IV_submit{
	my $file = $IV -> get();
	if ($file eq ""){print "Enter a legitimate varible."; return;}
	push (@IVr, $file);
	print "$IVr[0]\n";
	$IVvis = "$IVr[0]"."+";
	if ($#IVr > 0){
		foreach my $i (1.. $#IVr){
			$IVvis = $IVvis."$IVr[$i]"."+";
		}
	}
	print "$IVvis\n";
	$modvisual = "Your Model is: $MODr ($DVr ~ $IVvis Metabolite)";
	$frame5 ->update;
	$IV -> delete(0,'end');
}

sub Clear {
	undef $DVr;
	undef @IVr;
	undef $IVvis;
	$modvisual = "Your Model is: $MODr ($DVr ~ $IVvis Metabolite)";
	$frame5 ->update;
}

sub file_list_DA{
my $FSref = $mw->FileSelect();
	my $file7 = $FSref->Show;
	$genent -> insert('end',"$file7");
}

sub generate_results{
	$R->startR;
	my $filename = $genent -> get();
	$genent -> delete(0,'end');
	
	my @infile = split ('/', $filename);
	shift @infile;
	shift @infile;
	shift @infile;
	unshift @infile, '~';
	$filename = join ('/', @infile);

	system "pval_gui_processor.pl $filename";
#	my $infile = pop @infile;
#	chop $infile;
#	chop $infile;
#	chop $infile;
#	chop $infile;
#	print $filename;
#	open (INFILE, $filename) or die ("Cannot open input file"); 
#	$infile.pval.csv
	$frm_list ->update;
	$frm_phist->update;
	$frm_fhist->update;
	$frm_plot->update; 
}

