#!/bin/bash
#Parsing command line arguments
for var in "$@"
do
    if [[ $( echo "$var" | cut -d '=' -f 1 ) = "-LIST_ID" ]]
    then
    LIST_ID=$( echo "$var" | cut -d '=' -f 2 )
    fi
    if [[ $( echo "$var" | cut -d '=' -f 1 ) = "-REPORT_FOLDER_PATH" ]]
    then
    REPORT_FOLDER_PATH=($( echo "$var" | cut -d '=' -f 2 ))
    fi
    if [[ $( echo "$var" | cut -d '=' -f 1 ) = "-CLICKUP_API_KEY" ]]
    then
    CLICKUP_API_KEY=$( echo "$var" | cut -d '=' -f 2 )
    fi
done

#We can create tasks in clickup if the status of the test case is failed.Check the 'test.csv' file
MY_STATUS="FAILED"

#start time - converting today's date into unix time stamp
stimestamp=$(date +%s000)
#due date of the task - adding 2 days to start time and converting into unix time stamp
duetimestamp=$((stimestamp + 2*24*60*60*1000))

#changing directory to report folder
cd "$REPORT_FOLDER_PATH"
pwd
#to remove carriage return from end of the line in test.csv
NR=$'\r'
fail=0

#Looping to create click up tasks for each failed test case
while IFS="~" read -r Suite_Test_StepName Browser Description Tag Start_Time End_Time Duration Status
do

STAT=${Status%$NR}

if [[ ${Description} != null && ${Description} != '' && $MY_STATUS == $STAT ]]
then

#Creating a task in clickup
curl -i -X POST \
  'https://api.clickup.com/api/v2/list/'"${LIST_ID}"'/task' \
  -H 'Content-Type: application/json'\
  -H 'Authorization: '"${CLICKUP_API_KEY}"\
  -d '{
    "name": "'"${Description}"'",
    "description": "'"${Suite_Test_StepName}"'",
    "assignees": [],
    "tags": ["automation"],
    "Status": "Open",
    "priority": 3,
    "due_date": "'${duetimestamp}'",
    "due_date_time": false,
    "time_estimate": 8640000,
    "start_date": "'${stimestamp}'",
    "start_date_time": false,
    "notify_all": false,
    "parent": null,
    "links_to": null,
    "check_required_custom_fields": true,
    "custom_fields": []
  }' 
  fi
  done < <(awk -F\" 'BEGIN{OFS=FS;} {for(i=1;i<=NF;i=i+2){gsub(/,/,"~",$i);} print $0;}' < <(i=0;cat *.csv|while read -r l;do i=$((($(echo $l|tr -cd '"'|wc -c)+$i)%2));[[ $i = 1 ]] && echo -n "$l " || echo "$l";done))
