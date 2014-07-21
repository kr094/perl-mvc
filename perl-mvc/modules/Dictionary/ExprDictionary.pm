package ExprDictionary;
use Dictionary;

sub new {
	return bless {
		expr => [],
		dict => new Dictionary()
	}, shift;
}

sub add {
	my $new_expr = shift;
	my $new_field = shift;
	my $new_value = shift;
}

return 1;
