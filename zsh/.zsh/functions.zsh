function code {
    if [[ $# = 0 ]]
    then
        open -a "Visual Studio Code"
    else
        local argPath="$1"
        [[ $1 = /* ]] && argPath="$1" || argPath="$PWD/${1#./}"
        open -a "Visual Studio Code" "$argPath"
    fi
}

function gmr {
    #branch=$(git remote show origin | grep 'HEAD branch' | cut -d':' -f2 | tr -d ' ')
    git checkout main
    git pull origin main
    if [ $# != 0 ]
    then
        git checkout -b "$1"
    fi
}
