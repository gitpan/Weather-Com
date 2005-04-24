use 5.006;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	NAME    => 'Weather::Com',
	VERSION => '0.4',       # sets $VERSION
	PREREQ_PM => {
				   Data::Dumper     => "",
				   Locale::Maketext => "",      
				   LWP::UserAgent   => "",
				   Storable         => "",
				   Time::Format     => "1.0",
				   Time::Local      => "",
				   URI::Escape      => "",
				   XML::Simple      => "",
	},
	(
	   $] >= 5.005
	   ?             ## Add these new keywords supported since 5.005
		 (
		   ABSTRACT_FROM =>
			 'lib/Weather/Com.pod',    # retrieve abstract from module
		   AUTHOR => 'Thomas Schnuecker <thomas@schnuecker.de>'
		 )
	   : ()
	),
);
