package Weather::Com::Wind;

#
# !!!DO NOT USE WARNINGS!!! this will cause Class::Struct to tell you
# that direction_long() is redefined - what is true, but wanted!
#

use 5.006;
use strict;
use Class::Struct;
use Weather::Com::Base qw(convert_winddirection);

our $VERSION = sprintf "%d.%03d", q$Revision: 1.4 $ =~ /(\d+)/g;

#------------------------------------------------------------------------
# The wind class will not be a Weather::Cached class by itself, because
# then it would not be easy to now whether it is current conditions wind
# or forecast wind and if forecast wind, then of which day, etc.
#
# Weather::Com::Wind consists almost only of pure data and no
# significant logic has to be build in. Therefore, we simply use a
# Class::Struct subclass.
#------------------------------------------------------------------------
struct(
	'Weather::Com::Wind',
	{
	   speed             => '$',
	   maximum_gust      => '$',
	   direction_degrees => '$',
	   direction_short   => '$',
	   direction_long    => '$',
	}    
);

#------------------------------------------------------------------------
# update wind data
#------------------------------------------------------------------------
sub update {
	my $self = shift;
	my %wind;

	if ( ref( $_[0] ) eq "HASH" ) {
		%wind = %{ $_[0] };
	} else {
		%wind = @_;
	}

	# handle non existent wind data
	unless ( $wind{s} ) {
		$self->speed(-1);
		$self->maximum_gust(-1);
		$self->direction_degrees(-1);
		$self->direction_short('N/A');
	} elsif ( lc( $wind{s} ) eq "calm" ) {

		# special rules apply if speed is non-numeric
		$self->speed(0);
		$self->direction_degrees(-1);
		$self->direction_short('N/A');
	} else {

		# else update object data
		$self->speed( $wind{s} );
		$self->direction_degrees( $wind{d} );
		$self->direction_short( $wind{t} );
	}

}

#------------------------------------------------------------------------
# overwrite method $self->direction_long()
#------------------------------------------------------------------------
sub direction_long {
	my $self = shift;
	return convert_winddirection( $self->direction_short() );
}

1;

__END__

=pod

=head1 NAME

Weather::Com::Wind - class containing wind data

=head1 SYNOPSIS

  #!/usr/bin/perl -w
  use Weather::Com::Finder;

  # you have to fill in your ids from weather.com here
  my $PartnerId  = 'somepartnerid';
  my $LicenseKey = 'mylicense';

  my %weatherargs = (
	'partner_id' => $PartnerId,
	'license'    => $LicenseKey,
  );

  my $weather_finder = Weather::Com::Finder->new(%weatherargs);
  
  my @locations = $weather_finder->find('Heidelberg');

  my $currconditions = $locations[0]->current_conditions();

  print "Wind comes from ", $currconditions->wind()->direction_long(), "\n";
  print "and its speed is", $currconditions->wind()->speed(), "\n";  

=head1 DESCRIPTION

Via I<Weather::Com::Wind> one can access speed and direction (in degrees,
short and long textual description) of the wind. Wind is usually an object
belonging to current conditions or to a forecast (not implemented yet).

This class will B<not> be updated automatically with each call to one
of its methods. You need to call the C<wind()> method of the parent
object again to update your object.

=head1 CONSTRUCTOR

You usually would not construct an object of this class yourself. 
This is implicitely done when you call the C<wind()> method of one
current conditions or forecast object.

=head1 METHODS

=head2 speed()

Returns the wind speed.

=head2 direction_degrees()

Returns the direction of the wind in degrees.

=head2 direction_short()

Returns the direction of the wind as wind mnemonic (N, NW, E, etc.).

For a full list of wind directions please refer to 
L<Weather::Com::Base>.

=head2 direction_long()

Returns the direction of the wind as long textual description
(North, East, Southwest, etc.).

For a full list of wind directions please refer to 
L<Weather::Com::Base>.

=head1 AUTHOR

Thomas Schnuecker, E<lt>thomas@schnuecker.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Thomas Schnuecker

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The data provided by I<weather.com> and made accessible by this OO
interface can be used for free under special terms. 
Please have a look at the application programming guide of
I<weather.com> (L<http://www.weather.com/services/xmloap.html>)!

=cut

