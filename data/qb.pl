use strict;
use warnings;
use lib './';
use QueryBuilder;

my $q = new QueryBuilder();

sub test_select {
	print "Testing Select\n";
	$q->select('data')
		->select({data => 'alias'})
		->select('dog')
		->select('data as newAlias')
		->select('1 as num1', '2 as num2')
		->select('3 as num3, 4 as num4')
		->select({5 => 'num5', 6 => 'num6'})
		->select({7 => 'num7'}, {8 => 'num8'})
		->select({'SQLITE_VERSION()' => 'version'});
		
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
test_where();
