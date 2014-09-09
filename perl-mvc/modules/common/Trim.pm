package Trim;

sub trim {
	my $string = shift;
	my $trim = $string;
	
	if($string =~ s/^\s+(.+?)\s+$/$1/s) {
		$trim = $string;
	}
	
	return $trim;
}

return 1;
