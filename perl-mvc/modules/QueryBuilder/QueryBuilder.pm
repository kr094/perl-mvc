package QueryBuilder;
use strict;
use warnings;

use lib('../modules/common', '../modules/Data/');
use Data;
use QueryFields;
use Trim;

sub new {	
	my $_type = shift;
	my $_class = ref $_type || $_type;
	
	my $_self = {
		_data => new Data(),
		select => QueryFields::new_field(),
		where => QueryFields::new_field(),
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
	my $ref;	
	
	$t->{type} = 'select';
	
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
	my $query = undef;
	my $field = '';
	my $value = '';
	
	while(@_) {
		$query = shift;
		
		if(ref $query eq 'HASH') {
			build_from_hash($hash, $query);
		} else {		
			$field = $query;
			$value = shift;
			QueryFields::add_field($hash, $field, $value);
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
		QueryFields::add_field($hash, $_, $value);
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
	
	QueryFields::add_field($hash, $field, $value);
}

sub query {
	my $t = shift;
	my $data = $t->{_data};
	$data->query('SELECT SQLITE_VERSION() as version');
	print $data->get_col('version') ."\n";
}

sub test {
	my $t = shift;
	my $hash = shift;
	my $fields = $hash->{fields};
	my $values = $hash->{values};
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
