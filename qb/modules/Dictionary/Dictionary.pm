package Dictionary;
use strict;
use warnings;
use Tie::IxHash;
use Container;

our %CONFIG = (
	'append_on_dup_key' => 1
);

sub set_option {
	my ($option, $value) = @_;

	if(exists $CONFIG{$option}) {
		$CONFIG{$option} = $value;
	}
}

sub new {
	my $_type = shift;
	my $class = ref $_type || $_type;	
	tie my %hash, 'Tie::IxHash';
	my $self = \%hash;

	bless $self, $class;
	return $self;
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
	
	$size++ for($t->keys());
	
	return $size;
}

sub range {
	my $t = shift;
	return (0..$t->size());
}

sub value {
	my $t = shift;
	my @values = ();

	for my $key (@_) {
		if(exists $t->{$key}) {
			push(@values, $t->{$key});
		}
	}

	if(@values == 1) {
		return shift @values;
	}
	
	return @values;
}

sub key_at {
	my $t = shift;
	return _get_by_index([$t->keys()], @_);
}

sub value_at {
	my $t = shift;
	return _get_by_index([$t->values()], @_);
}

sub _get_by_index {
	my $array = shift;
	my @values = ();

	for my $index (@_) {
		if(exists $array->[$index]) {
			push(@values, $array->[$index])
		}
	}
	
	return @values;
}

sub add {
	my $t = shift;
	my ($key, $value, $ref);

	for my $item (@_) {
		$ref = ref $item;
		if($ref eq 'HASH') {
			for(CORE::keys %$item) {
				$key = $_;
				$value = $item->{$key};
				$t->_add_pair($key, $value);
			}
		} elsif($ref eq 'ARRAY') {
			for(@$item) {
				$key = $t->size();
				$value = $_;
				$t->_add_pair($key, $value);
			}
		} else {
			$key = $t->size();
			$value = $item;
			$t->_add_pair($key, $value);
		}
	}
}

sub _add_pair {
	my ($t, $key, $value) = @_;

	if($CONFIG{'append_on_dup_key'}) {
		if(exists $t->{$key}) {
			if(ref $t->{$key} eq 'Container') {
				
				# Append to this key's Container
				push(@{ $t->{$key} }, $value);
			} else {

				# Create a new Container with this value and the previous
				$t->{$key} = new Container($t->{$key}, $value);
			}
		} else {

			# Add new key
			$t->{$key} = $value;
		}
	} else {

		# Add or update
		$t->{$key} = $value;
	}
}

return 1;

