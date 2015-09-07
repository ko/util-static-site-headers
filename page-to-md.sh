#!/bin/bash

for FILE in `ls -1 post/*.page`
do
    FILE_MD=$(echo ${FILE} | sed -e 's/.page/.md/')
    mv ${FILE} ${FILE_MD}
done
