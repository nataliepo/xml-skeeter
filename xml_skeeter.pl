#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use XML::Simple;
use JSON;

use constant JSON_OUTFILE => 'feed.json';

die "Usage: $0 'http://full/url/to/your/xml/feed saved_file_name.html'\n" 
   if (!$ARGV[0] || !$ARGV[1]);

my $url = $ARGV[0];
my $input_file = $ARGV[1];

if (! -e $input_file) {
   my $result = `wget $url`;
}
# if it IS there, get a new one.
else {
   unlink ($input_file);
   my $result = `wget $url`;
}

my $simple = XML::Simple->new( );             # initialize the object
my $tree = $simple->XMLin( $input_file );   # read, store document

my $post_ref = $tree->{'channel'}->{'item'};

my $final_obj;
my $size = @$post_ref;
$final_obj->{'count'} = $size;

my @links_array = ();

foreach my $post (@$post_ref) {
   my $condensed;
   $condensed->{'title'} = $post->{'title'};
   $condensed->{'link'}  = $post->{'link'};
   $condensed->{'pubDate'}  = $post->{'pubDate'};
   
   push (@links_array, $condensed);
}
$final_obj->{'items'} = \@links_array;

open (OUTFILE, "> " . JSON_OUTFILE) or die "Couldn't open json outfile \"" . JSON_OUTFILE . "\"\n";
print OUTFILE encode_json($final_obj) . "\n";
close(OUTFILE);


### CLEAN UP -- remove the big xml file.
unlink ($input_file);

print "** SCRIPT COMPLETE **\n";

1;
