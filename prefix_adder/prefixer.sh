#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Error: Invalid number of arguments."
	echo "Usage: $0 <directory> <prefix>"
	exit 1
fi

TARGET_DIR="$1"
PREFIX="$2"

if [ ! -d "$TARGET_DIR" ]; then
	echo "Error: Directory '$TARGET_DIR' does not exist!"
	exit 1
fi

if [ ! -r "$TARGET_DIR" ] || [ ! -w "$TARGET_DIR" ]; then
	echo "Error: Permission denied for directory '$TARGET_DIR'"
	exit 1
fi

if [ -z "$PREFIX" ]; then
	echo "Error: Prefix cannot be empty."
	exit 1
fi

HAS_SUBDIR=0
for ITEM in "$TARGET_DIR"/*; do
	if [ -d "$ITEM" ]; then
		HAS_SUBDIR=1
		break
	fi
done
RECURSIVE=0
if [ "$HAS_SUBDIR" -eq 1 ]; then
	read -r -p "Directory contains subdirectories. Rename files recursively? (y/n): " ANSWER
	if [ "$ANSWER" = "y" ]; then
		RECURSIVE=1
	fi
fi

COUNT=0
RENAMED_LIST=""

rename_in_dir() {
	local CURRENT_DIR="$1"
	local ITEM
	
	for ITEM in "$CURRENT_DIR"/*; do
		if [ -f "$ITEM" ] && [[ "$ITEM" == *.txt ]]; then
			local BASE_NAME
			BASE_NAME=$(basename "$ITEM")
			local NEW_NAME="${PREFIX}${BASE_NAME}"
			mv "$ITEM" "$CURRENT_DIR/$NEW_NAME"
			
			COUNT=$((COUNT + 1))
			RENAMED_LIST="$RENAMED_LIST, $NEW_NAME"
		elif [ -d "$ITEM" ] && [ "$RECURSIVE" -eq 1 ]; then
			rename_in_dir "$ITEM"
		fi
	done
}

rename_in_dir "$TARGET_DIR"

echo "$COUNT files renamed: $RENAMED_LIST"
exit 0


