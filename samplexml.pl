#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  samplexml.pl
#
#        USAGE:  ./samplexml.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  12/03/2014 12:05:38 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Data::Dumper;
use xml2hash;

my @in=<>;
print @in;
print "=====\n";
my $outhash=xml2hash::XMLinArray(@in);
print Dumper(%{$outhash});



