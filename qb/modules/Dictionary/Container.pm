package Container;

# Just a blessed array-ref because ref needs to be concrete
sub new {
	my $_type = shift;
	my $class = ref $_type || $_type;
	my $self = [];
	
	push($self, $_) for(@_);
	
	bless $self, $class;
}

1;