package QueryBuilder;
use strict;
use warnings;

use lib '../modules/common';
use Data;
use Trim;

sub new {	
	my $_type = shift;
	my $_class = ref $_type || $_type;
	
	my $_self = {
		_data => new Data(),
		select => new_field(),
		where => new_field(),
		type => '',
		from => '',
		limit => 0
	};
	
	bless $_self, $_class;
	return $_self;
}

sub select {
	my $t = shift;
	my $hash = $t->{select};
	$t->{type} = 'select';
	my $ref;
	
	for(@_) {
		$ref = ref;
		if($ref eq 'HASH') {
			build_from_hash($hash, $_);
		} elsif($ref eq '') {
			build_select($hash, $_);
		}
	}
	
	return $t;
}

sub where {
	my $t = shift;
	my $hash = $t->{where};
	my $field = '';
	my $value = '';
	
	while(@_) {
		my $query = shift;
		
		if(ref $query eq 'HASH') {
			build_from_hash($hash, $query);
		} else {		
			$field = $query;
			$value = shift;
			add_field($hash, $field, $value);
		}
	}
	
	return $t;
}

sub build_from_hash {
	my $hash = shift;
	my $query = shift;
	my $value;
	
	for(keys $query) {
		$value = $query->{$_};
		add_field($hash, $_, $value);
	}
}

sub build_select {
	my $hash = shift;
	my $query = shift;
	my @strings = ();
	
	if($query =~ /\s*,\s+/) {
		@strings = split(/\s*,\s+/, $query);
	} else {
		push(@strings, $query);
	}
	
	for(@strings) {
		split_select($hash, $_);
	}
}

sub split_select {
	my $hash = shift;
	my $query = shift;
	my $field = '';
	my $value = '';
	
	if($query =~ /as/) {
		my @split = split(/\s+as\s+/, $query, 2);
		$field = shift @split;
		$value = shift @split;
	} else {
		$field = $query;
	}
	
	add_field($hash, $field, $value);
}

sub add_field {
	my $hash = shift;
	my $field = Trim::trim(shift);
	my $value = Trim::trim(shift);
	my $fields = $hash->{fields};
	my $values = $hash->{values};
	
	if(!$field) {
		$field = '';
	} elsif(!$value) {
		$value = '';
	}
	
	# If this key is already defined
	# Yank it out of the fields
	if(exists $values->{$field}) {
		yank($fields, $field);
	}
	
	# Put it on the end
	push(@$fields, $field);
	
	# Update the assoc value
	$values->{$field} = $value;
}

# Splice an element by value
sub yank {
	# Scalar reference to array
	my $fields = shift;
	my $field = shift;
	
	# (Number of scalars in)array or $array ref
	for(0 .. $#$fields) {
		if($field eq $fields->[$_]) {
			splice(@$fields, $_, 1);
			last;
		}
	}
}

sub new_field {
	return {
		fields => [],
		values => {}
	}
}

sub query {
	my $t = shift;
	my $data = $t->{_data};
	$data->query('SELECT SQLITE_VERSION() as version');
	print $data->_get_col('version') ."\n";
}

sub test {
	my $t = shift;
	my $hash = shift;
	my $fields = $hash->{fields};
	my $values = $hash->{values};
	my $value;
	
	for(values $fields) {
		$value = $values->{$_};
		print "$_ => $value\n";
	}
}

return 1;
