#!/usr/bin/perl -w

# +---------------------------------------------------------------+
# | Name: regexit.pl                                              |
# |                                                               |
# | Author: porterhau5                                            |
# |                                                               |
# | Purpose: Pull regular expression matches out of file(s)       |
# |                                                               |
# | Version: 0.1                                                  |
# |                                                               |
# | Date: 2012/09/14                                              |
# +---------------------------------------------------------------+

use File::Find;
use File::Path qw(make_path);

# open regexit.conf and pull out properties
$conf_file = <regexit.conf>;
open(CONF_FILE, $conf_file) || die("Could not open file.");
@conf=<CONF_FILE>;
close(CONF_FILE);

my ($filedir, $outputdir, $enable_internet_urls, $enable_credit_card, $enable_email_addresses);

foreach $property (@conf)
{
	chomp($property);
	if($property =~ m/data_path=(.*)/i)
	{
		$filedir = $1;
	}
	if($property =~ m/output_path=(.*)/i)
	{
		$outputdir = $1;
	}
	if($property =~ m/credit_card=(\d)/i)
	{
                $enable_credit_card = $1;
	}
	if($property =~ m/email_addresses=(\d)/i)
	{
		$enable_email_addresses = $1;
	}
        if($property =~ m/internet_urls=(\d)/i)
        {
                $enable_internet_urls = $1;
        }
}

#remove \n from outputdir
chomp($outputdir);

# create outputdir if it doesn't exist
if( ! -d $outputdir)
{
	make_path($outputdir);
}

# open Email addresses file
$email_addresses_file="$outputdir/email_addresses.out";
open(EMAIL_ADDRESSES_FILE, ">$email_addresses_file") || die("Could not open $email_addresses_file.");

# open Credit Cards file
$credit_card_file="$outputdir/credit_cards.out";
open(CREDIT_CARD_FILE, ">$credit_card_file") || die("Could not open $credit_card_file.");

# open Internet URLs file
$internet_urls_file="$outputdir/internet_urls.out";
open(INTERNET_URLS_FILE, ">$internet_urls_file") || die("Could not open $internet_urls_file.");

# main subroutine for iterating through each file and matching records against the regular expressions
sub eachFile 
{
	my $filename = $_;
	my $fullpath = $File::Find::name;

	# skip "." and ".."
	if($filename !~ m/^\.\.?$/i)
	{
		print "Current file: $fullpath\n";
		# open file, write records to array, close file
		open(WORKING_FILE, $filename) || die("Could not open $filename.");
		@raw_data=<WORKING_FILE>;
		close(WORKING_FILE);

		foreach $record (@raw_data)
		{
			# Remove \n from end of record
			chomp($record);
			$message = $record;

			# Internet URLs section begins
			if($enable_internet_urls)
			{
				while($message =~ m/(((mailto\:|(news|(ht|f)tp(s?))\:\/\/){1}\S+))/gi)
				{	
					print INTERNET_URLS_FILE "$1\n";
				}
			}

			# Credit card section begins
			# along with whitespace and -, add .
			if($enable_credit_card)
			{
				while($message =~ m/((\b4[0-9]{12}(?:[0-9]{3})?\b)|(\b(?:\d[ -]*?){13,16}\b))/gi)
				{
					print CREDIT_CARD_FILE "$1\n";
				}
			}

			# email addresses section begins
			if($enable_email_addresses)
			{
				while($message =~ m/(\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b)/gi)
				{
					print EMAIL_ADDRESSES_FILE "$1\n";
				}
			}
		}
	}
}

find (\&eachFile, $filedir);

print "Done!\n";
print "Output can be found in: $outputdir/\n";

# close output files
close(INTERNET_URLS_FILE);
close(CREDIT_CARD_FILE);
close(EMAIL_ADDRESSES_FILE);
