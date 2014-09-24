package This;
use lib './';
use Err;

# Access control
sub t {
	my $this = shift;
	my $type = shift;
	
	# Remove implicit object from callers @_ by reference
	$this = shift @{$this};
	
	if(!is_this($this, $type)) {
		Err::e("Missing object reference for class $type.\n");
	}
	
	return $this;
}

sub is_this {
	return defined $_[0] && defined $_[1] && ref $_[0] eq $_[1];
}

1;
