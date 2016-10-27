#!/usr/local/bin/perl
# Mike McQuade
# DNA-patterns.pl
# Takes in a string and three integers from an input file,
# then outputs the locations where the pattern appears.

use strict;
use warnings;

# Initialize variables
my ($genome,$k,$L,$t,@nums,@kmers,@clumps);

# Open the file to read
open(my $fh,"<ba1e.txt") or die $!;

# Define local variables with respective string and integers
$genome = <$fh>;
chomp($genome);
@nums = split / /, <$fh>;
$k = $nums[0];
$L = $nums[1];
$t = $nums[2];

# Find all distinct k-mers
for (my $i = 0; $i <= (length($genome)-$k); $i++){
	my $distinct = substr($genome,$i,$k);
	if (!grep(/^$distinct$/,@kmers)){
		push @kmers,$distinct;
	}
}

# Iterate through the genome string,
# searching for k-mers in each section of length $L
for (my $i = 0; $i <= (length($genome)-$L); $i++){
	my $section = substr($genome,$i,$L);
	foreach my $pattern (@kmers){
		my $total = 0;
		# Every k-mer in the given section is
		# compared against the given pattern to
		# see how many times the pattern occurs
		# in the section
		for (my $j = 0; $j <= ($L-$k); $j++){
			if (substr($section,$j,$k) eq $pattern){
				$total++;
			}
		}
		# If the number of pattern occurrences is greater than or equal
		# to the value of t, then the given pattern forms a clump
		if ($total >= $t and !grep(/^$pattern$/,@clumps)) {
			push @clumps,$pattern;
		}
	}
}

# Close the file
close($fh) || die "Couldn't close file properly";

print "@clumps\n";