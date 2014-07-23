package Dictionary;
use ArrayHelpers;
use Trim;

sub new {
	my $class = shift;
	my $field = shift;
	my $value = shift;
	
	my $_self = {
		field => [],
		value => []
	};
	
	bless $_self, $class;
	
	if(defined $field && $field ne '') {
		$_self->add($field, $value);
	}
	
	return $_self;
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
	
	if(ArrayHelpers::in($field_set, $field)) {
		$dict->splice_dictionary($field, $value);
	} else {
		# todo: Index alphabetical
		$dict->push_dictionary($field, $value);
	}
}

sub push_dictionary {
	my $dict = shift;
	my $field = shift;
	my $value = shift;
	my $field_set = $dict->{field};
	my $value_set = $dict->{value};
	
	if(!defined $field) {
		$field = '';
	} elsif(!defined $value) {
		$value = '';
	}

	push(@$field_set, $field);
	push(@$value_set, $value);
}

# Indexed by unique field
sub splice_dictionary {
	my $dict = shift;
	my $field = shift;
	my $value = shift;
	my $field_set = $dict->{field};
	my $value_set = $dict->{value};
	
	# Walk array backwards 
	# Find the last index for this field
	# Splice in the new value
	
	# Perl does not support high .. low
	for(reverse 0 .. $#$field_set) {
		if($field eq $field_set->[$_]) {
			splice($field_set, $_ + 1, 0, $field);
			splice($value_set, $_ + 1, 0, $value);
			last;
		}
	}	
}

sub print {
	my $dict = shift;
	my $fields = $dict->{field};
	my $values = $dict->{value};
	my $field;
	my $value;
	my $print = "";
			
	for(keys $fields) {
		$field = $fields->[$_];
		$value = $values->[$_];		
		$print .= "$field => $value\n";
	}
	
	return $print;
}

return 1;
