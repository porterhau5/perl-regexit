perl-regexit
============

A collection of Perl regular expressions

Requirements
------------

Perl

Usage
-----

Put the data files in the _data/_ directory

Update any configuration variables in _regexit.conf_.

<pre>
perl regexit.pl
</pre>

By default, the script looks for data files in the _data/_ directory. Output files are written to the _output/_ directory. Both of these values can be changed in the _regexit.conf_ file.

By default, the script will run all regular expressions against the data files. These can be turned on/off by editing the _regexit.conf_ file.

The data currently in the data directory is a couple emails from the Enron email data set.

Output
------
<pre>
user@host:~/perl-regexit$ perl regexit.pl
Current file: data/commonfile.txt
Current file: data/set1
Current file: data/set1/file1.txt
Current file: data/set1/file2.txt
Current file: data/set1/file3.txt
Current file: data/set2
Current file: data/set2/file4.txt
Current file: data/set2/file5.txt
Done!
Output can be found in: output/
</pre>

Background
----------

I often find myself digging around for regular expressions I've written or come across in the past. The idea is to have one Perl script that can match regular expressions against any set of text-based data. It's more of just a regex cookbook than anything. As I write or come across more useful regular expressions, I'll add them here.

Current Expressions
-------------------

* Credit Cards: Valid major Credit Card numbers. Used for pen testing.
* Email Addresses: Valid email addresses.
* Internet URLs: Grab the full URL for mailto, ftp, http, https.

TODO
----
* Add in an optional param to take in single file (or dir)... can default to regexit.conf file if none specified
* Add in option to print matches to screen
* Add expression for matching SS numbers
* Add expression for matching IPv4/IPv6 addreses
