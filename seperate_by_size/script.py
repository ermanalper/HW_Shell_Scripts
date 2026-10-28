#!/bin/bash
 
if [ "$#" -ne 1 ]; then
	echo "Error: Invalid number of arguments."
	echo "Usage: $0 <directory>"
	exit 1
fi

TARGET_DIR="$1"

if [ ! -d "$TARGET_DIR" ]; then
	echo "Error: Directory '$TARGET_DIR' does not exist!"
	exit 1
fi
if [ ! -r "$TARGET_DIR" ] || [ ! -w "$TARGET_DIR" ]; then
	echo "Error: Permission denied for directory '$TARGET_DIR'"
	exit 1
fi

LARGE_DIR="$TARGET_DIR/large_files"
SMALL_DIR="$TARGET_DIR/small_files"
mkdir -p "$LARGE_DIR" "$SMALL_DIR"

ONE_MB=1048576
LARGE_COUNT=0
SMALL_COUNT=0

SCRIPT_NAME=$(basename "$0")

for FILE in "$TARGET_DIR"/*; do
	if [ ! -f "$FILE" ]; then
		continue
	fi
	if [ "$(basename "$FILE")" = "$SCRIPT_NAME" ]; then
		continue
	fi
	FILE_SIZE=$(stat -c%s "$FILE")
	
	if [ "$FILE_SIZE" -gt "$ONE_MB" ]; then
		mv "$FILE" "$LARGE_DIR/"
		LARGE_COUNT=$((LARGE_COUNT + 1))
	else
		mv "$FILE" "$SMALL_DIR/"
		SMALL_COUNT=$((SMALL_COUNT + 1))
	fi
done

echo "$LARGE_COUNT files moved to large_files"
echo "$SMALL_COUNT files moved to small_files"


exit 0
