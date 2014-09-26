package Dictionary;
use strict;
use warnings;
use Class::Interface;
use Tie::IxHash;

use Container;
&implements('iDictionary');

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

sub size {
	my $t = shift;
	my $size = 0;
	
	++$size for($t->keys());
	
	return $size;
}

sub count {
	my $t = shift;
	return $t->size() - 1;
}

sub add {
	my $t = shift;
	my $key = undef;
	my $val = undef;
	
	while(@_) {
		$key = shift;
		
		if(ref $key eq 'HASH') {
			for(CORE::keys %$key) {
				$val = $key->{$_};
				
				if(!$val) {
					$val = $_;
					$key = $t->size();
				} else {
					$key = $_;
				}
				
				$t->_add_pair($key, $val);
			}
		} else {
			$t->_add_pair($t->size(), $key);
		}
	}
}

sub key_value {
	my $t = shift;
	my $key = undef;
	my @values = ();
	
	while(@_) {
		$key = shift;
		
		if($key && exists $t->{$key}) {
			push(@values, $t->{$key});
		}
	}
	
	return @values;
}

sub index_value {
	my $t = shift;
	return _get_index([$t->values()], @_);
}

sub index_key {
	my $t = shift;
	return _get_index([$t->keys()], @_);
}

sub _get_index {
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

sub _add_pair {
	my $t = shift;
	my $key = shift;
	my $val = shift;	
		
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

1;

