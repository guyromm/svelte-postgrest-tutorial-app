#!/bin/bash
FROM=$1
for BR in $(git branch | cut -c3- | egrep -v '^master$') ; do
    echo "BR='$BR'"
    git push origin "$BR"
    done
