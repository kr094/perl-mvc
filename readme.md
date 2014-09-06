This repo is called perl-mvc
It should be called QueryBuilder as that's what's here

This is my take on active record in perl
Data/Data.pm uses full encapsulation, enforced object reference, and private subs

application/qb.pl to run

Syntax:

// Supports a bunch of ways to input arguments
select('field', 'field3 as field3, field4 as field4', {field5 => 'field5'})
	// This is the usual where, applied to the entire query
	// Called after select, just like active record
	->where('field', 'clause')
	->where('field', 'clause')
	->or('field', 'clause')
	// From a single table
	->from('table')
	// From, with a join condition
	->from('table2', 'inner')
	// Heres where it gets interesting
	// Where is called again, knowing that 'join' was just called
	// So it selects the join dictionary when it builds its generic equality statement
	->where('table.x', 'table2.x')
	// From is used as the control of which join dictionary to grab
	// Because of this it can only be called with one table at a time, unlike all other methods