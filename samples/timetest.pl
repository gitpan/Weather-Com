#!/usr/bin/perl

use strict;
use Weather::Com::DateTime;

my $date = Weather::Com::DateTime->new(-6);
$date->set_date('Feb 25');

my $time = Weather::Com::DateTime->new(-6);
$time->set_time('23:21');

my $lsup = Weather::Com::DateTime->new(-6);
$lsup->set_lsup('02/25/05 11:21 PM Local Time');

my $eichtest = Weather::Com::DateTime->new();
$eichtest->set_lsup('02/25/05 11:21 PM Local Time');

print "Date Test:\n";
print "Epoc:              ", $date->epoc(), "\n";
print "GMTime:            " . gmtime( $date->epoc() ) . "\n";
print "German local time: " . localtime( $date->epoc() ) . "\n";
print "Today is ", $date->date(), "\n\n";

print "Time test:\n";
print "Epoc:              ", $time->epoc(), "\n";
print "GMTime:            " . gmtime( $time->epoc() ) . "\n";
print "German local time: " . localtime( $time->epoc() ) . "\n";
print "It's ",   $time->time(),      " o'clock\n";
print "That's ", $time->time_ampm(), " in US form...\n\n";

print "And a full date and time test:\n";
print "Epoc:              ", $lsup->epoc(), "\n";
print "GMTime:            " . gmtime( $lsup->epoc() ) . "\n";
print "German local time: " . localtime( $lsup->epoc() ) . "\n";
print "It's ", $lsup->time(), " o'clock at ", $lsup->date(), "\n\n";

print "And an eich test in GMT:\n";
print "Epoc:              ", $eichtest->epoc(), "\n";
print "GMTime:            " . gmtime( $eichtest->epoc() ) . "\n";
print "German local time: " . localtime( $eichtest->epoc() ) . "\n";
print "It's ", $lsup->time(), " o'clock at ", $eichtest->date(), "\n";


print "\n\n\n";

my $gmt_offset = 1;    # e.g. for Germany in winter
my $datetime = Weather::Com::DateTime->new($gmt_offset);
$datetime->set_lsup('02/25/05 11:21 PM Local Time');

print "This is the date '02/25/05 11:21 PM' in Germany:\n";
print "Epoc:                    ", $datetime->epoc(), "\n";
print "GMT (UTC):               " . gmtime( $datetime->epoc() ) . "\n";
print "My local time:           " . localtime( $datetime->epoc() ) . "\n";
print "And finally German time: ", $datetime->time(), " o'clock at ",
  $datetime->date(), "\n\n";


