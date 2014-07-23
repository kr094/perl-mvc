package QueryBuilder;
use strict;
use warnings;

use lib('../modules/common', '../modules/Data', '../modules/Dictionary');
use Data;
use Dictionary;
use ExprDictionary;
use Trim;
use Data::Dumper;

sub new {	
	my $_type = shift;
	my $_class = ref $_type || $_type;
	
	my $_self = {
		_data => new Data(),
		select => new Dictionary(),
		where => new ExprDictionary(),
		from => new Dictionary(),
		join => new Dictionary(),
		_andor => new Dictionary(),
		type => '',
		limit => 0
	};
	
	my $ad = new Dictionary('and', 'value');
	$ad->nest();
	print Dumper($ad);
	$_self->{_andor}->add('where', $ad);
	
	#print Dumper($_self);
	
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
	my @split = ();
	
	while(@_) {
		$query = shift;
		
		if(ref $query eq 'HASH') {
			for(keys $query) {
				$value = $query->{$_};
				
				@split = parse_equality($_);
				$field = shift @split;
				$equality = shift @split;
				$dict->add($equality, $_, $value);
			}
		} else {		
			$field = $query;
			$value = shift;
			
			@split = parse_equality($field);
			$field = shift @split;
			$equality = shift @split;
			$dict->add($equality, $field, $value);
		}
	}
	
	return $t;
}

sub parse_equality {
	my $field = Trim::trim(shift);
	my @split = ();
	
	if($field =~ /[<>=]/) {
		@split = split(/\s+/, $field, 2);
	} else {
		push(@split, $field, '=');
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
