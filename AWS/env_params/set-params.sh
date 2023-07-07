#!/bin/bash

# Defining the location of the files
PARAMS_FILE="/etc/params"
ENV_EXAMPLE_FILE="/home/ec2-user/fullcalendar-docker/src_backend_laravel-10/.env.example"
NEW_ENV_FILE="/home/ec2-user/fullcalendar-docker/src_backend_laravel-10/.env"

# Create a new .env file if not exists
touch $NEW_ENV_FILE

# Reading each line in the .env.example file
while IFS= read -r line
do
  # Extracting the name part before the '=' symbol
  PARAM_NAME=$(echo $line | cut -d'=' -f 1)
  
  # Checking if the parameter exists in the params file
  PARAM_VALUE=$(grep ^$PARAM_NAME $PARAMS_FILE | cut -d'=' -f 2)
  
  # If the parameter exists, it will be added to the new .env file
  if [ -n "$PARAM_VALUE" ]; then
    echo "$PARAM_NAME=$PARAM_VALUE" >> $NEW_ENV_FILE
  fi
done < "$ENV_EXAMPLE_FILE"
