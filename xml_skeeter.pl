#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use XML::Simple;
use JSON;

use constant JSON_OUTFILE => 'feed.js';

die "Usage: $0 'http://full/url/to/your/xml/feed saved_file_name.html /path/to/outfile/'\n" 
   if (!$ARGV[0] || !$ARGV[1] || !$ARGV[2]);

my $url = $ARGV[0];
my $input_file = $ARGV[1];
my $outfile_path = $ARGV[2];

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
   
   # clean up the pubdate a little.
   # before: Thu, 27 Jan 2011 00:02:08 +0000
   # after: Jan 27, 2011
   my $pubdate = $post->{'pubDate'};
   if ($pubdate =~ m/^([A-Za-z]{3}),\s*([\d]+)\s*([A-Za-z]+)\s*([\d]{4})/) {
      $pubdate = $3 . " " . $2 . ", " . $4;
   }
   else {
      print "Pubdate $pubdate doesn't match.\n";
   }
   $condensed->{'pubDate'}  = $pubdate;
   
   push (@links_array, $condensed);
}
$final_obj->{'items'} = \@links_array;

open (OUTFILE, "> " . $outfile_path . "/" . JSON_OUTFILE) or die "Couldn't open json outfile \"" . JSON_OUTFILE . "\"\n";
print OUTFILE "callback(" . encode_json($final_obj) . ", null);\n";
close(OUTFILE);


### CLEAN UP -- remove the big xml file.
unlink ($input_file);

print "** SCRIPT COMPLETE **\n";

1;
