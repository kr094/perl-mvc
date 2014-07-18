use strict;
use warnings;

use lib('../modules/QueryBuilder');
use QueryBuilder;

my $q = new QueryBuilder();

sub test_select {
	print "Testing Select\n";
	$q->select('data, data, data');
		
	test('select');
}

sub test_where {
	print "\nTesting Where\n";
	$q->where('data', 'id')
		->where(1, 2, 3, 4)
		->where('kittens', undef)
		->where({hash => 'test'})
		->where({data => 'data', someData => 'newData'})
		->where({hash => 'update'}, {field => 'value'}, 'data', 'newData');
	test('where');
}

sub test {
	my $which_hash = shift;	
	print $q->test($q->{$which_hash});
}

$q->query();
test_select();
test_where();
