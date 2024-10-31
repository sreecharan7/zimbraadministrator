#!/bin/bash 

#declaretion of color codes
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
DEFAULT="\e[0m"


#variables
USER=$USER
FILE="output.csv"
ldap_root_password=""
LDAP_SERVER_IP="ldap://127.0.1.1"

#checking the user is zimbra or any other 
if [[ "$USER" != "zimbra" ]];then
    #checking the zimbra user is exist or not
    if [[ ! $(id zimbra 2>/dev/null) ]];then
        echo -e "${RED}zimbra user doesnot exist${DEFAULT}";
        echo "Once recheck the installation of the zimbra collabration"
        exit 43
    fi
    #gathering the ldap_root_password 
    echo -e "${YELLOW}enter the password of the zimbra user${DEFAULT}"
    ldap_root_password=$(su - zimbra -c 'zmlocalconfig -s -m nokey ldap_root_password')
    if [[ "$?" != 0 ]];then
        read -p "Forgot password of zimbra user? Do you want to reset the password?[y/n]: " option
        if [[ "${option}" =~ ^y ]];then
            echo "enter the password of the current user (${USER}) if asked, after that new passwod of zimbra user"
            sudo passwd zimbra
            echo -e "${YELLOW}enter the password of the zimbra user${DEFAULT}"
            ldap_root_password=$(su - zimbra -c 'zmlocalconfig -s -m nokey ldap_root_password')
            if [[ "$?" != 0 ]];then
                echo "re-run the script"
                exit 44
            fi
        else 
            echo "re-run the script"
            exit 44
        fi
    fi
    else
    ldap_root_password="$(zmlocalconfig -s -m nokey ldap_root_password)"
fi



raw_data=$(/opt/zimbra/common/bin/ldapsearch -LLL -x -H ${LDAP_SERVER_IP} -D "uid=zimbra,cn=admins,cn=zimbra" -w "${ldap_root_password}" "(mail=*)" mail userPassword 2>/dev/null)

if [[ "$?" != 0 ]];then
    echo -e "${RED}something went wrong while fecthing the emails and passwords.....${DEFAULT}"
    cat<<EOF
Maybe these are the some reasons to failure
1) password for the ldap_root_passwod is not properly set
   --- to fix this ---
   1)swicth to the zimbra user ( su zimbra )
   2)reset again password again ( zmldappasswd -r NewPassword )
   3)handle any encryption required ( zmldappasswd NewPassword )
   4)restart the servcie ( zmcontrol restart )
2)ldap server is not rechable
    -- to fix this ---
    1)change the ip adress of the ldap server at the LDAP_SERVER_IP variable in this script
         (at begining of the script)
EOF
    exit 54
fi

extracted_data=$(grep -E  "^mail|^userPassword" <<<"${raw_data}")



#checking data is empty
if [[ -z "${extracted_data}" ]];then
    echo -e "${RED}something went wrong while extracting the emails and passwords.....${DEFAULT}"
    cat<<EOF
Maybe these are the some reasons to failure
1)no emails are present in the zimbra collabration
2)Try using the zimbra Collaboration 10.1.0
EOF
    exit 43
fi


csv_writter(){
    local items=("$@")
    OLD_IFS=$IFS
    IFS=,
    echo "${items[*]}">>${FILE}
    IFS=${OLD_IFS}
}

# read the array and password and write to the csv (using csv writtter)
raapwc(){ 
    emails="$1"
    password="$2"
    for email in ${emails}; do
        csv_writter "${email}" "${password}"
    done
}


#checking the current user have the writting file permission

if [[ ! -w ./ ]];then
    echo -e "${RED}cannot create a file because current user(${USER}) doesnot have writting permision in this dictionary${DEFAULT}"
    exit 53
fi



# Removing the previos data in the file
rm ${FILE} 2>/dev/null;

#keeping the header

csv_writter "emails" "hashed passwod"

declare -a emails

IFS=$'\n'
for line in ${extracted_data}; do
    if [[ ${line} =~ ^mail ]];then
        email=$(cut -d ' ' -f2 <<< "${line}")
        emails+=(${email})
    else
        password=$(cut -d ' ' -f2 <<< "${line}")
        raapwc "${emails[*]}" "${password}"
        emails=()
    fi
done
unset IFS


echo -e "${GREEN}sucessfully writen the data to the file ${FILE}${DEFAULT}"

#exiting from the script
exit