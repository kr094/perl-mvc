package QueryFields;
use strict;
use warnings;

sub add_field {
	my $hash = shift;
	my $field = Trim::trim(shift);
	my $value = Trim::trim(shift);
	my $fields = $hash->{fields};
	my $values = $hash->{values};
	
	if(!$field) {
		$field = '';
	} elsif(!$value) {
		$value = '';
	}
	
	# If this key is already defined
	# Yank it out of the fields
	if(exists $values->{$field}) {
		yank($fields, $field);
		$values->{$field} = [$field];
	}
	
	# Put it on the end
	push(@$fields, $field);
		
	# Update the assoc value
	if(ref $values->{$field} eq 'ARRAY') {
		push($values->{$field}, $value);
	} else {
		$values->{$field} = $value;
	}
}

# Splice an element by value
sub yank {
	# Scalar reference to array
	my $fields = shift;
	my $field = shift;
	
	# (Number of scalars in)array or $array ref
	for(0 .. $#$fields) {
		if($field eq $fields->[$_]) {
			splice(@$fields, $_, 1);
			last;
		}
	}
}

sub new_field {
	return {
		fields => [],
		values => {}
	};
}

sub new_from {
	return {
		tables => [],
		join_tables => {} # Entries like table => join_on during a join
	};
}

sub join_on {
	return {
		join => 'inner',
		on => new_field()
	};
}

return 1;
