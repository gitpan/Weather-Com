# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Weather-Com.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;
BEGIN { 
	use_ok('Weather::Cached');
};

#########################

my $wc = Weather::Cached->new();
isa_ok($wc, "Weather::Cached", 'Is a Weatcher::Cached object');
isa_ok($wc, "Weather::Com",    'Is a Weatcher::Com object');

# test search method
my $heidelberg_locs = {
        'GMXX0053' => 'Heidelberg, Germany',
        'USKY0990' => 'Heidelberg, KY',
        'USMS0154' => 'Heidelberg, MS'
};
is_deeply($wc->search('Heidelberg'), $heidelberg_locs, 'Look for locations named Heidelberg');

my $nuernberg_locs = {
		'GMXX0096' => 'Nurnberg, Germany'
};
is_deeply($wc->search('Nürnberg'), $nuernberg_locs, 'Check if Umlaut-search does work');
