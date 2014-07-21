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

# Indexed by unique field
sub splice_by_field {
	my $fields = shift;
	my $values = shift;
	my $field = shift;
	my $new_value = shift;
	
	# Walk array backwards 
	# Find the last index for this field
	# Splice in the new value
	
	# Perl does not support high .. low
	for(reverse 0 .. $#$fields) {
		if($field eq $fields->[$_]) {
			splice($fields, $_ + 1, 0, $field);
			splice($values, $_ + 1, 0, $new_value);
			last;
		}
	}	
}

return 1;
