package Container;

# Just a blessed array-ref because ref needs to be concrete
sub new {
	my $_type = shift;
	my $class = ref $_type || $_type;
	my $self = [];
	
	for(@_) {
		push($self, $_);
	}
	
	bless $self, $class;
}

1;