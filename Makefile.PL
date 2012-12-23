use 5.008;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	NAME    => 'Weather::Com',
	VERSION => '2.0.0',       # sets $VERSION
	PREREQ_PM => {
				   'Carp'             => '0',
				   'Class::Struct'    => '0',
				   'Data::Dumper'     => '0',
				   'HTTP::Request'    => '0',
				   'Locale::Maketext' => '0',
				   'LWP::UserAgent'   => '0',
				   'Storable'         => '0',
				   'Test::MockObject' => '0',
				   'Time::Format'     => '1.0',
				   'Time::Local'      => '0',
				   'URI::Escape'      => '0',
				   'XML::Simple'      => '0',
	},
	(
	   $] >= 5.005
	   ?             ## Add these new keywords supported since 5.005
		 (
		   ABSTRACT_FROM =>
			 'lib/Weather/Com.pm',    # retrieve abstract from module
		   AUTHOR => 'Thomas Schnuecker <thomas@schnuecker.de>'
		 )
	   : ()
	),
);
