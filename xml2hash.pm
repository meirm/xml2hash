#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  xml2hash.pl
#
#        USAGE:  ./xml2hash.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Meir Michanie (meirm@riunx.com), 
#      COMPANY:  
#      VERSION:  1.1
#      CREATED:  12/01/2014 04:56:10 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
sub XMLin{
	my @lines;
	my %hash;
	@lines=@_;
	&reformat(\@lines);
	&removeComments(\@lines);
	&insertbranch(\%hash,\@lines) while @lines;
	&simplify(\%hash);
	return %hash;
}

#print Dumper %hash;
#print "\n";
sub removeComments{
	my ($lineref)=@_;
	my $in=0;
	foreach(@{$lineref}){
		if(m/<!--/){
			$in=1;
		}
		if (m/-->/){
			$in=0;
			$_="";
		}	
		$_="" if $in==1;
	}
}

sub simplify{
	my($hashref)=@_;
	#print STDERR "1. " . ref($hashref) ,"\n";
	#if ((ref($hashref) eq 'HASH' or ref($hashref) eq 'ARRAY')){
	if (ref($hashref) =~  m/^(:HASH|ARRAY)$/){
	foreach (keys %{$hashref}){
		#print STDERR "2. key $_ " . ref($hashref->{$_}) , "\n";
		if (ref($hashref->{$_}) eq 'ARRAY'){
			if (@{$hashref->{$_}} == 1){
				#print STDERR "Single value\n";
				$hashref->{$_}=$hashref->{$_}[0];
				if (ref($hashref->{$_}) =~  m/^(:HASH|ARRAY)$/){ &simplify(\%{$hashref->{$_}});}
			}else{
				#print STDERR "Multiple values\n";
				foreach(@{$hashref->{$_}}){
					#print STDERR "3. " .  ref($_) ,".\n";
					if (ref($_) =~  m/^(:HASH|ARRAY)$/) {&simplify($_);}
				}
			}
		}else{
			if (ref($hashref->{$_}) eq 'HASH'){
					&simplify(\%{$hashref->{$_}});
				}
		}
	}
 }
}

sub insertbranch{
	my($hashref,$linesref)=@_;
	my $keyline=shift @{$linesref};
	return if $keyline=~m/^\s*$/;
	while($keyline=~ m#>(.*?)=(.*)<#){
		$hashref->{$1}=$2;
		return unless @{$linesref};
		$keyline=shift @{$linesref};
	}
	while ($keyline=~ m#<(.*)>(.*)</\1>#){
		push @{$hashref->{$1}},$2;
		return unless @{$linesref};
		$keyline=shift @{$linesref};
	}
	while (defined ($keyline) && $keyline=~ m#<([^/]+)>#){
		my $key=$1;
		if ($key=~ m#(\S+)\s+(\S+.*)#){ 
			$key=$1; 
			&appendAttributes($linesref,$2);
		}
		my (@temparray)=&removeAfA($key,$linesref);
		push @{$hashref->{$key}},undef;
		&insertbranch(\%{$hashref->{$key}[-1]},\@temparray) while @temparray;
		return unless @{$linesref};
		$keyline=shift @{$linesref};
	}

}

sub appendAttributes{
	my($arref,$attrs)=@_;
	while($attrs){
		if($attrs=~ s/(\S+)\s*=\s*"(.*?)"\s*//){
			unshift(@{$arref},">$1=$2<");
		}
	}
}
sub removeAfA{
	my($key,$linesref)=@_;
	my @temparray;
	while(@{$linesref}){
		$_=shift @{$linesref};
		return @temparray if m#</$key>#;
		push @temparray,$_;
	}
	return @temparray; 
}

sub reformat{
	my($lineref)=@_;
	foreach (@{$lineref}){
		chomp;
		s/^\s*(.*?)\s*$/$1/;
	}
}

1
