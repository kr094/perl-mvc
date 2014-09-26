use Data::Dumper;
use lib('../modules/Dictionary');
use Dictionary;

$d = new Dictionary;
$d->add(1, 2, 3, 4, {key => 'val'}, {key => 'test'});
test($d);

sub test {
	my $d = shift;
	print Dumper($d);
	print $d->size();
	print "\n";
	print $d->key_value($_) for($d->keys());
	print "\n";
	print $d->index_key($_) for(0..$d->count());
	print "\n";
	print $d->index_value($_) for(0..$d->count());
}

