package Weather::Simple;

# $Revision: 1.9 $

use Weather::Cached;

#------------------------------------------------------------------------
# Constructor
#------------------------------------------------------------------------
sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self  = {};
	my %parameters;

	# some general attributes
	$self->{PROXY} = "none";
	$self->{DEBUG} = 0;
	$self->{CACHE} = ".";

	# parameters provided by new method
	if ( ref( $_[0] ) eq "HASH" ) {
		%parameters = %{ $_[0] };
	} else {
		%parameters = @_;
	}

	$self = bless( $self, $class );

	# check mandatory parameters
	unless ( $parameters{place} ) {
		$self->_debug("ERROR: Location not specified");
		return undef;
	}

	# put wanted parameters into $self
	$self->{PLACE} = $parameters{place};
	$self->{PROXY} = $parameters{proxy} if ( $parameters{proxy} );
	$self->{DEBUG} = $parameters{debug} if ( $parameters{debug} );
	$self->{CACHE} = $parameters{cache} if ( $parameters{cache} );

	# Weather::Com object
	my %weatherargs = (
						'current'  => 1,
						'forecast' => 0,
						'proxy'    => $self->{PROXY},
						'debug'    => $self->{DEBUG},
						'cache'    => $self->{CACHE},
	);

	$weatherargs{timeout} = $parameters{timeout} if ( $parameters{timeout} );
	$weatherargs{partner_id} = $parameters{partner_id}
	  if ( $parameters{partner_id} );
	$weatherargs{license} = $parameters{license} if ( $parameters{license} );

	# initialize weather object
	$self->{WEATHER} = Weather::Cached->new(%weatherargs);

	return $self;
}    # end new()

#------------------------------------------------------------------------
# accessor methods
#------------------------------------------------------------------------
sub get_weather {
	my $self = shift;
	my $allweather;
	my $place_result = $self->{WEATHER}->search( $self->{PLACE} );

	# check if search succeeded
	unless ($place_result) {
		$self->_debug($@);
		return undef;
	}

	foreach ( keys %{$place_result} ) {
		my $weatherdata = $self->{WEATHER}->get_weather($_);

		unless ($weatherdata) {
			$self->_debug($@);
			return 0;
		}

		my $place_weather = {

			# header data
			'place'   => $weatherdata->{loc}->{dnam},
			'updated' => _parse_timestring( $weatherdata->{cc}->{lsup} ),

			# temperature celsius/fahrenheit
			'celsius'             => $weatherdata->{cc}->{tmp},
			'temperature_celsius' => $weatherdata->{cc}->{tmp},
			'windchill_celsius'   => $weatherdata->{cc}->{flik},
			'fahrenheit'          =>
			  &Weather::Com::celsius2fahrenheit( $weatherdata->{cc}->{tmp} ),
			'temperature_fahrenheit' =>
			  &Weather::Com::celsius2fahrenheit( $weatherdata->{cc}->{tmp} ),
			'windchill_fahrenheit' =>
			  &Weather::Com::celsius2fahrenheit( $weatherdata->{cc}->{flik} ),

			# other
			'wind'       => _parse_wind( $weatherdata->{cc}->{wind} ),
			'humidity'   => $weatherdata->{cc}->{hmid},
			'conditions' => $weatherdata->{cc}->{t},
			'pressure'   => _parse_pressure( $weatherdata->{cc}->{bar} ),
		};

		push( @{$allweather}, $place_weather );
	}

	return $allweather;
}

sub getweather {
	return get_weather(@_);
}

#------------------------------------------------------------------------
# internal parsing utilities
#------------------------------------------------------------------------
sub _parse_wind {
	my $winddata = shift;
	my $wind;

	if ( lc( $winddata->{s} ) =~ /calm/ ) {
		$wind = "calm";
	} else {
		my $kmh       = $winddata->{s};
		my $mph       = sprintf( "%d", $kmh * 0.6213722 );
		my $direction = &Weather::Com::convert_winddirection($winddata->{t});
		$wind = "$mph mph $kmh km/h from the $direction";
	}
	return $wind;
}

sub _parse_pressure {
	my $pressuredata = shift;
	my $pressure;

	my $hPa = $pressuredata->{r};
	$hPa =~ s/,//g;
	my $in = $hPa * 0.02953;

	$pressure = sprintf( "%.2f in / %.1f hPa", $in, $hPa );
}

sub _parse_timestring {
	my $timestring = shift;
	my @months = (
				   "",       "January",   "February", "March",
				   "April",  "May",       "June",     "July",
				   "August", "September", "October",  "November",
				   "Dezember"
	);

	my ( $date, $time, $ampm, $zone ) = split( / /, $timestring );
	my ( $month, $mday, $year ) = split( "/", $date );

	return "$time $ampm $zone on $months[$month] $mday, " . ( $year + 2000 );
}

#------------------------------------------------------------------------
# other internals
#------------------------------------------------------------------------
sub _debug {
	my $self   = shift;
	my $notice = shift;
	if ( $self->{DEBUG} ) {
		warn ref($self) . " DEBUG NOTE: $notice\n";
		return 1;
	}
	return 0;
}

1;


__END__

=pod

=head1 NAME

Weather::Simple - Simple Wrapper around the I<Weather::Cached> API

=head1 SYNOPSIS

  use Data::Dumper;
  use Weather::Simple;
  
  # define parameters for weather search
  my %params = (
		'cache'      => '/tmp/weathercache',
		'partner_id' => 'somepartnerid',
		'license'    => '12345678',
		'place'      => 'Heidelberg',
  );
  
  # instantiate a new weather.com object
  my $simple_weather = Weather::Simple->new(%params);

  my $weather = $simple_weather->get_weather();
  
  print Dumper($weather);
  

=head1 DESCRIPTION

I<Weather::Simple> is a very high level wrapper around I<Weather::Cached>.

=head1 CONSTRUCTOR

=head2 new(hash or hashref)

This constructor takes the same hash or hashref as I<Weather::Cached> does.
Please refer to that documentation for further details.

Except from the I<Weather::Cached>' parameters this constructor takes a
parameter I<place> which defines the location to search for. It is not
possible to provide the location to search to the I<get_weather()> method!

=head1 METHODS

=head2 get_weather()

This method invokes the I<Weather::Cached> API to fetch some
weather information and returns an arrayref containing one
or many hashrefs with some high level weather information.

If no weather data is found for a location, it returns
I<undef>.

=head1 SEE ALSO

See also documentation of L<Weather::Com> and L<Weather::Cached>.

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

