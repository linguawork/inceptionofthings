#!/bin/bash

echo "Adding user to sudo group"

# Run the command with sudo and handle success/failure
if sudo usermod -aG sudo $USER; then
    echo -e "${GREEN}Adding user to sudo group was SUCCESSFUL${RESET}"
    # Restart the system after success
    echo "System will restart now."
    sudo reboot
else
    echo -e "${RED}Adding user to sudo group FAILED${RESET}"
fi
