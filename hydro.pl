#!/usr/bin/perl

# says to the programme that instead of reading line by line, it must read until "//\n" pattern. 
# This actually makes the programme to read an entire record of Uniprot and το save it in the $_ .
$/="\/\/\n";

# take for first parameter the filename and for second the size of the rolling window
($filename, $k) = @ARGV;
# typecast into integer
$k = int $k;
# array to save the mean hydrophobicity values for every window
@hydrovalue=(); 
# hash for the hydrophobicity scale
%hyd=( 
	
	R=>'-4.5',	
	K=>'-3.9',
	N=>'-3.5',
	D=>'-3.5',
	Q=>'-3.5',
	E=>'-3.5',
	H=>'-3.2',
	P=>'-1.6',
	Y=>'-1.3',
	W=>'-0.9',
	S=>'-0.8',
	T=>'-0.7',
	G=>'-0.4',
	A=>'1.8',
	M=>'1.9',
	C=>'2.5',
	F=>'2.8',
	L=>'3.8',
	V=>'4.2',
	I=>'4.5' 
	
);
# open the file given as first parameter and use it as input file
open(FH, '<', $filename) or die $!;
# open the "hydroph_scale.txt" for writing the prediction results
open(FW, '>', "hydroph_scale.txt") or die $!;
# scan the whole file
while(<FH>){
	# after five space motif, select the part of the sequence that resides in one line
	while ($_=~/^\s{5}(.*)/mg)
    {
        $sequence=$1;
        $sequence=~s/\s//g;
		# after removing the spaces, append the sequence to the $x variable
        $x .= $sequence;
		
    }
	# print the sequence
	#print("\n$x\n");
}

close(FH);

#read the sequence and finds the central value of the window
for($i=$k; $i<length($x)-$k; $i++){   

	$q=0;
	
	for($j=$i-$k; $j<=$i+$k; $j++){     # finds the elements before and after the central value of the window.
		$a=substr($x,$j,1);            # defines the window.
			
			# print "$a"; --> prints the window
			
		$p=$hyd{$a}; # calculates the hydrophobicity value for every amino acid
		$q=$q+$p;  # adds the hydrophobicity value for every amino acid in the window
	}
		
	$q=$q/(2*$k+1); # finds the mean hydrophobicity value of the window
	$hydrovalue[$i]=$q; # the mean hydrophobicity value of the window will be given to the central amino acid of the window
	$t=substr($x,$i,1);  # finds the central amino acid of the window
	print FW "$i\t$t\t$hydrovalue[$i]";  # prints the position of the central amino acid and the mean hydrophobicity value 
	print FW "\n";	                     # of the window that contains it.
	
		
}
# close the file "hydroph_scale.txt"
close(FW);



