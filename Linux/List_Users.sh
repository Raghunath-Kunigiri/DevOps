#!/bin/bash

# ==============================================================================
# GitHub Collaborator Lister
# ==============================================================================
# This script lists all collaborators with read access (pull permissions) to a
# specified GitHub repository.
#
# How to Run:
# 1. Make the script executable:
#    chmod +x list-users.sh
#
# 2. Run the script with the repository owner and name as arguments:
#    ./list-users.sh <REPO_OWNER> <REPO_NAME>
#
#    Example:
#    ./list-users.sh Raghunath-Kunigiri DevOps
# ==============================================================================

# GitHub API URL
API_URL="https://api.github.com"

# --- Get User Credentials Interactively ---
# Prompt the user for their GitHub username and Personal Access Token.
read -p "Enter your GitHub Username: " USERNAME
read -sp "Enter your GitHub Personal Access Token: " TOKEN
echo # Add a newline after the hidden token input

# Check if credentials were provided
if [ -z "$USERNAME" ] || [ -z "$TOKEN" ]; then
    echo "Error: Both username and token are required."
    exit 1
fi

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <REPO_OWNER> <REPO_NAME>"
    exit 1
fi

REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"
    # Use the credentials provided by the user
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    echo "Fetching collaborators for ${REPO_OWNER}/${REPO_NAME}..."
    local api_response
    api_response=$(github_api_get "$endpoint")

    # --- CRITICAL ERROR CHECK ---
    # Check if the API returned an error message before processing with jq
    if echo "$api_response" | jq -e 'if type=="object" and .message then true else false end' > /dev/null; then
        local error_message
        error_message=$(echo "$api_response" | jq -r '.message')
        echo "Error from GitHub API: $error_message"
        exit 1
    fi

    local collaborators
    collaborators=$(echo "$api_response" | jq -r '.[] | select(.permissions.pull == true) | .login')

    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script
list_users_with_read_access
