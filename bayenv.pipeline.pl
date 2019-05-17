#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($vcf,$out,$wsh,$npop,$nenv,$env,$gro);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"vcf:s"=>\$vcf,
	"out:s"=>\$out,
	"npop:s"=>\$npop,
	"env:s"=>\$env,
	"nenv:s"=>\$nenv,
	"gro:s"=>\$gro,
	"wsh:s"=>\$wsh,
			) or &USAGE;
&USAGE unless ($vcf and $out and $npop);
$vcf=ABSOLUTE_DIR($vcf);
$gro=ABSOLUTE_DIR($gro);
mkdir $out if (!-d $out);
$out=ABSOLUTE_DIR($out);
$wsh||="$out/work_sh";
mkdir $wsh if (!-d $wsh);
my $rnumber = int(rand(1000000));
open SH,">$wsh/bayenv.sh";
print SH "python $Bin/bin/vcf_2_div.py $vcf -m $gro -o $out/out && ";
print SH "./$Bin/bin/bayenv2 -i $out/out.bayenv.SNPfile -p $npop -k 100000 -r $rnumber >$out/matrix.out && ";
print SH "perl $Bin/bin/get.matrix.env.pl -int $out/matrix.out -out $out/matrix.env && ";
print SH "./$Bin/bin/calc_bf.sh $out/out.bayenv.SNPfile $env $out/matrix.env $npop 100000 $nenv && ";
print SH "perl $Bin/bin/bayenv.result.pl -bf $out/bf_environ.$env -out $out/result ";
close SH;
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
Contact:        men.luo\@majorbio.com;
Script:			
Description:
	eg:
	perl $Script -vcf demo/pop.recode.vcf -out ./ -npop 31 -env demo/env20.env -nenv 20 -gro demo/populationmap

Usage:
  Options:
  -vcf	<file>	input vcf files
  -out	<dir>	output dir
  -npop	<num>	the number of groups 
  -env <file> the enviroment data matrix
  -nenv <num> the number of envorinment factors
  -gro <file> group list file
  -h         Help

USAGE
        print $usage;
        exit;
}
