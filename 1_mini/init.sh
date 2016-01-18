#!/bin/sh

if git init ; then
    git config merge.conflictstyle merge        # In case someone has diff3 set
    echo "README.md" > .gitignore               # Ignore files tracked in main repo
    echo "init.sh" >> .gitignore
    git add .gitignore

    echo "An untouched line" > conflictfile.txt
    git add conflictfile.txt
    git commit -m "Initial commit"

    git checkout -b feature
    echo "Addition from feature branch" >> conflictfile.txt
    git add conflictfile.txt
    git commit -m "Add text from feature branch"

    git checkout master
    echo "Some master branch text" >> conflictfile.txt
    git add conflictfile.txt
    git commit -m "add text from master branch"

    git tag start HEAD                          # For convenience when resetting

else
    echo ">> This example repository is already initialized."
    echo ">> Remove the .git directory and all other files"
    echo ">> except README.md"
fi
