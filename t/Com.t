# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Weather-Com.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 6;
BEGIN { 
	use_ok('Weather::Com');
};

#########################

my $wc = Weather::Com->new();
isa_ok($wc, "Weather::Com",    'Is a Weatcher::Com object');

# Test static methods of Weather::Com
is(&Weather::Com::celsius2fahrenheit(20), 68, 'Celsius to Fahrenheit conversion');
is(&Weather::Com::fahrenheit2celsius(68), 20, 'Fahrenheit to Celsius conversion');


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

