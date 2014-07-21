package ExprDictionary;
use lib('./');
use Dictionary;

sub new {
	return {
		expr => [],
		dict => Dictionary::new()
	}
}

sub add {
	my $expr = shift;
	my $field = shift;
	my $value = shift;
}

return 1;
