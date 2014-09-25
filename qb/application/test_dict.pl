use lib('../modules/Dictionary');
use Dictionary;

use Data::Dumper;

$d = new Dictionary;

print Dumper($d->add('1', '2', 1, 2, 1, 2, 3, 4, 3, 4, 5, 5, 6, 6));

print $d->size() ."\n";

print $d->get_index($_) for(0..$d->count());