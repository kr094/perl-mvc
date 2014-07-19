package This;
use lib './';
use Err;

# Access control, raise an error if we don't have this
sub t {
	my $this = shift;
	my $type = shift;
	
	# Shift this from the referenced @_
	$this = shift @{$this};
	
	if(is_this($this, $type)) {
		Err::e("Missing object reference for class $type.\n(Did you call new?)");
	}
	
	return $this;
}

sub is_this {
	return defined $_[0] && defined $_[1] && ref $_[0] eq $_[1];
}

1;
