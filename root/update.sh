#!/bin/bash

cd /wiki
STATUS=$(/usr/bin/git status origin/master)

if [[ $STATUS == *Your\ branch\ is\ ahead\ of* ]]; then
  git push -u origin master
else
  git pull
fi

exit 0