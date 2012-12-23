#####################################################################
#
#  Test suite for 'Weather::Com::Cached'
#
#  Testing network connection (without proxy).
#  Functional tests with 'Test::MockObject'. These could only be run
#  if Test::MockObject is installed.
#
#  Before `make install' is performed this script should be runnable
#  with `make test'. After `make install' it should work as
#  `perl t/Cached.t'
#
#####################################################################
#
# initialization
#
no warnings;
use Test::More tests => 10;
require 't/TestData.pm';

BEGIN {
	use_ok('Weather::Com::Cached');
}

#####################################################################
#
# Testing object instantiation (do we use the right class)?
#
my %weatherargs = (
					'debug'    => 0,
					'language' => 'en',
);    

my $wc = Weather::Com::Cached->new(%weatherargs);
isa_ok( $wc, "Weather::Com::Cached", 'Is a Weatcher::Com::Cached object' );
isa_ok( $wc, "Weather::Com::Base",   'Is a Weatcher::Com::Base object' );

#
# Test functionality if Test::MockObject is not installed.
#
SKIP: {
	eval { require Test::MockObject; };
	skip "Test::MockObject not installed", 3 if $@;

    # remove old cache files, if any
    # (This used to remove all *.dat files so we might miss something now.)
    unlink 'locations.dat' if ( -e 'locations.dat');
    unlink 'm_USNY0998.dat' if ( -e 'm_USNY0998.dat');

    # Make sure there aren't any extra cache files at the start
    my @cache_files_start = glob "*.dat";
    is($#cache_files_start, -1, "No unexpected inital cache files") or
        diag("Found pre-existing cache files @cache_files_start");

	# define mock object
	my $mock = Test::MockObject->new();
	$mock->fake_module( 'LWP::UserAgent' =>
					   ( 'request' => sub { return HTTP::Response->new() }, ) );
	$mock->fake_module(
						'HTTP::Response' => (
										   'is_success' => sub { return 1 },
										   'content' => sub { return $NY_HTML },
						)
	);
	$mock->fake_module(
		'Weather::Com::Cached' => ( '_cache_time' => sub { return 1110000000 } ) );

	# test search method
	is_deeply( $wc->search('New York'),
			   $NY_Hash, 'Look for locations named "New York"' );

	# search for 'New York/Central Park, NY' to check locations cache
	my $NYCP = { 'USNY0998' => 'New York/Central Park, NY', };

	is_deeply( $wc->search('New York/Central Park, NY'),
			   $NYCP, 'Check locations cache' );

	$mock->fake_module(
						'HTTP::Response' => (
										 'is_success' => sub { return 1 },
										 'content' => sub { return $NYCP_HTML },
						)
	);

	is_deeply( $wc->get_weather('USNY0998'),
			   $NYCP_HashCached,
			   'Look for weather data for "New York/Central Park, NY"' );

    # Make sure we created two cache files (used by later tests)
    ok( -e 'locations.dat',  'locations.dat cache file created');
    ok( -e 'm_USNY0998.dat', 'm_USNY0998.dat cache file created');

    # Make sure there aren't any extra cache files left over
    my @cache_files_final = glob "*.dat";
    is($#cache_files_final, 1, "No unexpected final cache files") or
        diag("cache files found: @cache_files_final (only expected 2)");

}
