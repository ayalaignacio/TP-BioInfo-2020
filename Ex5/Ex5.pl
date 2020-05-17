use Bio::SeqIO;
use Bio::Factory::EMBOSS;

my $input_file_name = "NM_000518.5.gb";
my $fasta_file_name = "NM_000518.5.fas";
my $sixpack_file_name = "NM_000518.5.sixpack";
my $motifs_file_name = "NM_000518.5.patmatmotifs";

#Obtenemos la EMBOSS factory
my $emboss = Bio::Factory::EMBOSS -> new();

my $seqio_obj = Bio::SeqIO->new(-file => $input_file_name, 
                             -format => "genbank" );

my $seq_obj = $seqio_obj->next_seq;

print "Original sequence";
print $seq_obj->seq();

my $fastaio = Bio::SeqIO->new(-file => ">$fasta_file_name", 
                             -format => 'fasta' );
$fastaio->write_seq($seq_obj);


print "Getting sixpack tool";
my $sixpack = $emboss->program('sixpack') || die "Program not found!\n";

print "Running sixpack and writing to $sixpack_file_name";
$sixpack->run({-sequence => $fasta_file_name,
             -outfile   => $sixpack_file_name});

print "Getting patmatmotifs tool";
my $patmatmotifs = $emboss->program('patmatmotifs') || die "Program not found!\n"; 

print "Running patmatmotifs and writing to $motifs_file_name";
$patmatmotifs->run({-sequence => $seq_obj,
              	    -full => 1,
                    -outfile => $motifs_file_name});

print "FINISH, CHECK FILES";


