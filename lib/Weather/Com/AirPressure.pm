package Weather::Com::AirPressure;

use 5.006;
use strict;
use warnings;
use Class::Struct;

our $VERSION = sprintf "%d.%03d", q$Revision: 1.2 $ =~ /(\d+)/g;

#------------------------------------------------------------------------
# The pressure class will not be a Weather::Cached class by itself,
# because then it would not be easy to now whether it is current
# conditions pressure or forecast pressure and if forecast pressure,
# then of which day, etc.
#
# Weather::Com::AirPressure consists almost only of pure data and no
# significant logic has to be build in. Therefore, we simply use a
# Class::Struct subclass.
#------------------------------------------------------------------------
struct(
		pressure => '$',
		tendency => '$',    
);

#------------------------------------------------------------------------
# update barometric data
#------------------------------------------------------------------------
sub update {
	my $self = shift;
	my %bar;

	if ( ref( $_[0] ) eq "HASH" ) {
		%bar = %{ $_[0] };
	} else {
		%bar = @_;
	}

	unless ( $bar{r} ) {
		$self->pressure(-1);
		$self->tendency("unknown");
	} else {
		$self->pressure($bar{r});
		$self->tendency($bar{t});
	}

	return 1;
}

1;

__END__

=pod

=head1 NAME

Weather::Com::AirPressure - class containing barometric pressure data

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

  print "Barometric pressure is ", 
    $currconditions->pressure()->pressure(), "\n";
  print "and it's ", $currconditions->pressure()->tendency(), "\n";  

=head1 DESCRIPTION

Via I<Weather::Com::AirPressure> one can access the barometric
pressure and its tendency.

This class will B<not> be updated automatically with each call to one
of its methods. You need to call the C<pressure()> method of the parent
object again to update your object.

=head1 CONSTRUCTOR

You usually would not construct an object of this class yourself. 
This is implicitely done when you call the C<pressure()> method 
of one current conditions or forecast object.

=head1 METHODS

=head2 pressure()

Returns the barometric pressure.

=head2 tendency()

Returns the tendency of the barometric pressure.

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

