# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Weather-Com.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 6;
BEGIN { 
	use_ok('Weather::Com::Base');
};

#########################

my $wc = Weather::Com::Base->new();
isa_ok($wc, "Weather::Com::Base",    'Is a Weatcher::Com::Base object');

# Test static methods of Weather::Com::Base
is(&Weather::Com::Base::celsius2fahrenheit(20), 68, 'Celsius to Fahrenheit conversion');
is(&Weather::Com::Base::fahrenheit2celsius(68), 20, 'Fahrenheit to Celsius conversion');


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

