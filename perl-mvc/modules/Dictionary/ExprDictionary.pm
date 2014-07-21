package ExprDictionary;
use Dictionary;

sub new {
	return bless {
		expr => [],
		dict => new Dictionary()
	}, shift;
}

sub add {
	my $expr_dict = shift;
	my $expr = shift;
	my $field = shift;
	my $value = shift;
	
	my $expr = $expr_dict->{expr};
	my $dict = $expr_dict->{dict};
	my $field_set = $dict->{field};
	my $value_set = $dict->{value};
	
	if(!defined $expr) {
		$expr = '';
	}
	
	push(@$expr, $expr);
	$dict->push($field_set, $value_set, $field, $value);
	
}

return 1;
