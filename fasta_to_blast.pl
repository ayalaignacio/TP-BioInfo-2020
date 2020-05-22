use Bio::Tools::Run::RemoteBlast;
use Bio::SeqIO;

$db = 'nt';
$prog = 'blastp';
$readmethod = 'SearchIO';
$output_file = 'blast.out';
$e_val= '1e-10';

print "Remote Blast started\n" . "Data Base: " . $db . "\n Algorithm: " . $prog . "\n Readmethod: " . $readmethod . "\n";
print "\nprocessing...\n";

#inicializo el blast remoto
$blast_remoto = Bio::Tools::Run::RemoteBlast->new(
               '-prog' => $prog,
               '-data' => $db,
                '-expect' => $e_val,
                '-readmethod' => $output_file);

# cargo el archivo fasta con el que se va a trabajar
my $secuencia = Bio::SeqIO ->new (-file =>"result.fas", -format =>'fasta');



while (my $input = $secuencia -> next_seq()){
    my $r = $blast_remoto->submit_blast($input);
    while ( my @rids = $blast_remoto->each_rid ) {
        foreach my $rid ( @rids ) {
            my $rc = $blast_remoto->retrieve_blast($rid);
            if( !ref($rc) ) {
                if( $rc < 0 ) {
                   $blast_remoto->remove_rid($rid);
                }
            } 
            else {
                my $result = $rc->next_result();                    
                $blast_remoto->save_output("blast.out");
                $blast_remoto->remove_rid($rid);
            }
        }
    }
}

print "Remote Blast finished, check " . $output_file . "\n"

