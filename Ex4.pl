use Bio::Search::Result::BlastResult;
use Bio::SearchIO;
use Term::ANSIColor;
 
my $report = Bio::SearchIO->new( -file=>'result.blast', -format => blast);
my $result = $report->next_result;

print "Ingrese un Pattern: ";
$pattern = <>;
print "\n";
chomp($pattern);
$hits = 0;

while (my $hit = $result->next_hit) {
	my $description = $hit->description;
	my $length = $hit->length;
	my $expect = $hit -> significance();
	my $bits = $hit -> bits;  
	if(index($description, $pattern) != -1){
	print color('bold green');		
		print "$description\n\n";
		print color('reset');
		print "Expect = $expect, Score = $bits bits (". $hit->score . "), Length = $length \n\n";		
   	
       #Imprimo la secuencia del hit
       while( my $hsp = $hit->next_hsp ) {
              print $hsp -> hit_string . "\n";
            }
	print "\n";
	$hits = 1;		
	}
}

if(!$hits){
		print color('bold red');
		print "No existen hits que coincidan con el pattern ingresado\n"
	}