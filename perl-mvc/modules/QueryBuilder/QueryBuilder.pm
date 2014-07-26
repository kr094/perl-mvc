package QueryBuilder;
use strict;
use warnings;

use lib('../modules/common', '../modules/Data', '../modules/Dictionary');
use Data;
use Dictionary;
use ExprDictionary;
use Trim;

sub new {	
	my $_type = shift;
	my $_class = ref $_type || $_type;
	
	my $_self = {
		_data => new Data(),
		_last_call => '',
		select => new Dictionary(),
		where => new ExprDictionary(),
		from => new Dictionary(),
		# join => {
			# join => [],
			# on => new ExprDictionary()
		# },
		join => new Dictionary(),
		type => '',
		limit => 0
	};
	
	bless $_self, $_class;
	return $_self;
}

sub route {
	my @array = shift;
	my $dict = shift;
	my $ref;
	
	for(@array) {
		$ref = ref;
		if($ref eq 'HASH') {
			build_from_dict($dict, $_);
		} elsif($ref eq '') {
			build_select($dict, $_);
		}
	}
}

sub select {
	my $t = shift;
	my $dict = $t->{select};
	$t->{_last_call} = 'select';
	$t->{type} = 'select';	
	
	route(@_, $dict);
	
	return $t;
}

sub from {
	my $t = shift;
	$t->{_last_call} = 'from';
	my $table = shift;
	my $join = shift;
	my $field;
	my $alias;
	my @split = ();
	my $ref;
	
	$ref = ref $table;
	
	if($ref eq 'HASH') {
		for(keys $table) {
			$alias = $table->{$_};
			$t->build_from($_, $alias, $join);
		}
	} else {
		@split = parse_equality($table, '');	
		$field = shift @split;
		$alias = shift @split;
		$t->build_from($field, $alias, $join);
	}
	
	return $t;
}

sub build_from {
	my $t = shift;
	my $dict = $t->{from};
	my $table = shift;
	my $alias = shift;
	my $join = shift;	
	
	if($dict->count() > 0) {
		$t->join($join);
	}

	$dict->push_dictionary($table, $alias);	
}

sub join {
	my $t = shift;
	my $join = shift;
	my $dict = $t->{join};
	$t->{_last_call} = 'join';
	
	if(!defined $join || $join eq '') {
		$join = 'inner';
	}
	
	$dict->push_dictionary($join, '');
}

sub build_join {
	my $t = shift;
	my $dict = $t->{join};
	my $expr = shift;
	my $value = '';
	
	for(0 .. $dict->count()) {
		$value = $dict->{value}[$_];
		if($value eq '') {
			$dict->{value}[$_] = $expr;
			last;
		}
	}
}

sub where {
	my $t = shift;
	my $last = $t->{_last_call};
	my $dict = undef;
	my $query = undef;
	my $ref;
	my $field = '';
	my $value = '';
	my $equality = '';
	my $join = '';
	my @split = ();
	
	if($last eq 'select') {
		$dict = $t->{where};
	} elsif($last eq 'join') {
		$dict = new ExprDictionary();
	} elsif($last eq 'from') {
		return $t;
	}
	
	while(@_) {
		$query = shift;
		$ref = ref $query;
		
		if($ref eq 'HASH') {
			for(keys $query) {
				$value = $query->{$_};
				
				@split = parse_equality($_, '=');
				$field = shift @split;
				$equality = shift @split;
				$dict->add($equality, $_, $value);
			}
		} else {		
			$field = $query;
			$value = shift;
			
			@split = parse_equality($field, '=');
			$field = shift @split;
			$equality = shift @split;
			$dict->add($equality, $field, $value);
		}
		
		if($last eq 'join') {
			$t->build_join($dict);
		}
	}
	
	return $t;
}

sub limit {

}

sub get {

}

sub parse_equality {
	my $field = Trim::trim(shift);
	my $default = shift;
	my @split = ();
	
	if(!defined $default || !$default) {
		$default = '';
	}
	
	if($field =~ /\s+/) {
		@split = split(/\s+/, $field, 2);
	} else {
		push(@split, $field, $default);
	}
	
	return @split;
}

sub build_select {
	my $dict = shift;
	my $query = shift;
	my @strings = ();
	
	if($query =~ /\s*,\s+/) {
		@strings = split(/\s*,\s+/, $query);
	} else {
		push(@strings, $query);
	}
	
	for(@strings) {
		split_select($dict, $_);
	}
}

sub split_select {
	my $dict = shift;
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
	
	$dict->add($field, $value);
}

sub query {
	my $t = shift;
	my $data = $t->{_data};
	$data->query('SELECT SQLITE_VERSION() as version');
	return $data->get_col('version') ."\n";
}

return 1;
