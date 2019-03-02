#!/bin/bash

if test -n "git status --porcelain"; then

    git status --porcelain | while read -r changedFile
    do
        filePath="${changedFile:2}"

        if test ${filePath: -3} == '.rb'; then 
            "bundle exec rubocop ${filePath}"
        else
            echo "${filePath} is not ruby file. This file will be ignored."
        fi
    done
    
else
    echo "Working tree is clean. Move on to your next task!\n"
fi
