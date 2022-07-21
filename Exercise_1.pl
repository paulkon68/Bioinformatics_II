#!/usr/bin/perl

# says to the programme that instead of reading line by line, it must read until "//\n" pattern. 
# This actually makes the programme to read an entire record of Uniprot and το save it in the $_ .
$/="\/\/\n";

# create and open the file with name: 'transmembrane_proteins.txt' to write the final output, the 
# sequence with the id, the number of aa, the sequence and the transmembrane regions below the sequence.
open(FH, '>', "transmembrane_proteins.txt") or die $!;

# scan the whole .swiss file that was given as first parameter from the command line
while (<>)
{
    # on each loop, isolate one protein record.

    # if you encounter the following pattern in the file, grab the ID of the protein 
    # (first parenthesis), and the number of the amino acids (second parenthesis).
    if ($_=~/^ID\s{3}(.*?)\s+.*?\;\s+(\d+\sAA)/m)
    {   
        # print into the file the ID of the protein (in variable $1)
        print FH ">$1";
        # return the number of amino acids plus 'AA' string in lowcase (string in variable $2). 
        $aa = lc $2;
        # the length of the sequence is the number of amino acids in $aa string, after removing the 'aa' characters.
        $length = $aa;
        $length =~ s/aa//;
        # substitude the spaces in $aa string that holds the length of the sequence plus the 'aa' characters
        $aa =~ s/\s//;
        # if you encounter the 'AC', hold the string (accession number of the protein) in $1.
        if ($_=~/^AC\s{3}(.*?)\;/m)
        {
            # write the accession number to the file and after that, the length of the sequence followed by 'aa'.
            print FH "|$1|$aa\n";
        }
    }
    # every sequence on the transmem_proteins.swiss starts with 5 spaces, so 
    # grab the sequence contained in one line, save it in $1 variable and print it after removing the spaces.
    # when the loop is completed, all amino acids of the sequnece will be printed on the file.
    while ($_=~/^\s{5}(.*)/mg)
    {
        $sequence=$1;
        $sequence=~s/\s//g;
        #print "$sequence\n";
        print FH "$sequence";
    }
    # print a newline after the sequence in the file.
    print FH "\n";
    # save the limits of the transmembrane amino acid residues into the array: @matches
    @matches = ($_ =~ /^FT\s{3}TRANSMEM\s+(\d+)\s+(\d+)\s+.*\./mg);
    my $index = 0;
    # initialize the counter
    $index = 0;
    # length of the array
    $array_length = @matches;
    # initialize the end point of the first transmembrane amino acid residue to zero
    $tmend = 0;
    # loop for each limit pair in the array
    # '-' => not a transmembrane amino acid residue
    # 'M' => transmembrane amino acid residue
    for($i=0; $i < $array_length; $i+=2)
    {
        # the starting point of the transmembrane amino acid residue
        $tmstart = $matches[$i];
        # print '-' until region of transmembrane amino acid residue is reached
        print FH '-'x($tmstart-$tmend-1);
        # the end point of the transmembrane amino acid residue
        $tmend = $matches[$i+1];
        # print 'M' (stands for transmembrane amino acid residue) until the end limit of the transmembrane amino acid residue
        print FH 'M'x($tmend-$tmstart+1);
        
    }
    # when iteration through the array finishes, print under the rest of the length of the sequence '-'
    print FH '-'x($length-$tmend);
    
    # print the '//' character and a newline character after each record into the file
    print FH "\n//\n\n";
}

# close the file descriptor
close(FH);



