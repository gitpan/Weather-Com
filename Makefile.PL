use 5.006;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	NAME    => 'Weather::Com',
	VERSION => '0.3.1',            # sets $VERSION
	PREREQ_PM => {
				   XML::Simple    => "",
				   URI::Escape    => "",
				   LWP::UserAgent => "",
				   Data::Dumper   => "",
				   Time::Local    => "",
				   Time::Format   => "1.0",
				   Storable       => "",
	},
	(
	   $] >= 5.005
	   ?                         ## Add these new keywords supported since 5.005
		 (
		   ABSTRACT_FROM =>
			 'lib/Weather/Com.pod',    # retrieve abstract from module
		   AUTHOR => 'Thomas Schnuecker <thomas@schnuecker.de>'
		 )
	   : ()
	),
);
