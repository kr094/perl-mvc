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
		select => new Dictionary(),
		where => new ExprDictionary(),
		from => {
			from => new Dictionary(),
			join => new ExprDictionary()
		},
		type => '',
		limit => 0
	};
	
	bless $_self, $_class;
	return $_self;
}

sub select {
	my $t = shift;
	my $dict = $t->{select};
	my $ref;	
	
	$t->{type} = 'select';
	
	for(@_) {
		$ref = ref;
		if($ref eq 'HASH') {
			build_from_dict($dict, $_);
		} elsif($ref eq '') {
			build_select($dict, $_);
		}
	}
	
	return $t;
}

sub where {
	my $t = shift;
	my $dict = $t->{where};
	my $query = undef;
	my $field = '';
	my $value = '';
	my $equality = '';
	
	while(@_) {
		$query = shift;
		
		if(ref $query eq 'HASH') {
			build_from_dict($dict, $query);
		} else {		
			$field = $query;
			$value = shift;
			
			$equality = parse_equality($field);
			$dict->add($equality, $field, $value);
		}
	}
	
	return $t;
}

sub build_from_dict {
	my $dict = shift;
	my $query = shift;
	my $value;
	
	for(keys $query) {
		$value = $query->{$_};
		$dict->add($_, $value);
	}
}

sub parse_equality {
	my $field = Trim::trim(shift);
	my @split = ();
	my $equality = '=';
	
	if($field =~ /[<>=]/) {
		@split = split(/\s+/, $field, 2);
		$equality = $split[1];
	}
	
	return $equality;
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

sub test {
	my $t = shift;
	my $dict = shift;
	my $fields = $dict->{field};
	my $values = $dict->{value};
	my $field;
	my $value;
	my $test_result = "";
			
	for(keys $fields) {
		$field = $fields->[$_];
		$value = $values->[$_];		
		$test_result .= "$field => $value\n";
	}
	
	return $test_result;
}

return 1;
