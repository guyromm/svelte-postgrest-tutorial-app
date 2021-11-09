#!/bin/bash
git diff "$1" sql/schema | egrep -v '^\+(\-\-|)$' | egrep '^\+' | egrep -v '^\+(\-\-|\+\+)' | cut -c2-
