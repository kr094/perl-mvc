package ExprDictionary;
use Dictionary;
use Trim;

sub new {
	return bless {
		expr => [],
		dict => new Dictionary()
	}, shift;
}

sub add {
	my $expr_dict = shift;
	my $expr = Trim::trim(shift);
	my $field = Trim::trim(shift);
	my $value = Trim::trim(shift);
	
	my $expr = $expr_dict->{expr};
	my $dict = $expr_dict->{dict};
	
	if(!defined $expr) {
		$expr = '';
	}
	
	push(@$expr, $expr);
	$dict->push_dictionary($field, $value);
}

return 1;
