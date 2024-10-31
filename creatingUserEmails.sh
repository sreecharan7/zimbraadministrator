#!/bin/bash 

#declaretion of color codes
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
DEFAULT="\e[0m"


# varaibles

noOfNeeded=0
accountPattern=""
domain=""
passwordLength=10


#checking the user is zimbra or any other 
if [[ "$USER" != "zimbra" ]];then
    #checking the zimbra user is exist or not
    if [[ ! $(id zimbra 2>/dev/null) ]];then
        echo -e "${RED}zimbra user doesnot exist${DEFAULT}";
        echo "Once recheck the installation of the zimbra collabration"
        exit 12
    fi
    echo -e "${RED}Please swicth to the zimbra user and run the script${DEFAULT}"
    echo "help:- run this command ( su zimbra )"
    exit 11
fi

read -p "Enter the number of account should created: " noOfNeeded


#checking the valid number
if [[ ! "$noOfNeeded" =~ ^[0-9]+$ ]] || [[ ! "$noOfNeeded" -gt 0 ]];then
    echo "Please enter the valid number and greater than 0"
    exit 12
fi


echo

echo -e "${YELLOW}Do you have any idea how account pattren should look likes${DEFAULT}"

cat<<EOF
eg:- if account pattren = user
this will create user1@domin user2@domin user3@domin ....
with random password length ${passwordLength}
If you want to take the default pattren (user) please press enter..
EOF

#taking input the account pattren input
read -p "Enter the account pattren: " accountPattern

if [[ -z "${accountPattern}" ]];then
    accountPattern="user"
fi

if [[ -z "${domain}" ]];then
    domain=$(zmprov gaaa 2>/dev/null | head -1 | cut -d '@' -f2);
    if [[ -z "${domain}" ]];then
        echo -e "${RED}Unable to extract the domain,Please manualy input the domain in the begining of script${DEFAULT}"
        exit 15
    fi
fi


passwod_generation(){
    echo $(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c ${passwordLength})
}

echo

declare -a array

for((i=1,j=1; i<=noOfNeeded; j++));do
    echo "started creating ${accountPattern}${j}@${domain}..."
    zmprov ca "${accountPattern}${j}@${domain}" "$(passwod_generation)"
    if [[ "$?" == 0 ]];then 
        array+=("${accountPattern}${j}@${domain}")
        echo "created  the account ${accountPattern}${j}@${domain}"
        ((i++))
    fi
done

echo

echo "these are the account are created"

echo "${array[*]}"

echo

echo -e "${GREEN}sucessfully created the accounts ${DEFAULT}"