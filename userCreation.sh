#!/bin/bash


#declaretion of color codes
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
DEFAULT="\e[0m"


#variables
csv_file="output.csv"




#checking the root premissions
if [[ "$EUID" -ne 0 ]];then
    echo -e "${RED}please use sudo or run this script in root user${DEFAULT}";
    exit 44
fi

#skipping the header and reading the csv file
tail -n +2 "${csv_file}" | while IFS=',' read -r line
do
    # extract the username from the email (before the '@' symbol)
    username="${line%@*}"
    useradd -m "$username" 2>/dev/null
    echo "User $username created."
done

echo

echo -e "${GREEN}sucessfully created the users to the linux system${DEFAULT}"
