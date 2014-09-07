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

	
The reason for making a custom dictionary object is any good SQL engine allows you to select the same column with multiple values.
Ala: select 1 as data, 2 as data from dual; (mysql, sqlite)

A hash would overwrite the second column,
So a dictionary object that allows multiple equal keys and indexes by key was created.

ExprDictionary is quite simply a dictionary with an additional layer of mapping.

expr_dict key => new dictionary