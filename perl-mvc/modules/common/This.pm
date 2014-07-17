package This;
use lib './';
use Er;

# Access control, raise an error if we don't have this
sub t {
	my $t = shift;
	my $_this = shift;
	# Shift this from the referenced @_
	$t = shift @{$t};
	if(!is_this($t, $_this)) {
		Er::r('no init');
	}
	return $t;
}

sub is_this {
	return defined $_[0] && defined $_[1] && ref $_[0] eq $_[1];
}

1;
