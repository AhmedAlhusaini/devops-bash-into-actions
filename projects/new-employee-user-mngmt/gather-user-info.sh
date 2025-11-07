#!/bin/bash
# Main loop for data collection - repeats if confirmation is 'n' or invalid input given.
new_emp_data_store="new-emp-data-store"
while true; do
    echo "Gathering user information for new employee onboarding..."

    # 1. Collect Data
    read -p "Enter full name: " full_name
    read -p "Enter username: " username
    read -p "Enter email address: " email
    read -p "Enter department: " department

    echo -e "\n--- User Information Collected ---"
    echo "Username: $username"
    echo "Full Name: $full_name"
    echo "Email Address: $email"
    echo "Department: $department"
    echo "----------------------------------\n"
	empInfo=("$username","$full_name","$email","$department","$(date +%Y-%m-%d),$(date +%H:%M:%S)","NYC")
	empInfo_sliced=("$username","$full_name","$email","$department","$(date +%Y-%m-%d),$(date +%H:%M:%S)")
    # Inner loop for confirmation - repeats only the confirmation prompt on invalid input.
    while true; do
        read -p "Are you sure about the collected data? [y/n]: " confirmation
        case $confirmation in
            # Case 1: Data Confirmed (y/Y/yes)
            [yY]|[yY][eE][sS] )
                echo "Data confirmed. Proceeding with onboarding process..."
                # Here you can add the code to process the confirmed data (e.g., save to a database)
                echo "Saving employee information..."
                # Simulate saving data (replace with actual save logic)
				echo "${empInfo[@]}" >> "$new_emp_data_store"/all-emp-ds.csv
                sleep 1
				# Simulate additional processing (replace with actual logic)
				case $department in
					"HR") echo "${empInfo_sliced[@]}" >> "$new_emp_data_store"/HR/hr-emp-ds.csv ;;
					"IT") echo "${empInfo_sliced[@]}" >> "$new_emp_data_store"/IT/it-emp-ds.csv ;;
					"FIN") echo "${empInfo_sliced[@]}" >> "$new_emp_data_store"/FIN/fin-emp-ds.csv ;;
					*) echo "${empInfo_sliced[@]}" >> "$new_emp_data_store"/OTH/gen-emp-ds.csv ;;
				esac
				sleep 1
				echo "Employee information saved successfully."
				# Here you can add any additional processing or notifications needed after saving the data.
                # Exit both loops (inner confirmation loop and outer data collection loop)
                # The 'break 2' command breaks out of the second-level loop (the main data loop)
                break 2
                ;;
            # Case 2: Data Not Confirmed (n/N/no)
            [nN]|[nN][oO] )
                echo "Data not confirmed. Restarting data collection..."
                # Break out of the inner confirmation loop and let the outer 'while true' loop repeat the data collection.
                break
                ;;
            # Case 3: Invalid Input
            * )
                echo "Invalid input: Please enter 'y' (yes) or 'n' (no)."
                # The inner loop will repeat the confirmation prompt.
                ;;
        esac
    done

done

# Rest of the onboarding process would follow here.
echo "Onboarding In Progress......."