package Data;
use strict;
use warnings;
use DBI;

use lib '../modules/common';
use This;

sub new {
	my $_type = shift;
	my $_class = ref $_type || $_type;
	
	my $_self = {
		dbi => 'SQLite',
		dbname => 'kr094.db',
		dbh => undef,
		query => '',
		last_query => '',
		rows_affected => 0,
		result => undef,
		result_hash => undef,
		result_columns => undef,
		last_result => undef
	};
	
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
	
	# Public closure with access to this scope
	my $_public = sub {
		my $_m = shift;
		my $_v = '';
		if(@_) {
			$_set->($_m, @_);
			$_v = $_get->($_m);
		} else {
			$_v = $_get->($_m);
		}
		
		return $_v;
	};
	
	bless $_public, $_class;	
	return $_public;
}

# Public query method
sub query {
	my $t = t(\@_);
	my $query = shift;
	my $ret = 0;
	if(defined $query) {
		$t->('last_query', $t->('query'));
		$t->('query', $query);
		$ret = $t->_exec();
		$t->('rows_affected', $ret);
		$t->('result_hash', $t->_build_hash());
	}
	return $ret;
}

sub _get_col {
	my $t = t(\@_);
	my $hash = $t->('result_hash');
	my $col = shift;
	my $value = '';
	if(ref $hash eq "HASH"
	&& defined $col) {
		if(exists $hash->{$col}) {
			$value = $hash->{$col}
		} else {
			print "No column named $col\n";
		}
	} else {
		warn 'Access of no result';
	}
	return $value;
}

# Build a hash reference with columns and values
# This is what is returned to the querier
sub _build_hash {
	my $t = t(\@_);
	my @r = @{$t->('result')};
	my %hash;
	my $index = 0;
	for my $col (@{$t->('result_columns')}) {
		$hash{$col} = $r[$index];
		$index++;
	}
	return \%hash;
}

sub _exec {
	my $t = t(\@_);
	my $db = $t->_con();
	
	my $sth = $db->prepare($t->('query'));
	if(!$sth) {
		die("no statement");
	}
	
	my $ret = $sth->execute();
	$t->('last_result', $t->('result'));
	$t->('result', $sth->fetch());
	$t->('result_columns', $sth->{NAME});
	
	$sth->finish();
	$db = $t->_discon();
	return $ret;
}

sub _con {
	my $t = t(\@_);
	return $t->('dbh', DBI->connect(
		'dbi:' .$t->('dbi')
		.':dbname=' .$t->('dbname'),
		'',
		'',
		{ RaiseError => 1}
	));
}

sub _discon {
	my $t = t(\@_);
	my $db = $t->('dbh');
	$db->disconnect();
	return $t->('dbh', undef);
}

sub t {
	return This::t(@_, __PACKAGE__);
}

return 1;
