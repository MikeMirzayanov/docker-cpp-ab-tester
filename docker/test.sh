#!/bin/bash

# Define paths
PROGRAM_PATH="/income/program.cpp"
COMPILED_PROGRAM="./program"
TEST_FOLDER="./tests"
RESULT_JSON_FILE="/outcome/result.json"
SCORE=0
MAX_SCORE=3
VERDICT="OK"
COMMENT=""

# Escape and prepare the output for JSON format
escape_json() {
    echo "$1" | sed ':a;N;$!ba;s/\\/\\\\/g; s/"/\\"/g; s/\n/\\n/g'
}

# Function to write result to JSON
write_result() {
    echo "{\"verdict\":\"$VERDICT\",\"points\":$SCORE,\"comment\":\"$COMMENT\"}" > "$RESULT_JSON_FILE"
}

# Check if program.cpp is the only file in /income
if [ ! -f "$PROGRAM_PATH" ]; then
    VERDICT="FAILED"
    COMMENT="Error: program.cpp not found in /income."
    write_result
    exit 0
fi

if [ $(ls /income | wc -l) -ne 1 ]; then
    VERDICT="FAILED"
    COMMENT="Error: /income contains files other than program.cpp."
    write_result
    exit 0
fi

# Attempt to compile the program
g++ "$PROGRAM_PATH" -o "$COMPILED_PROGRAM" 2> compile_log.txt
if [ $? -ne 0 ]; then
    VERDICT="COMPILATION_ERROR"
    # Limit the compilation log to 1KB before escaping it for JSON
    COMMENT=$(escape_json "$(head -c 1024 compile_log.txt)")
    write_result
    exit 0
fi

# Run tests
for i in $(seq 1 $MAX_SCORE); do
    echo "Running test case ${i}"

    INPUT_FILE="$TEST_FOLDER/input$i.txt"
    EXPECTED_FILE="$TEST_FOLDER/output$i.txt"
    OUTPUT_FILE="./output.txt"
    
    if [ ! -f "$INPUT_FILE" ] || [ ! -f "$EXPECTED_FILE" ]; then
        VERDICT="FAILED"
        COMMENT="Error: Missing test case files."
        write_result
        exit 0
    fi

    # Run the compiled program with timeout and memory limit
    RESULT=$(timeout 1s "$COMPILED_PROGRAM" < "$INPUT_FILE" > "$OUTPUT_FILE" 2>&1)
    
    # Check for time and memory limits
    if [ $? -ne 0 ]; then
        if [ "$RESULT" == "Command terminated" ]; then
            COMMENT+="Test case $i: Time Limit Exceeded\n"
        else
            COMMENT+="Test case $i: Runtime Error\n"
        fi
        continue
    fi
    
    # Compare output with expected
    if cmp -s "$OUTPUT_FILE" "$EXPECTED_FILE"; then
        COMMENT+="Test case $i: Passed\n"
        ((SCORE++))
    else
        COMMENT+="Test case $i: Wrong Answer\n"
    fi
done

echo "Done"

# Finalize the result JSON
write_result
exit 0