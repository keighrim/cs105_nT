
#! /bin/bash    



if [ $# -lt 3 ]; then
  echo "usage: loadtest_env.sh <#users> <#tweets> <#followers> (optional) <base-url>"
  echo "e.g.: loadtest_env.sh 100 500 30 http://localhost:4567"
  exit 1
fi

users=$1
tweets=$2
followers=$3
url=${4:-https://afternoon-peak-6349.herokuapp.com}

curl --max-time 600 "$url"/test/reset/all &> /dev/null 
curl "$url"/test/status
echo -e '\n\nAll reset!\n'

curl --max-time 600 "$url"/test/seed/"$users" &> /dev/null
curl --max-time 600 "$url"/test/tweets/"$tweets" &> /dev/null
curl --max-time 600 "$url"/test/follow/"$followers" &> /dev/null

curl "$url"/test/status
echo -e '\n\nAll set!\n'