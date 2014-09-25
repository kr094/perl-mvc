package Dictionary;
use strict;
use warnings;
use Tie::IxHash;

use Class::Interface;
&implements('iDictionary');

use Container;

sub new {
	my $_type = shift;
	my $class = ref $_type || $_type;	
	tie my %self, 'Tie::IxHash';
	
	bless \%self, $class;
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
	my $key = undef;
	my $val = undef;
	
	while(@_) {
		$key = shift;
		$val = shift;
		
		if(exists $t->{$key}) {
			if(ref $t->{$key} eq 'Container') {
				push(@{$t->{$key}}, $val);
			} else {
				$t->{$key} = new Container($t->{$key}, $val);
			}
		} else {
			$t->{$key} = $val;
		}
	}
}

sub index_value {
	my $t = shift;
	return $t->_get_index([$t->values()], @_);
}

sub index_key {
	my $t = shift;
	return $t->_get_index([$t->keys()], @_);
}

sub _get_index {
	my $t = shift;
	my $array = shift;
	my $index = undef;
	my $curr_index = 0;
	my @values = ();
	
	while(@_) {
		$index = shift;
		
		for(@$array) {
			if($index == $curr_index) {
				push(@values, $_);
				$curr_index = 0;
				last;
			}
			
			++$curr_index;
		}
	}
	
	return @values;
}

sub key_value {
	my $t = shift;
	my $key = undef;
	my @get = ();
	
	while(@_) {
		$key = shift;
		
		if($key && exists $t->{$key}) {
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

