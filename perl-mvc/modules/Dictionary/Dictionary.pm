package Dictionary;
use lib('./');
use Helpers;

sub new {
	my $type = shift;
	my $class = ref $type || $type;
	
	return bless {
		field => [],
		value => []
	}, $class;
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
		Helpers::splice_by_field($field_set, $value_set, $field, $value);
	} else {
		# todo: Index alphabetical
		push(@$field_set, $field);
		push(@$value_set, $value);
	}
}

return 1;
