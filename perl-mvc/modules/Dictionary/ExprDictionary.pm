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
	
	if(!defined $expr) {
		$expr = '';
	}
	
	push(@$expr, $expr);
	$dict->push_dictionary($field, $value);
}

return 1;
