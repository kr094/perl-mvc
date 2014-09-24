package ArrayHelpers;

sub in {
	my $array = shift;
	my $value = shift;
	my $in = 0;
	
	for(values $array) {
		if($value eq $_) {
			$in = 1;
			last;
		}
	}

	return $in;
}

return 1;
