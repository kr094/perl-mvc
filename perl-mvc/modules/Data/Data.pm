package Data;
use strict;
use warnings;
use DBI;

use lib('../modules/common');
use This;

sub new {
	my $_type = shift;
	my $_class = ref $_type || $_type;
	
	my $_self = {
		dbi => 'SQLite',
		dbname => '../data/kr094.db',
		dbh => undef,
		query => '',
		last_query => '',
		rows_affected => 0,
		result => [],
		result_columns => [],
		result_hash => {},
		last_result => undef
	};
	
	### Get / Set ###
	
	# Return a variable if the member is defined, the key exists, and it has been set
	my $_get = sub {
		my $_m = shift;
		my $_v = undef;
		
		if(defined $_m 
		&& exists $_self->{$_m} 
		&& defined $_self->{$_m}) {
			$_v = $_self->{$_m};
		}
		
		return $_v;
	};
	
	# Set a variable if there is a key for it
	my $_set = sub {
		my $_m = shift;
		
		if(exists $_self->{$_m}) {
			$_self->{$_m} = shift;
		}
	};
	
	my $_public = sub {
		my $_m = shift;
		my $_v = '';
		
		if(@_) {
			$_set->($_m, @_);
		}
		
		$_v = $_get->($_m);
		
		return $_v;
	};
	
	bless $_public, $_class;	
	return $_public;
}
	
### Private Subs ###

my $_con = sub {
	my $t = shift;
	
	return $t->('dbh', DBI->connect(
		'dbi:' .$t->('dbi') .':dbname=' .$t->('dbname'),
		'',
		'',
		{RaiseError => 1}
	));
};

my $_discon = sub {
	my $t = shift;
	
	$t->('dbh')->disconnect();
	
	return $t->('dbh', undef);
};

# Build a hash reference with columns and values
# This is what is returned to the querier
my $_build_hash = sub {
	my $t = shift;
	my @r = @{$t->('result')};
	my %hash;
	my $index = 0;
	
	# Loop through result columns
	for my $col (@{$t->('result_columns')}) {
		# Hash the result by column name
		$hash{$col} = $r[$index];
		$index++;
	}
	
	return \%hash;
};

# This method needs to have all its dependencies in scope
my $_exec = sub {
	my $t = shift;
	my $db = $_con->($t);
	my $sth = undef;
	my $ret = 0;
	
	$sth = $db->prepare($t->('query'));
	if(!$sth) {
		die('no statement');
	}
	
	$ret = $sth->execute();
	if(!$ret || !defined $ret) {
		$ret = 0;
	}
	
	$t->('rows_affected', $ret);
	$t->('last_result', $t->('result'));
	$t->('result', $sth->fetch());
	$t->('result_columns', $sth->{NAME});
	$t->('result_hash', $_build_hash->($t));
	
	$sth->finish();
	$db = $_discon->($t);
};

# Public methods #

sub query {
	my $t = t(\@_);
	my $query = shift;
	
	if(defined $query) {
		$t->('last_query', $t->('query'));
		$t->('query', $query);
		$_exec->($t);
	}
}

sub get_col {
	my $t = t(\@_);
	my $hash = $t->('result_hash');
	my $col = shift;
	my $value = '';
	
	if(ref $hash eq 'HASH'
	&& defined $col) {
		if(exists $hash->{$col}) {
			$value = $hash->{$col}
		} else {
			warn "No column named $col";
			$value = undef;
		}
	} else {
		$value = 'Access of no result';
		warn $value;
	}
	
	if(!$value) {
		$value = '';
	}
	
	return $value;
}

# Use This to ensure an object reference
sub t {
	return This::t(@_, __PACKAGE__);
}

return 1;
