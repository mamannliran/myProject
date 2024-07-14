#! /bin/bash

# Retrieve Secrets and Extract the Private key using a python command
aws secretsmanager get-secret-value --secret-id nodejs-web-app13 --region us-east-1 | python3 -c "import sys;import json;print(json.loads(json.loads(sys.stdin.read())['SecretString'])['private'])" > ssh_tmp

# Correctly parse the new line characters and store the key in a variable
ssh_private_key=$(awk -v ORS='\\n' '1' ssh_tmp)

rm ssh_tmp

cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

curl -u "$user:$password" -X POST "$url/credentials/store/system/domain/_/createCredentials" \
  -H "$full_crumb" \
  --cookie $cookie_jar \
  --data-urlencode "json={
  '': '2',
  'credentials': {
    'scope': 'GLOBAL',
    'id': '',
    'username': 'Git',
    'password': '',
    'description': '',
    'privateKeySource': {
      'value': '0',
      'stapler-class': 'com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey\$DirectEntryPrivateKeySource',
      'privateKey': \"$ssh_private_key\"
    },
    'stapler-class': 'com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey',
  },
  'Jenkins-Crumb': '$only_crumb'
}"
