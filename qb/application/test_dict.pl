use strict;
use warnings;
use feature 'say';
use Data::Dumper;
use lib('../modules/Dictionary');
use Dictionary;

Dictionary::set_option('append_on_dup_key' => 1);
my $d = new Dictionary;
$d->add(1, 2, [1, 2, 3], {3 => 66});
test($d);

sub test {
	my $d = shift;
	
	label('size', $d->size());
	label('keys', $d->keys());
	label('values', $d->values());
	label('value', map $d->value($_), $d->keys());
	label('key_at', map $d->key_at($_), $d->range());
	label('value_at', map $d->value_at($_), $d->range());
	print Dumper($d);
}

sub label {
	my ($label, @values) = @_;
	say "$label " .join(' ', @values);
}
