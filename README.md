Usage:

```PERL
use xml2hash;

my @in=<>;
print @in;
my %outhash=XMLinArray(@in);
print Dumper(%outhash);
```
or 

```
use strict;
use warnings;
use Data::Dumper;
use xml2hash;

my @in=<>;
print @in;
print "=====\n";
my $oneline=join("",@in);
my %outhash=XMLin($oneline);
print Dumper(%outhash);
```

Sample Input:
```
<!-- Add some comment here -->
<t0>
	<t1 name="Mike">
		<t2>a</t2>
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

```
$VAR1 = 't0';
$VAR2 = {
          't1' => [
                    {
                      't3' => 's',
                      't2' => [
                                'a',
                                'b'
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
