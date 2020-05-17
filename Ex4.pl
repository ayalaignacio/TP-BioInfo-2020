use Bio::Search::Result::BlastResult;
use Bio::SearchIO;
use Term::ANSIColor;
 
my $report = Bio::SearchIO->new( -file=>'result.blast', -format => blast);
my $result = $report->next_result;


print "Ingrese patron: ";
$pattern = <>;
print "\n";
chomp($pattern);
$huboCoincidencia = 0;

while (my $hit = $result->next_hit) {
	my $descripcion = $hit->description;
	my $length = $hit->length;
	my $expect = $hit -> significance();
	my $bits = $hit -> bits;  
	if(index($descripcion, $pattern) != -1){
	print color('bold green');		
		print "$descripcion\n\n";
		print color('reset');
		print "Expect = $expect, Score = $bits bits (". $hit->score . "), Length = $length \n\n";		
   	while( my $hsp = $hit->next_hsp ) {
              print $hsp -> hit_string . "\n";
            }
	print "\n\n\n";
	$huboCoincidencia = 1;

		
	}
	
}

if(!$huboCoincidencia){
		print color('bold red');
		print "El patrón ingresado no coincide con ningún organismo presente en el blast\n"
	}
