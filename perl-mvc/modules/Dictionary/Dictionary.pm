package Dictionary;
use Helpers;
use Trim;

sub new {
	return bless {
		field => [],
		value => []
	}, shift;
}

sub add {
	my $dict = shift;
	my $field = Trim::trim(shift);
	my $value = Trim::trim(shift);
	my $field_set = $dict->{field};
	my $value_set = $dict->{value};
	
	if(!defined $field) {
		$field = '';
	} elsif(!defined $value) {
		$value = '';
	}
	
	if(Helpers::in_array($field_set, $field)) {
		splice_by_field($field_set, $value_set, $field, $value);
	} else {
		# todo: Index alphabetical
		push(@$field_set, $field);
		push(@$value_set, $value);
	}
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
