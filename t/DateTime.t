# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Weather-Com.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 10;
BEGIN { 
	use_ok('Weather::Com::DateTime');
};

my $testtime = 1109430000;

#########################

my $wc = Weather::Com::DateTime->new(-6);
$wc->set_lsup('02/25/05 11:21 PM Local Time');

isa_ok($wc, "Weather::Com::DateTime",    'Is a Weatcher::Com::DateTime object');

is($wc->time(),         "23:21",                    '24 hour time');
is($wc->time_ampm(),    "11:21 PM",                 'AM/PM mode');
is($wc->date(),         "25. February 2005",        'Long date format');
is($wc->day(),          "25",                       'Day Number');
is($wc->month(),        "February",                 'Name of month');
is($wc->mon(),          "02",                       'Number of month');
is($wc->year(),         "2005",                     'Year');
is(gmtime($wc->epoc()), 'Sat Feb 26 05:21:00 2005', 'GMTime');

