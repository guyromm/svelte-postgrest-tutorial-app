#!/bin/bash
echo "|prev | cur | github diff | meld cmd"
echo "|-----"
for BR in $(git branch | cut -c3- | egrep -v '^master$') ; do
    #echo "BR='$BR'"
    #echo "|$PB | $BR | https://github.com/guyromm/svelte-postgrest-tutorial-app/compare/$PB""...""$BR?expand=1 | git difftool -t meld -y $PB..$BR"
    #echo "git difftool -t meld -y $PB..$BR"
    echo "git diff $PB..$BR"
    PB="$BR"
    done
