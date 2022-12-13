# katalon-clickup

### Prerequisites

- You have clickup account with necessary permissions to create tasks in a list.
ClickUp has provided api for making our custom integrations. check out this link (https://clickup.com/api/).

(Optional)
1. We will need to integrate Jenkins(open source automation server) with Katalon first. Please follow this link to integrate jenkins on docker hosted in Ubuntu. 
(https://docs.katalon.com/docs/execute/cicd-integrations/jenkins-integration/use-katalon-docker-image-for-jenkins-integration/integrate-jenkins-on-docker-hosted-in-ubuntu#id_

2. Jenkins provides us to run shell scripts in the project build section. Here we can use curl command to hit the clickup api.

- Run the file katalon-clickup.sh in terminal as 

$ bash katalon-clickup.sh -CLICKUP_API_KEY="YOUR_CLICKUP_API_KEY" -LIST_ID="YOUR_LIST_ID_IN_CLICK_UP" -REPORT_FOLDER_PATH="YOUR_CSV_FILE_PATH"

