use Bio::Tools::Run::RemoteBlast;
use Bio::SeqIO;

$db = 'nr';
$prog = 'blastp';
$readmethod = 'blast';
$output_file = 'blast.out';
$e_val= '1e-10';

print "Remote Blast started\n" . "Data Base: " . $db . "\n Algorithm: " . $prog . "\n Readmethod: " . $readmethod . "\n";
print "\nprocessing...\n";

#inicializo el blast remoto
$blast_remoto = Bio::Tools::Run::RemoteBlast->new(
               '-prog' => $prog,
               '-data' => $db,
                '-expect' => $e_val,
                '-readmethod' => $readmethod);

# cargo el archivo fasta con el que se va a trabajar
my $secuencia = Bio::SeqIO->new(-file =>"result.fas", -format =>'Fasta');

while (my $input = $secuencia -> next_seq()){
    print $input -> seq() . "\n";
    my $r = $blast_remoto->submit_blast($input);
    print $r . "\n";
    print $blast_remoto -> each_rid . "\n";
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
                $blast_remoto->save_output($output_file);
                $blast_remoto->remove_rid($rid);
                print "done";
            }
        }
    }
}

print "Remote Blast finished, check " . $output_file . "\n"

