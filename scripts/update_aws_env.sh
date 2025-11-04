#!/bin/bash

# Define the path to the .env file
ENV_FILE="$(pwd)/.env"

# Prompt for MFA token
read -p "Enter MFA token: " MFA_TOKEN

SERIAL_NUMBER="arn:aws:iam::011528287407:mfa/Pixel"
AWS_PROFILE="kfone-dev"

# Run AWS STS get-session-token command
OUTPUT=$(aws sts get-session-token --serial-number $SERIAL_NUMBER --profile $AWS_PROFILE --token-code $MFA_TOKEN)


# Extract credentials from the output
AWS_ACCESS_KEY_ID=$(echo $OUTPUT | jq -r '.Credentials.AccessKeyId')
AWS_SECRET_ACCESS_KEY=$(echo $OUTPUT | jq -r '.Credentials.SecretAccessKey')
AWS_SESSION_TOKEN=$(echo $OUTPUT | jq -r '.Credentials.SessionToken')

echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN"
echo "AWS_REGION=us-east-1"

# Update .env file
sed -i '' "s|^AWS_ACCESS_KEY_ID=.*|AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID|" $ENV_FILE
sed -i '' "s|^AWS_SECRET_ACCESS_KEY=.*|AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY|" $ENV_FILE
sed -i '' "s|^AWS_SESSION_TOKEN=.*|AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN|" $ENV_FILE
sed -i '' "s|^AWS_REGION=.*|AWS_REGION=us-east-1|" $ENV_FILE

# Add variables if they do not exist
grep -qxF "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" $ENV_FILE || echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> $ENV_FILE
grep -qxF "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" $ENV_FILE || echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> $ENV_FILE
grep -qxF "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" $ENV_FILE || echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> $ENV_FILE
grep -qxF "AWS_REGION=us-east-1" $ENV_FILE || echo "AWS_REGION=us-east-1" >> $ENV_FILE

echo ".env file updated successfully."

# # Update .env file - overwrite existing file
# cat <<EOT > .env
# AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
# AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
# AWS_REGION=us-east-1
# EOT