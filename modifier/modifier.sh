#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Error: Invalid number of arguments."
	echo "Usage: $0 <filename> <target_word> <replacement_word>"
	exit 1
fi
FILE="$1"
TARGET_WORD="$2"
REPLACEMENT_WORD="$3"

if [ ! -f "$FILE" ]; then
	echo "Error: File '$FILE' does not exist!"
	exit 1
fi

if [ ! -r "$FILE" ]; then
	echo "Error: File '$FILE' is not readable!"
	exit 1
fi

if [ -z "$TARGET_WORD" ]; then
	echo "Error: Target word cannot be empty!"
	exit 1
fi

# compose the new (modified) file name
MODIFIED_FILE="modified_$(basename "$FILE")"
LOG_FILE="changes.log"

COUNT=$(grep -owF -- "$TARGET_WORD" "$FILE" | wc -l)
sed "s/\<$TARGET_WORD\>/$REPLACEMENT_WORD/g" "$FILE" > "$MODIFIED_FILE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - File: $FILE -> $MODIFIED_FILE | All $COUNT occurrences of '$TARGET_WORD' replaced with '$REPLACEMENT_WORD'" >> "$LOG_FILE"

echo "All $COUNT occurences of '$TARGET_WORD' replaced with '$REPLACEMENT_WORD'"
echo "Modified file: $MODIFIED_FILE"
echo "Logged to: $LOG_FILE"

exit 0
