package Weather::Com::CurrentConditions;

use 5.006;
use strict;
use warnings;
use Weather::Com::AirPressure;
use Weather::Com::UVIndex;
use Weather::Com::Wind;
use base "Weather::Com::Cached";

our $VERSION = sprintf "%d.%03d", q$Revision: 1.2 $ =~ /(\d+)/g;

#------------------------------------------------------------------------
# Constructor
#------------------------------------------------------------------------
sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my %parameters;

	# parameters provided by new method
	if ( ref( $_[0] ) eq "HASH" ) {
		%parameters = %{ $_[0] };
	} else {
		%parameters = @_;
	}

	unless ( $parameters{location_id} ) {
		die "You need to provide a location id!\n";
	}

	# set some parameters to sensible values for a
	# current conditions object
	$parameters{current}  = 1;
	$parameters{forecast} = 0;
	$parameters{links}    = 0;

	# creating the SUPER instance
	my $self = $class->SUPER::new( \%parameters );
	$self->{ID} = $parameters{location_id};

	# getting first weather information
	$self->{WEATHER} = $self->get_weather( $self->{ID} );
	$self->{WIND}    = undef;
	$self->{BAR}     = undef;
	$self->{UV}      = undef;

	return $self;
}    # end new()

#------------------------------------------------------------------------
# refresh weather data
#------------------------------------------------------------------------
sub refresh {
	my $self = shift;
	$self->{WEATHER} = $self->get_weather( $self->{ID} );
	return 1;
}

#------------------------------------------------------------------------
# access location data
#------------------------------------------------------------------------
sub id {
	my $self = shift;
	return $self->{ID};
}

sub name {
	my $self = shift;
	$self->refresh();
	return $self->{WEATHER}->{loc}->{dnam};
}

sub icon {
	my $self = shift;
	return $self->{WEATHER}->{cc}->{icon};
}

sub windchill {
	my $self = shift;
	$self->refresh();
	return $self->{WEATHER}->{cc}->{flik};
}

sub observatory {
	my $self = shift;
	$self->refresh();
	return $self->{WEATHER}->{cc}->{obst};
}

sub last_updated {
	my $self = shift;
	$self->refresh();
	return $self->{WEATHER}->{cc}->{lsup};
}

sub temperature {
	my $self = shift;
	$self->refresh();
	return $self->{WEATHER}->{cc}->{tmp};
}

sub humidity {
	my $self = shift;
	$self->refresh();
	return $self->{WEATHER}->{cc}->{hmid};
}

sub wind {
	my $self = shift;
	$self->refresh();

	unless ( $self->{WIND} ) {
		$self->{WIND} = Weather::Com::Wind->new();
	}
	$self->{WIND}->update( $self->{WEATHER}->{cc}->{wind} );
	return $self->{WIND};
}

sub pressure {
	my $self = shift;
	$self->refresh();

	unless ( $self->{BAR} ) {
		$self->{BAR} = Weather::Com::AirPressure->new();
	}
	$self->{BAR}->update( $self->{WEATHER}->{cc}->{bar} );    
	return $self->{BAR};
}

sub dewpoint {
	my $self = shift;
	$self->refresh();
	return $self->{WEATHER}->{cc}->{dewp};
}

sub uv_index {
	my $self = shift;
	$self->refresh();

	unless ( $self->{UV} ) {
		$self->{UV} = Weather::Com::UVIndex->new();
	}
	$self->{UV}->update( $self->{WEATHER}->{cc}->{uv} );
	return $self->{UV};
}

sub visibility {
	my $self = shift;
	$self->refresh();
	return $self->{WEATHER}->{cc}->{vis};
}

sub description {
	my $self = shift;
	$self->refresh();
	return $self->{WEATHER}->{cc}->{t};
}

1;

__END__

=pod

=head1 NAME

Weather::Com::CurrentConditions - class containing current weather conditions

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

  my $finder = Weather::Com::Finder->new(%weatherargs);
  
  # if you want an array of locations:
  my @locations = $finder->find('Heidelberg');
  
  my $conditions = $locations[0]->current_conditions();
  print "Found weather for city: ", $location->name(), "\n";
  print "Current conditions are ", $conditions->description(), "\n";
  print "Current temperature is ", $conditions->temperature(), "°C\n";
  print "... as found out by observatory ", $conditions->observatory(), "\n";

=head1 DESCRIPTION

Using I<Weather::Com::CurrentCondition> objects provide current weather
conditions of its parent object (a location) to you. 

You get I<Weather::Com::CurrentConditions> objects by calling the method
C<current_conditions()> of your location object.

I<Weather::Com::CurrentConditions> is a subclass of I<Weather::Com::Cached>.
An instance of this class will update itself corresponding to the
caching rules any time one of its methods is called.

=head1 CONSTRUCTOR

=head2 new(hash or hashref)

The constructor will usually not be used directly because you get a ready
to use current conditions objects from your location object.

If you ever want to instantiate current conditions objects on your own, you have
to provide the same configuration hash or hashref to the constructor
you usually would provide to the C<new()> method of I<Weather::Com::Finder>.
In addition it is necessary to add a hash element C<location_id> to this
config hash. The C<location_id> has to be a valid I<weather.com> 
location id.

=head1 METHODS

=head2 id()

Returns the location id used to instantiate this object.

=head2 name()

Returns the name of the location this current conditions belong to.

=head2 description()

Returns a textual representation of the current weather conditions.

=head2 dewpoint() 

Returns the dewpoint.

=head2 humidity()

Returns the humidity (in %).

=head2 icon()

Returns the number of the icon that can be used to display the
current weather conditions. These icons are available with the
I<weather.com> sdk. You can download this sdk from I<weather.com>
after you've registered to get your license.

=head2 last_updated()

Returns the C<lsup> string as provided by I<weather.com>.

This may change in the future to provide a more sensible
time and date format...

=head2 observatory()

Returns the name of the observatory that provided the current conditions
to I<weather.com>.

=head2 pressure()

Returns a I<Weather::Com::AirPressure> object.

Please refer to L<Weather::Com::AirPressure> for further
details.

=head2 temperature()

Returns the temperature (depending on how you instantiated your
I<Weather::Com::Finder> you'll get centigrade (default) or degrees
fahrenheit).

=head2 uv_index()

Returns a I<Weather::Com::UVIndex> object.

Please refer to L<Weather::Com::UVIndex> for further
details.

=head2 visibility()

Returns the visibility (depending on how you instantiated your
I<Weather::Com::Finder> you'll get km (default) or miles).

=head2 wind()

Returns a I<Weather::Com::Wind> object.

Please refer to L<Weather::Com::Wind> for further
details.

=head2 windchill()

Returns the windchill temperature (depending on how you instantiated your
I<Weather::Com::Finder> you'll get centigrade (default) or degrees
fahrenheit).

=head1 SEE ALSO

See also documentation of L<Weather::Com>, L<Weather::Com::CurrentConditions>,
L<Weather::Com::Units>.

=head1 AUTHOR

Thomas Schnuecker, E<lt>thomas@schnuecker.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Thomas Schnuecker

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The data provided by I<weather.com> and made accessible by this OO
interface can be used for free under special terms. 
Please have a look at the application programming guide of
I<weather.com> (http://www.weather.com/services/xmloap.html)

=cut

