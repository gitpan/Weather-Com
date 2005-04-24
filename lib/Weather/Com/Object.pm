package Weather::Com::Object;

use 5.006;
use strict;
use warnings;
use Carp;

our $VERSION = sprintf "%d.%03d", q$Revision: 1.2 $ =~ /(\d+)/g;

#------------------------------------------------------------------------
# Constructor
#------------------------------------------------------------------------
sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self  = {};
	my %parameters;

	# parameters provided by new method
	if ( ref( $_[0] ) eq "HASH" ) {
		%parameters = %{ $_[0] };
	} else {
		%parameters = @_;
	}

	$self = bless( $self, $class );

	# creating the SUPER instance
	$self->{ARGS} = \%parameters;
	if ( $parameters{lang} ) {
		$self->{LH} = Weather::Com::L10N->get_handle( $parameters{lang} )
		  or croak("Language?");
	} else {
		$self->{LH} = Weather::Com::L10N->get_handle('en_US');
	}

	
	return $self;
}    # end new()

#------------------------------------------------------------------------
# update barometric data
#------------------------------------------------------------------------
sub update {
	my $self = shift;
	return 1;
}

1;
