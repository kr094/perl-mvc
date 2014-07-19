package Err;

sub e {
	die(join(', ', @_));
}

1;
