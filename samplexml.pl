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
use xml2hash;
use Data::Dumper;
#my $xml=xml2hash->new();

my @in=<>;
print @in;
print "=====\n";
#my %outhash=$xml->XMLin(@in);
my %outhash=XMLin(@in);
print Dumper(%outhash);



