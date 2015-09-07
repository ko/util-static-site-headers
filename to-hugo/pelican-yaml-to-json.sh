#!/bin/bash

pelican_yaml_to_hugo_json() {
    FILE=$1

    TAGS_LINE=$(egrep -n ^[tT]ags: ${FILE} | cut -d':' -f1)
    CATS_LINE=$(egrep -n ^[cC]ategory: ${FILE} | cut -d':' -f1)
    TITLE_LINE=$(egrep -n ^[tT]itle: ${FILE} | cut -d':' -f1)
    AUTHOR_LINE=$(egrep -n ^[aA]uthor: ${FILE} | cut -d':' -f1)
    DATE_LINE=$(egrep -n ^[dD]ate: ${FILE} | cut -d':' -f1)

    # Normalize everything to starting with capital letters
    sed -i '' ${TITLE_LINE}'s,title,Title,g' ${FILE}
    sed -i '' ${AUTHOR_LINE}'s,author,Author,g' ${FILE}
    sed -i '' ${DATE_LINE}'s,date,Date,g' ${FILE}
    sed -i '' ${TAGS_LINE}'s,tags,Tags,g' ${FILE}
    sed -i '' ${CATS_LINE}'s,category,Category,g' ${FILE}

    # Dates are in format "YYYY-MM-DD" instead of "YYYY-MM-DD HH:MM:SS"
    sed -i '' ${DATE_LINE}'s, [0-9][0-9]:[0-9][0-9].*$,,' ${FILE}

    # Dates are in format "YYYY-MM-DD" instead of "YYYY/MM/DD"
    sed -i '' ${DATE_LINE}'s,/,-,g' ${FILE}

    # Dates are in format "YYYY-MM-DD" instead of "YYYY-MM-DD "
    sed -i '' ${DATE_LINE}'s, $,,g' ${FILE}

    clear 

    sed -i '' '1s/^/{\'$'\n/' ${FILE}
    sed -i '' '7s/^/}\'$'\n/' ${FILE}

    TAGS_LINE=$(( TAGS_LINE=TAGS_LINE+1 ))
    CATS_LINE=$(( CATS_LINE=CATS_LINE+1 ))
    TITLE_LINE=$(( TITLE_LINE=TITLE_LINE+1 ))
    AUTHOR_LINE=$(( AUTHOR_LINE=AUTHOR_LINE+1 ))
    DATE_LINE=$(( DATE_LINE=DATE_LINE+1 ))

    # Title sanitization
    # XXX: fix this dependency
    sed -i '' ${TITLE_LINE}'s/"//g' ${FILE}
    sed -i '' ${TITLE_LINE}'s/://g' ${FILE}

    # Fixup the s/://g from sanitization
    sed -i '' ${TITLE_LINE}'s/^Title/Title:/g' ${FILE}

    sed -i '' '2,6s/^/\'$'\t"/g' ${FILE}
    sed -i '' ${TITLE_LINE}'s/: /": "/g' ${FILE}
    sed -i '' ${AUTHOR_LINE}'s/: /": "/g' ${FILE}
    sed -i '' ${DATE_LINE}'s/: /": "/g' ${FILE}
    sed -i '' ${TAGS_LINE}'s/: /": ["/g' ${FILE}
    sed -i '' ${CATS_LINE}'s/: /": ["/g' ${FILE}
    sed -i '' ${TAGS_LINE}'s/, /", "/g' ${FILE}
    sed -i '' ${TAGS_LINE}'s/$/" ],/g' ${FILE}
    sed -i '' ${CATS_LINE}'s/$/" ]/g' ${FILE}
    sed -i '' ${TITLE_LINE}'s/$/",/g' ${FILE}
    sed -i '' ${AUTHOR_LINE}'s/$/",/g' ${FILE}
    sed -i '' ${DATE_LINE}'s/$/",/g' ${FILE}

    head ${FILE}
}

PELICAN_DIR=$1

for FILE in ` ls -1 ${PELICAN_DIR}/*md `
do
    pelican_yaml_to_hugo_json ${FILE}
done
