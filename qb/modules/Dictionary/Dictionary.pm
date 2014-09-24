package Dictionary;
use strict;
use warnings;

use lib('../modules/common');
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
	
	if(defined $field) {
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
	
	if(!$field) {
		$field = '';
	} elsif(!$value) {
		$value = '';
	}
	
	if(ArrayHelpers::in($field_set, $field)) {
		$dict->splice_dictionary($field, $value);
	} else {
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
	for(reverse 0 .. $dict->count()) {
		if(exists $field_set->[$_] && $field eq $field_set->[$_]) {
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
		$print .= "$field => ";
		
		if(ref $value eq 'ExprDictionary') {
			$print .= $value->print();
		} else {
			$print .= "$value\n";
		}
	}
	
	return $print;
}

sub get {
	my $t = shift;
	my $field = shift;
	my $field_set = $t->{field};
	my $value_set = $t->{value};
	my $values = [];
	my $index = 0;
	my $count = 0;
	
	for(values $field_set) {
		if($_ eq $field) {
			push(@$values, $value_set->[$index]);
			$count++;
		}
		
		$index++;
	}
	
	return $values;
}

sub in {
	my $t = shift;
	my $field = shift;
	my $field_set = $t->{field};
	my $in = 0;
	
	for(values $field_set) {
		if($_ eq $field) {
			$in = 1;
			last;
		}
	}
	
	return $in;
}

sub get_field {
	my $t = shift;
	my $index = shift;
	my $dict = $t->{field};
	
	return get_by_index($dict, $index);
}

sub get_value {
	my $t = shift;
	my $index = shift;
	my $dict = $t->{value};
	
	return get_by_index($dict, $index);
}

sub get_by_index {
	my $dict = shift;
	my $index = shift;
	my $value = '';
	
	if(defined $dict->[$index]) {
		$value = $dict->[$index];
	}
	
	return $value;
}

sub count {
	my $t = shift;
	my $array = $t->{field};
	my $count = 0;
	
	for(keys $array) {
		$count++;
	}
	
	return $count;
}

return 1;
