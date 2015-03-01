package Container;

# Object arround an array to make ref concrete
sub new {
	my $_type = shift;
	my $class = ref $_type || $_type;
	my $self = [];
	
	push($self, $_) for(@_);
	
	bless $self, $class;
	return $self;
}

return 1;
