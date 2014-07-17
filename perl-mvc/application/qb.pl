use strict;
use warnings;

use lib('../modules/QueryBuilder');
use QueryBuilder;

my $q = new QueryBuilder();

sub test_select {
	print "Testing Select\n";
	$q->select('data as alias')
		->select('data as newAlias');
		
	test('select');
}

sub test_where {
	print "\nTesting Where\n";
	$q->where('data', 'id')
		->where(1, 2, 3, 4)
		->where('kittens', undef)
		->where({hash => 'test'})
		->where({data => 'data', someData => 'newData'})
		->where({hash => 'update'}, {field => 'value'}, 'data', 'update2');
	test('where');
}

sub test {
	my $which_hash = shift;	
	$q->test($q->{$which_hash});
}

$q->query();
test_select();
