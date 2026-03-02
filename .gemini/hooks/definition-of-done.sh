#!/bin/bash

# Definition of Done Hook - Ensures tests are mentioned in the response
RESPONSE_TEXT=$(cat -)

if [[ ! "$RESPONSE_TEXT" =~ "test" && ! "$RESPONSE_TEXT" =~ "verify" ]]; then
  echo '{"status": "retry", "message": "Your response does not seem to include a verification or testing plan. Please ensure you verify your changes."}'
  exit 0
fi

echo '{"status": "success"}'
