#!/bin/bash

# Define the list of .env files to update
ENV_FILES=(
  "$HOME/kf/HayGroup/kfone-workflow-orchestration/backend/.env"
  "$HOME/kf/HayGroup/kfone-user-experience/backend/.env"
  "$HOME/kf/HayGroup/kfone-connect/backend/.env"
)

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

# Update each .env file
for ENV_FILE in "${ENV_FILES[@]}"; do
  # Expand tilde if present (in case user provided paths with ~)
  ENV_FILE="${ENV_FILE/#\~/$HOME}"
  
  # Check if file exists, create if it doesn't
  if [ ! -f "$ENV_FILE" ]; then
    echo "Creating $ENV_FILE"
    touch "$ENV_FILE"
  fi
  
  
  # Update existing variables (if they exist)
  sed -i '' "s|^AWS_ACCESS_KEY_ID=.*|AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID|" "$ENV_FILE"
  sed -i '' "s|^AWS_SECRET_ACCESS_KEY=.*|AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY|" "$ENV_FILE"
  sed -i '' "s|^AWS_SESSION_TOKEN=.*|AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN|" "$ENV_FILE"
  sed -i '' "s|^AWS_REGION=.*|AWS_REGION=us-east-1|" "$ENV_FILE"
  
  # Add variables if they do not exist (check by variable name, not value)
  grep -q "^AWS_ACCESS_KEY_ID=" "$ENV_FILE" || echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> "$ENV_FILE"
  grep -q "^AWS_SECRET_ACCESS_KEY=" "$ENV_FILE" || echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> "$ENV_FILE"
  grep -q "^AWS_SESSION_TOKEN=" "$ENV_FILE" || echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> "$ENV_FILE"
  grep -q "^AWS_REGION=" "$ENV_FILE" || echo "AWS_REGION=us-east-1" >> "$ENV_FILE"
done

echo ""
echo "All .env files updated successfully:"
for ENV_FILE in "${ENV_FILES[@]}"; do
  ENV_FILE="${ENV_FILE/#\~/$HOME}"
  echo "  - $ENV_FILE"
done

# # Update .env file - overwrite existing file
# cat <<EOT > .env
# AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
# AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
# AWS_REGION=us-east-1
# EOT