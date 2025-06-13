#!/bin/sh
getbranch=`git branch --show-current`
export "{\"TF_VAR_git_branch\":\"$getbranch\"}"