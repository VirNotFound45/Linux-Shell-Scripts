#!/bin/bash

# --------------------------------------------------
# Script Name : get-collaborators-list.sh
# Author      : Virendra Bind
# Description : Lists users with read access to a GitHub repository.
# Usage       : ./get-collaborators-list.sh <REPO_OWNER> <REPO_NAME>
# Dependencies: curl, jq
# Version     : 1.0
# --------------------------------------------------

# Constants
API_URL="https://api.github.com"

# GitHub username and personal access token (should be exported before running the script)
USERNAME=$username
TOKEN=$token

# Function: Check required arguments
function helper {
    expected_cmd_args=2
    if [ $# -ne $expected_cmd_args ]; then
        echo "❌ Usage: $0 <REPO_OWNER> <REPO_NAME>"
        echo "👉 Example: $0 VirNotFound45 Linux-Shell-Scripts"
        exit 1
    fi
}

# Function: Make a GET request to GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function: List users with read access
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch collaborator info
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    if [[ -z "$collaborators" ]]; then
        echo "⚠️  No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "✅ Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# 🧪 Main Script
helper "$@"
REPO_OWNER="$1"
REPO_NAME="$2"

echo "📋 Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access

