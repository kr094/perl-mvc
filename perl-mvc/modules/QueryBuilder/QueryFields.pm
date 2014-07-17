package QueryFields;
use strict;
use warnings;

sub new_field {
	return {
		fields => [],
		values => {}
	};
}

sub new_from {
	return {
		tables => [],
		join_tables => {} # Entries like table => join_on during a join
	};
}

sub join_on {
	return {
		join => 'inner',
		on => new_field()
	};
}

return 1;
