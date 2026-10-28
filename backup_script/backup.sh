#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <directory_name>"
	exit 1
fi
TARGET_DIR="$1"

if [ ! -d "$TARGET_DIR" ]; then
	echo "Error: '$TARGET_DIR' does not exist."
	exit 1
fi

CURRENT_DATE=$(date +%Y-%m-%d)
BACKUP_DIR="backup_$CURRENT_DATE"
BACKUP_PATH="$TARGET_DIR/$BACKUP_DIR"

mkdir -p "$BACKUP_PATH"

COUNT=0

for file in "$TARGET_DIR"/*.txt "$TARGET_DIR"/*.sh; do
	if [ -f "$file" ]; then
		cp "$file" "$BACKUP_PATH/"
		((COUNT++))
	fi
done

echo "$COUNT files copied into $BACKUP_DIR"

exit 0
