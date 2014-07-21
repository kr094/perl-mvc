package QueryFields;
use strict;
use warnings;

# This is basically a manual dictionary
sub add_field {
	my $hash = shift;
	my $field = Trim::trim(shift);
	my $value = Trim::trim(shift);
	my $fields = $hash->{fields};
	my $values = $hash->{values};
	
	if(!defined $field) {
		$field = '';
	} elsif(!defined $value) {
		$value = '';
	}
	
	if(in_array($fields, $field)) {
		splice_by_field($fields, $values, $field, $value);
	} else {
		# todo: Index alphabetical
		push(@$fields, $field);
		push(@$values, $value);
	}
}

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

# Each unique field gets its own index
sub splice_by_field {
	my $fields = shift;
	my $values = shift;
	my $field = shift;
	my $new_value = shift;
	
	# Perl does not support high .. low
	for(reverse 0 .. $#$fields) {
		if($field eq $fields->[$_]) {
			splice($fields, $_ + 1, 0, $field);
			splice($values, $_ + 1, 0, $new_value);
			last;
		}
	}	
}

sub new_field {
	return {
		fields => [],
		values => []
	};
}

# If theres more than one from field, start adding/reading join_ons..?
sub new_from {
	return {
		from => new_field(),
		join_on => new_join_on()
	};
}

sub new_join_on {
	return {
		joins => [],
		on => new_field()
	};
}

return 1;
