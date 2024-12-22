#!/bin/bash

# Configuration
URL="https://www.google.com/"  # Replace with your application's URL
CHECK_INTERVAL=60  # Time in seconds between checks
LOG_FILE="/tmp/application_status.log"

check_application_status() {
  HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" $URL)
  if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "up"
  else
    echo "down"
  fi
}

log_status() {
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
  STATUS=$1
  echo "[$TIMESTAMP] Application is $STATUS" >> $LOG_FILE
}


while true; do
  STATUS=$(check_application_status)
  log_status $STATUS
  sleep $CHECK_INTERVAL
done

