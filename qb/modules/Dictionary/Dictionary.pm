package Dictionary;
use Class::Interface;
&implements('iDictionary');

use strict;
use warnings;
use Tie::IxHash;

sub new {
	my $_type = shift;
	my $class = ref $_type || $_type;
	
	tie my %_self, 'Tie::IxHash';
	
	my $public = \%_self;
	
	bless $public, $class;
}

sub keys {
	my $t = shift;
	return keys %$t;
}

sub values {
	my $t = shift;
	return values %$t;
}

sub add {
	my $t = shift;
	my $key = '';
	my $val = '';
	
	while(@_) {
		$key = shift;
		$val = shift;
		
		if(exists $t->{$key}) {
			if(ref $t->{$key}) {
				push($t->{$key}, $val);
			} else {
				$t->{$key} = [$t->{$key}, $val];
			}
		} else {
			$t->{$key} = $val;
		}
	}
	
	return $t;
}

sub get_index {
	my $t = shift;
	my $index = 0;
	my $curr_index = 0;
	my @get = ();
	
	while(@_) {
		$index = shift;
		
		for($t->keys()) {
			if($curr_index == $index) {
				push(@get, $_);
				$curr_index = 0;
				last;
			}
			
			++$curr_index;
		}
	}
	
	return @get;
}

sub get_key {
	my $t = shift;
	my $key = '';
	my @get = ();
	
	while(@_) {
		$key = shift;
		
		if($key
		&& exists $t->{$key}) {
			push(@get, $t->{$key});
		}
	}
	
	return @get;
}

sub size {
	my $t = shift;
	my $size = 0;
	
	for($t->keys()) {
		++$size;
	}
	
	return $size;
}

sub count {
	my $t = shift;
	return $t->size() - 1;
}

1;

