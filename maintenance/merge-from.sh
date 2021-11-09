#!/bin/bash
FROM=$1
PB="$FROM"
for BR in $(git branch | cut -c3- | egrep -v '^master$') ; do
    #echo "BR='$BR'"
    if [[ "$BR" > "$FROM" ]] ; then
	#echo "$BR > $FROM "
	echo "git checkout $BR && git merge --no-edit $PB # $FROM -> $BR"
    fi
    PB="$BR"
    done
