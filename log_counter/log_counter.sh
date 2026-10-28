#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Error: Invalid number of args."
	echo "Usage: $0 <log_file> <INFO|WARNING|ERROR>"
	exit 1
fi

LOG_FILE="$1"
LOG_LEVEL="$2"

if [ ! -f "$LOG_FILE" ]; then
	echo "Error: File '$LOG_FILE' does not exist."
	exit 1
fi

if [ ! -r "$LOG_FILE" ]; then
	echo "Error: File '$LOG_FILE' is not readable."
	exit 1
fi

if [ "$LOG_LEVEL" != "INFO" ] && [ "$LOG_LEVEL" != "WARNING" ] && [ "$LOG_LEVEL" != "ERROR" ]; then
	echo "Error: Invalid log level '$LOG_LEVEL'. Allowed levels are: INFO, WARNING, ERROR."
	exit 1
fi

echo "Matching log entries:"
grep "$LOG_LEVEL" "$LOG_FILE"

COUNT=$(grep -c "$LOG_LEVEL" "$LOG_FILE")
echo "Total $LOG_LEVEL entries: $COUNT"
exit 0
