#!/usr/bin/bash
# Script to create a user account for a new employee based on collected data.

############################################################
#         VALIDATE EXISTING ALL EMPLOYEE DATA STORE        #
############################################################

all_emp_data_file="new-emp-data-store/all-emp-ds.csv"

if [ $UID -ne 0 ]; then
	echo "Error: This script must be run as root."
	exit 1
fi

if [ ! -f "$all_emp_data_file" ]; then
	echo "Error: Employee data store not found at $all_emp_data_file."
	echo "Please run the data collection script first."
	exit 1
fi


############################################################
#      # LOAD EMPLOYEE INFORMATION FROM THE DATA STORE     #
############################################################

while IFS=, read -r username full_name email department date time status; do
	# Skip entries that already have an account created
	if [[ "$status" == *"Account Created"* ]]; then
		# Skip user if they are already marked as processed
        echo "Skipping user: $username (Status: $status)"
	else
		echo "Processing account creation for user: $username"
		rand_pass=$(openssl rand -base64 12)
		useradd -m -p "$rand_pass" -s /bin/bash "$username" -c "$full_name"
    	echo "Creating user account for: $full_name"
		chage -d 0 "$username"
   	 	# Simulate user account creation (replace with actual user creation logic)
    	echo "User account created successfully."
		echo -e "\n--- New Employee Account Details ---"
		echo "Username: $username"
		echo "Temporary Password: $rand_pass"
		echo "Full Name: $full_name"
		echo "Email Address: $email"
		echo "Department: $department"
		echo "Account Created On: $date at $time"
		echo "-------------------------------------\n"
		echo "$username $rand_pass" >> "new-emp-data-store/temp/$username-credentials.txt"
		#Need To Update to only works for users that has not created account yet. Based on a field in the CSV file."NYC" and when create the account 
		#This value "NYC" should be updated to "Account Created" or similar.
		#This will prevent duplicate account creation on re-runs of this script.
		sed -i "s|NYC|Account Created|" "$all_emp_data_file"
		# Simulate sending welcome email (replace with actual email sending logic)
		echo "Sending welcome email to: $email"
		#echo -e "Subject: Welcome to the Company\n\nDear $full_name,\n\nYour user account has been created successfully.\n\nUsername: $username\nTemporary Password: $rand_pass\n\nPlease change your password upon first login.\n\nBest regards,\nIT Department" | sendmail "$email"
    	sleep 1
    	echo "Welcome email sent."
		sleep 1
	fi

    # Here you can add any additional processing or notifications needed after creating the user account.
done < "$all_emp_data_file"
