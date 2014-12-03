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
        my($in)=@_;
        $in=~s/\n//g;
        $in=~s/<!--.*?-->//g;
        $in=~s/>\s*</>\n</g;
        my @lines=split("\n",$in);
        return XMLinArray(@lines);
}

sub XMLinArray{
        my @lines;
        my %hash;
        @lines=@_;
        @lines=&reformat(@lines);
        &removeComments(\@lines);
        &insertbranch(\%hash,\@lines) while @lines;
        &simplify(\%hash);
        return %hash;
}

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
	if (ref($hashref) =~  m/^(HASH|ARRAY)$/){
	foreach (keys %{$hashref}){
		if (ref($hashref->{$_}) eq 'ARRAY'){
			if (@{$hashref->{$_}} == 1){
				$hashref->{$_}=$hashref->{$_}[0];
				if (ref($hashref->{$_}) =~  m/^(HASH|ARRAY)$/){ &simplify(\%{$hashref->{$_}});}
			}else{
				foreach(@{$hashref->{$_}}){
					if (ref($_) =~  m/^(HASH|ARRAY)$/) {&simplify($_);}
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
        while ($keyline=~ m#<(.*)>(.*)</\1>#){
                push @{$hashref->{$1}},$2;
                return unless @{$linesref};
                $keyline=shift @{$linesref};
        }
        while (defined ($keyline) && $keyline=~ m#<([^/]+)>#){
                my $key=$1;
                my (@temparray)=&removeAfA($key,$linesref);
                push @{$hashref->{$key}},undef;
                &insertbranch(\%{$hashref->{$key}[-1]},\@temparray) while @temparray;
                return unless @{$linesref};
                $keyline=shift @{$linesref};
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
        my(@lineref)=@_;
        my @lines;
        foreach (@lineref){
                chomp;
                s/^\s*(.*?)\s*$/$1/;
                next if m/^\s*$/;
                if (($_ !~ m#</#) && (m#<(.*?)\s+(.*)>#)){
                 my $key=$1;
                 my $params=$2;
                 push @lines,"<$key>";
                 while ($params=~ s/\s*(.*?)\s*=\s*"(.*?)"\s*//){
                        push @lines,"<$1>$2</$1>";
                }
                 next;
                }
                push @lines,$_;
        }
        return @lines;
}
1
