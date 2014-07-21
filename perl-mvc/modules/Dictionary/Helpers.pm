package Helpers;

sub in_array {
	my $array = shift;
	my $value = shift;
	my $in_array = 0;
	
	for(values $array) {
		if($value eq $_) {
			$in_array = 1;
			last;
		}
	}

	return $in_array;
}

return 1;
