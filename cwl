#!/usr/bin/env perl

# Cwiid is a library that enables your application to communicate with
# a wiimote using a bluetooth connection. To configure the buttons you
# need to configure the '/etc/cwiid/wminput/buttons' file. I wrote this
# script so I could create multiple config files for various programs
# and link them to the 'button' file example 'ln -s emu buttons' etc

use strict;
use warnings;
use diagnostics;

my $link	= readlink('/etc/cwiid/wminput/buttons');
my $version	= 0.01;

my %prog	= (

   evince		=>	1,
   emu			=>	1,
   vvvvvv		=>	1,

);

my %swit	= (

	set		=>	'--set',
	link		=>	'--link',
	help		=>	'--help',
	remove		=>	'--remove',
	version		=>	'--version',

);


my %desc	= (
	set		=>	'sets the link to <program name>',
	link		=>	'shows what buttons is linked to',
	help		=>	'displays this help :)',
	remove		=>	'removes the current link',
	version		=>	'print version number',
);




sub get_link {

	if (if_exists()) {

		print "buttons -> $link\n";

	} else {

		print "file doesn't exist\n";

	}

}

sub if_exists {

	-e '/etc/cwiid/wminput/buttons';

}

sub rm_link {

	system("sudo rm /etc/cwiid/wminput/buttons");

}

sub set_link {

	system("sudo ln -s /etc/cwiid/wminput/$_[0] /etc/cwiid/wminput/buttons");

}

sub help {

	print "Usage: cwl <options> <program name>\n\n";
	print "options:\n";
	for (keys %swit) {
		printf("  %-10s %s\n", $swit{$_}, $desc{$_});
	}
	print "\nprograms:\n";
	for (keys %prog) {
		print "  $_\n";
	}
	print "\nexamples:\n";
	print "  cwl --help\n";
	print "  cwl --set <program name>\n";
}

if (@ARGV == 2) {

	if ($ARGV[0] eq $swit{set} and $prog{$ARGV[1]}) {

		if (if_exists()) { rm_link(); }

		set_link($ARGV[1]);

	} else {

		help();

	}

} elsif (@ARGV == 1) {

	if ($ARGV[0] eq $swit{link}) {

		get_link();

	} elsif ($ARGV[0] eq $swit{help}) {

		help();

	} elsif ($ARGV[0] eq $swit{remove}) {

		if (if_exists()) {

			rm_link();

		} else {

			print "there's no link to remove ;)\n";

		}

	} elsif ($ARGV[0] eq $swit{version}) {
		print "cwl $version\n";
	} else {

		help();

	}

} else {

	help();

}
