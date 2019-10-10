#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fin,$fout,$p,$n,$result);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"int:s"=>\$fin,
	"out:s"=>\$fout,
	"p:s"=>\$p,
	"n:s"=>\$n,
	"result:s"=>\$result,
			) or &USAGE;
&USAGE unless ($fout);
$fout=ABSOLUTE_DIR($fout);
#my $wsh="$fout/work_sh";
#mkdir $wsh if (!-d $wsh);

#open Out,">$wsh/bayenv.sh";
my @files=glob("$fin/*");
foreach my $file (@files) {
	my $rando=int(rand(100000))+100000;
	my $fln=basename($file);
	`cd $fout && ./bayenv2 -i marker/$fln -e matrix.env -m matrix.txt -p $p -k 100000 -n $n -t -r $rando`;
	#print Out "cd $fout && ./bayenv2 -i marker/$fln -e matrix.env -m matrix.txt -p $p -k 100000 -n $n -t -r $rando\n";
}
close Out;

#######################################################################################
print STDOUT "\nDone. Total elapsed time : ",time()-$BEGIN_TIME,"s\n";
#######################################################################################
sub ABSOLUTE_DIR #$pavfile=&ABSOLUTE_DIR($pavfile);
{
	my $cur_dir=`pwd`;chomp($cur_dir);
	my ($in)=@_;
	my $return="";
	if(-f $in){
		my $dir=dirname($in);
		my $file=basename($in);
		chdir $dir;$dir=`pwd`;chomp $dir;
		$return="$dir/$file";
	}elsif(-d $in){
		chdir $in;$return=`pwd`;chomp $return;
	}else{
		warn "Warning just for file and dir \n$in";
		exit;
	}
	chdir $cur_dir;
	return $return;
}
sub USAGE {#
        my $usage=<<"USAGE";
Contact:        meng.luo\@majorbio.com;
Script:			$Script
Description:
	split -d -a 7 -l 2 out.bayenv.SNPfile marker
	eg: perl -int filename -out filename 
	
Usage:
  Options:
	"int:s"=>\$fin,
	"out:s"=>\$fout,
	"p:s"=>\$p,
	"n:s"=>\$n,
	"result:s"=>\$result,
	-h         Help

USAGE
        print $usage;
        exit;
}
