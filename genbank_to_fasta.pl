#!/usr/bin/perl
# gb2fas.pl
#
# 180222
# v.0.1
# ksaitoh
#
# Convert GenBank format sequence file to FASTA format
# usage > perl gb2fas.pl infile > outfile
# May not work properly on Mac files

$infile = shift @ARGV;
$outfile = shift @ARGV;

$locus = "LOCUS";
$begin = "ORIGIN";
$end = "\/\/";
$fastaprompt =">";

open(IN, $infile) or die "Failed to open $infile\n";
open(FH, '>', $outfile) or die $!;

$n = 0;               # reset line number

while ($line = <IN>)  {  # read line
    chomp ($line);
    $line =~ s/\r$//;
    if ($line =~ /^$locus/) {
        ++$n;
        &header;
        print "$header\n";
        print FH "$header\n";
    }
    if ($line =~ /^$begin/) {
        $seq = $fastaprompt;
        &body;
    }
}
print STDERR "$n sequences\n";



sub header {
    @field = split /\s+/, $line;
    $header = "$fastaprompt$field[1]";
}

sub body {
    while ($line = <IN>) {
        chomp ($line);
        $line =~ s/\r$//;
        if ($line !~ /^$end/) {
            $line =~ s/[0-9]//g;
            $line =~ tr /a-z/A-Z/;
            $line =~ s/\s+//g;
            print "$line\n";
            print FH "$line\n";
        }
        else {
            last;
        }
    }
}

