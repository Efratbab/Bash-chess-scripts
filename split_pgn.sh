#input file
FILE1="$1" 
FILE2="$2"

#In case the number of arguments is incorrect
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 $FILE1 $FILE2"
    exit 1
fi

#In case the directort doesn't exist
if [ ! -d "$FILE2" ]; then
	mkdir -p $FILE2
	echo "Created directory '$FILE2'."
fi

#Check if the first file exists
if test -f "$FILE1"; then
    filename=$(basename -- "$FILE1")
    name="${filename%.*}"
    extension="${filename##*.}"
    n=1
    current_output_file="$FILE2/${name}_$n.$extension"
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == *"[Event "* ]]; then
            # If "[Event" is found, create a new output file
            current_output_file="$FILE2/${name}_$((n++)).$extension"
            event_found=true
        fi
    # Append the line to the current output file
    	echo "$line" >> "$current_output_file"
    done < "$FILE1"
    for current_output_file in "$FILE2"/*; do
        sed -i '$ d' "$current_output_file"
    done
    #In case the 1 file doesn't exist
   else
   	echo "Error: File '$FILE1' does not exist."
   	exit 1
fi