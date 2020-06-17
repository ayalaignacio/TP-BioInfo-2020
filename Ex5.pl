use Bio::SeqIO;
use Bio::Factory::EMBOSS;

my $input_file_name = "sequence.gb";
my $fasta_file_name = "sequence.fas";
my $sixpack_file_name = "sequence.sixpack";
my $motifs_file_name = "sequence.patmatmotifs";

#Llamamos a EMBOSS
my $emboss = Bio::Factory::EMBOSS -> new();

my $seqio_obj = Bio::SeqIO->new(-file => $input_file_name, 
                             -format => "genbank" );

my $seq_obj = $seqio_obj->next_seq;

print "Original sequence\n";
print $seq_obj->seq();
print '/n';

my $fastaio = Bio::SeqIO->new(-file => ">$fasta_file_name", 
                             -format => 'fasta' );
$fastaio->write_seq($seq_obj);

print "Getting sixpack tool\n";
#Usamos el programa sixpack
my $sixpack = $emboss->program('sixpack') || die "Sickpack not found!\n";

print "Running sixpack and writing to $sixpack_file_name\n";
$sixpack->run({-sequence => $fasta_file_name,
             -outfile   => $sixpack_file_name});

print "Getting patmatmotifs tool\n";
#Usamos el programa patmatmotifs
my $patmatmotifs = $emboss->program('patmatmotifs') || die "Program not found!\n"; 

print "Running patmatmotifs and writing to $motifs_file_name\n";
$patmatmotifs->run({-sequence => $seq_obj,
              	    -full => 1,
                    -outfile => $motifs_file_name});

print "Done";