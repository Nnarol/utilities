#!/bin/bash

PATTERN="$1"

# Get the starting word characters comprising the commit hashes
COMMITS=$(git log --pretty=oneline | grep -o '^\w\w*')
# Delete the first 2 characters to get the branch/ref names only,
# without indentation/aesterisk
BRANCHES=$(git branch --all | sed 's/..//')

CHECKABLE_ITEMS=\
"$COMMITS
$BRANCHES"

CANDIDATES=$(echo "$CHECKABLE_ITEMS" | grep "$PATTERN")

if [ \! "$CANDIDATES" ]; then
    echo "No candidates found for checkout."
else
    CANDIDATE_COUNT=$(echo "$CANDIDATES" | wc -l)

    if [ "$CANDIDATE_COUNT" -gt 10 ]; then
        printf "More than 10 candidates for checkout:\n$CANDIDATES" | less
    elif [ "$CANDIDATE_COUNT" -gt 1 ]; then
        printf "More than 1 candidate for checkout:\n$CANDIDATES\n"
    else
        SINGLE_CANDIDATE="$CANDIDATES"

        echo "Trying to check out '$SINGLE_CANDIDATE'"
        git checkout "$SINGLE_CANDIDATE"
    fi
fi
