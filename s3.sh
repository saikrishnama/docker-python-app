#!/bin/bash

# Define source and destination bucket names
source_bucket="source-bucket-name"
destination_bucket="destination-bucket-name"

# Define KMS key ARN
kms_key_arn="arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"

# Read file names from text file and copy to destination bucket
while IFS= read -r file_name; do
    # Trim leading/trailing whitespace
    file_name=$(echo "$file_name" | xargs)

    # Copy file to destination bucket using specified KMS key
    aws s3 cp "s3://$source_bucket/$file_name" "s3://$destination_bucket/$file_name" --sse aws:kms --sse-kms-key-id "$kms_key_arn"

    # Check if the copy was successful
    if [ $? -eq 0 ]; then
        echo "Successfully copied $file_name from $source_bucket to $destination_bucket using KMS key $kms_key_arn"
    else
        echo "Error copying $file_name"
    fi
done < file_list.txt
