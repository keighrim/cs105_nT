#! /bin/bash    

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bash "$dir/loadtest_env.sh" 100 500 30
