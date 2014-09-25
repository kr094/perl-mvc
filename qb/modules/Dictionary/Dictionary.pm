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

sub add {
	my $t = shift;
	my $key = '';
	my $val = '';
	my $temp = undef;
	
	while(@_) {
		$key = shift;
		$val = shift;
		
		if(exists $t->{$key}) {
			if(ref $t->{$key}) {
				push($t->{$key}, $val);
			} else {
				$temp = $t->{$key};
				$temp = [$temp, $val];
				$t->{$key} = $temp;
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
		
		for(keys %$t) {
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
	
	for(keys %$t) {
		++$size;
	}
	
	return $size;
}

sub count {
	my $t = shift;
	return $t->size() - 1;
}

1;

