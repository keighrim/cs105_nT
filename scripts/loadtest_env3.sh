#! /bin/bash    

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bash "$dir/loadtest_env.sh" 3000 2000 1000
