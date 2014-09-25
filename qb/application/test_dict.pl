use lib('../modules/Dictionary');
use Dictionary;

use Data::Dumper;

$d = new Dictionary;

print Dumper($d->add('key', 'value', 'key2', 'value2'));

print $d->size() ."\n";

print $d->get_index($_) for(0..$d->count());

print "\n";

print $d->get_key($_) for(keys %$d);