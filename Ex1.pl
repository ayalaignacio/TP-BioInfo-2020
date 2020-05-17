#!/usr/bin/perl

use 5.0100;

use strict;
use warnings;

# Load the SeqIO module.
use Bio::SeqIO;

# Load the GenBank file.
my $input = Bio::SeqIO->new(
    -file =>    "sequence.gb",        # to read ('<') from 'input.gb'.
    -format =>  "genbank"           # optional: SeqIO can detect filetypes from the extension.
);

my $out = Bio::SeqIO->new(
	-file => ">seq.fas",
	-format => 'FASTA'
);

# Iterate over every sequence in this file.
my $seq;
while( $seq = $input->next_seq() ) {
    # $seq is a Bio::Seq::RichSeq, which is a Bio::Seq.
    # All the Bio::Seq methods can be called on this object,
    # including:
    say "Sequence name:     " . $seq->description();
    say "Accession number:  " . $seq->accession_number();

    # Not all sequences have actual sequence data.
    if(defined $seq->seq()) {
	my $translation = $seq -> translate(-orf => 2 , -start => "atg",-complete => 1 );
	$out->write_seq($translation)
    }

    say ""; # Blank line.
}
print "translation finished, check seq.fas\n";
