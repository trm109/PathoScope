#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "$SCRIPT_DIR"
export SCRIPT_DIR
pathoscope_wrapper(){
    local item="$1"
    local first_read="$SCRIPT_DIR/../data/${item}_R1.fastq"
    local second_read="$SCRIPT_DIR/../data/${item}_R2.fastq"
    local result_path="$SCRIPT_DIR/../results"
    #echo "fr ${first_read} \nsr ${second_read} \nrp ${result_path}"
    #exit 1
    # Runs pathoscope map with paired reads.
    pathoscope \
      MAP \
      -1 "$first_read" \
      -2 "$second_read" \
      -targetIndexPrefixes silva \
      -filterIndexPrefixes phix174 \
      -outDir "$result_path" \
      -outAlign "${item}.sam" \
      -expTag "$item" \
      -numThreads 8
    if [[ $? -ne 0 ]]; then
      exit 1
    fi
    # Runs pathoscope ID on sam files generated previously.
    pathoscope \
      ID \
      -alignFile \
      "$result_path/${item}.sam" \
      -fileType sam \
      -outDir "$result_path" \
      -expTag "$item"
    if [[ $? -ne 0 ]]; then
      exit 1
    fi
    # Generates pathoscope report on pathoscope ID results
    pathoscope \
      REP -samfile \
      "$result_path/updated_${item}.sam" \
      -outdir "$result_path"
    if [[ $? -ne 0 ]]; then
      exit 1
    fi
    # Zip all non-essential files for papertrail and removes them to save space.
    tar -czf "$result_path/${item}.sam.tar.gz" \
      "$result_path/${item}.sam" \
      "$result_path/${item}-silva.sam" \
      "$result_path/${item}-phix174.sam" \
      "$result_path/updated_${item}.sam" \
      "$result_path/${item}-appendAlign.fq" \
      --remove-files
    if [[ $? -ne 0 ]]; then
      exit 1
    fi
}

export -f pathoscope_wrapper
total_items=$(find "$SCRIPT_DIR/../data" -type f -exec basename {} \; | sed -E 's/_R[12]\.fastq$//' | grep -v '\.gz$' | sort | uniq | wc -l)

find "$SCRIPT_DIR/../data" -type f -exec basename {} \; | \
  sed -E 's/_R[12]\.fastq$//' | grep -v '\.gz$' | \
  sort | \
  uniq | \
  xargs -I {} -P 4 bash -c 'pathoscope_wrapper "$@"' _ {}
