package Dictionary;
use Class::Interface;
&implements('iDictionary');

use strict;
use warnings;
use Data::Dumper;
use Tie::IxHash;

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
	
	print Dumper($t);
}

sub new {
	my $_type = shift;
	my $class = ref $_type || $_type;
	
	tie my %_self, 'Tie::IxHash';
	
	my $public = \%_self;
	
	bless $public, $class;
}

new Dictionary->add('1', '2', 1, 2, 1, 2, 3, 4, 3, 4, 5, 5, 6, 6);

1;