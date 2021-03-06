use strict;
use warnings;
use autodie;
use Time::HiRes qw(time);
use Data::Dumper;

use lib('../modules/QueryBuilder');
use QueryBuilder;

my $q = new QueryBuilder();

sub test_select {
	$q->select('data as d', 'data2 as d, data3 as d', {data => 'x'});	
	return test('query');
}

sub test_where {
	$q->where('data >', 23)
		->where(1, 2, 3, 4)
		->where('kittens', undef)
		->where({hash => 'test'})
		->where({data => 'data', someData => 'newData'})
		->where({hash => 'update'}, {field => 'value'}, 'data', 'newData');
	return test('where');
}

sub test {
	my $which_hash = shift;	
	return $q->{$which_hash}->print();
}

sub run_test {
	my $start = time();
	my $test_result = 
	"Testing Query\n" 
	.$q->query() ."\n"
	."Testing Select\n"
	.test_select() ."\n"
	."Testing Where\n"
	.test_where() ."\n"
	."Completed in "
	.sprintf("%.3f", time() - $start)
	."ms";
	return $test_result;
}

sub print_dumper {
	my $print = '';
	for(@_) {	
		$print .= "$_\n" .Dumper($q->{$which_hash});
	}
	
	return $print;
}

sub quick_test {
	$q->select('data as d', 'data2 as d, data3 as d', {data => 'x'})
		->where('data like', '%data%')
		->from({table => 't'})
		# default being inner join no longer applies?
		->from({table2 => 'x'}, 'left')
		->where({'t.col' => 'x.col'});
		->from('table3', 'right')
		->where('t.col is', 'null');
	return print_dumper('from', 'join');
}

print quick_test();
#print for(@{$q->query()});