package Trim;

sub trim {
	my $trim = shift;
	
	$trim =~ s/^\s+//;
	$trim =~ s/\s+$//;
	
	return $trim;
}

return 1;
