XML2HASH
--------

Another XML to hash parser.


Usage:

```PERL
use xml2hash;

my @in=<>;
print @in;
my %outhash=XMLinArray(@in);
print Dumper(%outhash);
```
or 

```PERL
use strict;
use warnings;
use Data::Dumper;
use xml2hash;

my @in=<>;
my $oneline=join("",@in);
my %outhash=XMLin($oneline);
print Dumper(%outhash);
```

Sample Input:
```XML
<!-- Add some comment here -->
<t0>
	<t1 name="Mike">
		<t2 bus="true" memory="false">a</t2>
		<t2>b</t2>
		<t3>s</t3>
	</t1>
	<!--
	<t1 name="Zed">
		<t4>Chopper</t4>
		<t5>Zed is dead</t5>
	-->
	<t1 name="John" age="54">
		<t2>d</t2>
	</t1>
	<t1 name="Anna" age="33" status="Single">
		<t3>f</t3>
	</t1>
</t0>
```

and the Output:

```PERL
$VAR1 = 't0';
$VAR2 = {
          't1' => [
                    {
                      't2' => [
                                {
                                  'memory' => 'false',
                                  'bus' => 'true',
                                  'content' => 'a'
                                },
                                {
                                  't3' => 's'
                                }
                              ],
                      'name' => 'Mike'
                    },
                    {
                      't2' => 'd',
                      'name' => 'John',
                      'age' => '54'
                    },
                    {
                      't3' => 'f',
                      'status' => 'Single',
                      'name' => 'Anna',
                      'age' => '33'
                    }
                  ]
        };

```
