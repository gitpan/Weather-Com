package Weather::Com::UVIndex;

use 5.006;
use strict;
use warnings;
use Class::Struct;

our $VERSION = sprintf "%d.%03d", q$Revision: 1.4 $ =~ /(\d+)/g;

#------------------------------------------------------------------------
# The uv index class will not be a Weather::Cached class by itself,
# because then it would not be easy to now whether it is current
# conditions uv index or forecast uv index and if forecast uv index,
# then of which day, etc.
#
# Weather::Com::UVIndex consists almost only of pure data and no
# significant logic has to be build in. Therefore, we simply use a
# Class::Struct subclass.
#------------------------------------------------------------------------
struct(
		index       => '$',
		description => '$',    
);

#------------------------------------------------------------------------
# update wind data
#------------------------------------------------------------------------
sub update {
	my $self = shift;
	my %uv;

	if ( ref( $_[0] ) eq "HASH" ) {
		%uv = %{ $_[0] };
	} else {
		%uv = @_;
	}

	unless ( $uv{i} ) {
		$self->index(-1);
		$self->description("unknown");
	} else {
		$self->index($uv{i});
		$self->description($uv{t});
	}

	return 1;
}

1;

__END__

=pod

=head1 NAME

Weather::Com::UVIndex - class containing the uv index data

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

  print "The current uv index is ", $currconditions->uv_index()->index(), "\n";
  print "This is relatively ", $currconditions->uv_index()->description(), "\n";  

=head1 DESCRIPTION

Via I<Weather::Com::UVIndex> one can access the uv index and its
description (whether it's high or low). An uv index is usually an object
belonging to current conditions or to a forecast (not implemented yet).

This class will B<not> be updated automatically with each call to one
of its methods. You need to call the C<wind()> method of the parent
object again to update your object.

=head1 CONSTRUCTOR

You usually would not construct an object of this class yourself. 
This is implicitely done when you call the uv_index() method of one
current conditions or forecast object.

=head1 METHODS

=head2 index()

Returns the uv index (number).

=head2 description()

Returns the description whether this index is high or low.

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

