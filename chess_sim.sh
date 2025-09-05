pgn_file="$1"

#check if pgn_file exists
if [ ! -e "$1" ]; then
    echo "File does not exist: $1"
    exit 1
fi

#print metadata
echo "Metadata from PGN file:"
while IFS= read -r line; do
    echo "$line"
    if [ -z "$line" ]; then
        break
    fi
done < "$pgn_file"

output_file="output.txt"

# Get the total number of lines in the input file
total_lines=$(wc -l < "$pgn_file")

# Calculate the line number where the second part starts
second_part_start=$((total_lines / 2 + 1))

# Extract the second part and save it to the output file
tail -n +"$second_part_start" "$pgn_file" > "$output_file"

#create an array of uci moves
output_string=$(<output.txt)
uci_moves=$(python3 parse_moves.py "$output_string")
IFS=' ' read -r -a moves_array <<< "$uci_moves"

# Declare an associative array
declare -A chessboard

# Initialize the chessboard
initialize_chessboard() {
    chessboard=(
        [a8]=r [b8]=n [c8]=b [d8]=q [e8]=k [f8]=b [g8]=n [h8]=r
        [a7]=p [b7]=p [c7]=p [d7]=p [e7]=p [f7]=p [g7]=p [h7]=p
        [a6]=. [b6]=. [c6]=. [d6]=. [e6]=. [f6]=. [g6]=. [h6]=.
        [a5]=. [b5]=. [c5]=. [d5]=. [e5]=. [f5]=. [g5]=. [h5]=.
        [a4]=. [b4]=. [c4]=. [d4]=. [e4]=. [f4]=. [g4]=. [h4]=.
        [a3]=. [b3]=. [c3]=. [d3]=. [e3]=. [f3]=. [g3]=. [h3]=.
        [a2]=P [b2]=P [c2]=P [d2]=P [e2]=P [f2]=P [g2]=P [h2]=P
        [a1]=R [b1]=N [c1]=B [d1]=Q [e1]=K [f1]=B [g1]=N [h1]=R
    )
}

# Function to print the chessboard
print_chessboard() {
    echo "  a b c d e f g h"
    for row in {8..1}; do
        echo -n "$row "
        for col in {a..h}; do
            echo -n "${chessboard[$col$row]} "
        done
        echo "$row"
    done
    echo "  a b c d e f g h"
}

#This function takes every uci move, ans splits it into 2 strings
split_string() {
    local input=$1
    local place=${input:0:2}
    local move=${input:2:2}
    #sends the 2 strings to be used as locations
    move_piece "$place" "$move"
}
#This function is responsible for moving the soliedrs on the board
move_piece() {
    local from=$1
    local to=$2

  # Check for pawn promotion
    if [[ ${chessboard[$from]} == "p" && ${to:1:1} == "1" ]]; then
        chessboard[$from]="q"
    elif [[ ${chessboard[$from]} == "P" && ${to:1:1} == "8" ]]; then
        chessboard[$from]="Q"
    fi
    # the move itself
    chessboard[$to]=${chessboard[$from]}
    chessboard[$from]="."
}

#Print the line which indicates the current move
print_move() {
    local i=$1
    echo "Move $i/${#moves_array[@]}"
}

#main part of the game
initialize_chessboard
i=0
print_move "0"
print_chessboard
x=1
while [ $x -eq 1 ];
do
  echo "Press 'd' to move forward, 'a' to move back, 'w' to go to the start, 's' to go to the end, 'q' to quit:"
  length=${#moves_array[@]}
  read -r key
  case $key in
    d)
        if [ "$i" -ge $length ]; then
             echo "No more moves available."
        else
            #Make the next move
            split_string "${moves_array[i]}"
            ((i++))
            print_move "$i"
	        print_chessboard
        fi
        ;;
    a)
        if [ "$i" -ne 0 ]; then
            ((i--))
            initialize_chessboard
            #implement al moves until the former one
            for ((j=0; j<$i; j++));
            do
                split_string "${moves_array[j]}"
            done
            print_move "$i"
            print_chessboard
        #The current move is number 0.
        else
            initialize_chessboard
            print_move "$i"
            print_chessboard
        fi
        ;;
    w)
        i=0
        initialize_chessboard
        print_move "0"
        print_chessboard
        ;;
    s)
        initialize_chessboard
        #go over all the moves until the last one
        for ((j=0; j<$length; j++));
        do
            split_string "${moves_array[j]}"
        done
        i=$length
        print_move "$length"
	      print_chessboard
        ;;
    q)
        echo "Exiting."
        #Stop the while loop
        x=0
        ;;
    *)
        echo "Invalid key pressed: $key"
        ;;
   esac
done
echo "End of game."