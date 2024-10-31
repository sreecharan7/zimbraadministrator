# Email Server Administration Project

This project provides an automated solution for managing email server tasks using the Zimbra Collaboration Suite. It includes three main scripts:

1. **Email Creation**
2. **Email Collection**
3. **User Creation**

---

## Project Components

### 1. Email Creation

The script `creatingUserEmails.sh` automates the process of creating email accounts on the Zimbra server. This script allows you to generate a specified number of emails following a custom pattern, each with a unique, randomly generated password.

### 2. Email Collection

The script `generatingCsvFile.sh` gathers all emails and hashed passwords from the Zimbra server and exports them into a CSV file.

### 3. User Creation

The `userCreation.sh` script reads the emails from the generated CSV file, extracts usernames from each email, and creates corresponding Linux user accounts on the server.

---

## Installation Guide

To set up and execute the project, follow these steps:

1. **Install Zimbra Collaboration Suite**:
   Ensure Zimbra is installed on a compatible OS.

2. **Clone the Project Repository**:
   Clone the project to your local machine:
   ```bash
   git clone https://github.com/sreecharan7/zimbraadministrator.git
   ```
3. **Run the Email Creation Script**:
   Use the `creatingUserEmails.sh` script to create test email accounts on the Zimbra server. This script will generate the specified number of email accounts with a custom pattern and assign each a randomly generated password.
   ```bash
   bash creatingUserEmails.sh
   ```
4. **Run the CSV Generation Script**:
   Execute the `generatingCsvFile.sh` script to collect all email addresses and their hashed passwords from the Zimbra server and save them to a CSV file. This file will be required in the next step to create Linux user accounts.
   ```bash
   bash generatingCsvFile.sh
   ```
5. **Run the User Creation Script**:
   Execute `userCreation.sh` to read the CSV file generated in the previous step. This script will create Linux user accounts for each email listed, using the username derived from the first part of each email address.
   ```bash
   bash userCreation.sh
    ```
## Error Handling

Each script includes error-handling measures. If an error occurs, the script provides specific messages to help you resolve the issue. Review the messages for troubleshooting guidance.

## Reference Images

Below are the reference images for this project:

1. **Email Creation Script Execution**: Demonstrates running the `creatingUserEmails.sh` script to generate email accounts on the Zimbra server.

2. **CSV Generation Script Execution**: Shows the process of running the `generatingCsvFile.sh` script to gather email addresses and hashed passwords, saving them in a CSV file.

3. **User Creation Script Execution**: Illustrates the `userCreation.sh` script, which reads the CSV file and creates corresponding Linux user accounts.

> **Note**: These images provide a visual guide for executing each script as described in the steps above.

![Email Creation Script Execution](./Screenshots/Screenshot%20from%202024-10-31%2015-11-58.png)
![CSV Generation Script Execution](./Screenshots/Screenshot%20from%202024-10-31%2015-12-43.png)
![Csv File](./Screenshots/Screenshot%20from%202024-10-31%2015-13-18.png)
![User Creation Script Execution](./Screenshots/Screenshot%20from%202024-10-31%2015-15-13.png)