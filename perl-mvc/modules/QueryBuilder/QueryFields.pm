package QueryFields;
use strict;
use warnings;

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

return 1;
