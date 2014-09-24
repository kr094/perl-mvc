package Data;
use strict;
use warnings;
use DBI;

use lib('../modules/common', '../modules/Dictionary');
use This;
use Dictionary;

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
		result_dict => undef,
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

# Build object for result access
my $_build_result = sub {
	my $t = shift;
	my @r = @{$t->('result')};
	my $dict = new Dictionary();
	my $index = 0;
	
	# Loop through result columns
	for(@{$t->('result_columns')}) {
		$dict->add($_, $r[$index]);
		$index++;
	}
	
	return $dict;
};

# This method needs to have all its dependencies in scope
my $_exec = sub {
	my $t = shift;
	my $db = $_con->($t);
	my $sth = undef;
	my $ret = 0;
	
	$sth = $db->prepare($t->('query'));
	
	if($sth) {	
		$ret = $sth->execute();
		if(!$ret) {
			$ret = 0;
		}
		
		$t->('rows_affected', $ret);
		$t->('last_result', $t->('result'));
		$t->('result', $sth->fetch());
		$t->('result_columns', $sth->{NAME});
		$t->('result_dict', $_build_result->($t));
	}
	
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
	my $dict = $t->('result_dict');
	my $col = shift;
	my $value = '';
	
	if($dict->count() > 0) {
		if($dict->in($col)) {
			$value = $dict->get($col);
		} else {
			warn "No column named $col\n";
		}
	} else {
		warn "Empty result set\n";
	}
	
	return $value;
}

# Use This to ensure an object reference
sub t {
	return This::t(@_, __PACKAGE__);
}

return 1;
