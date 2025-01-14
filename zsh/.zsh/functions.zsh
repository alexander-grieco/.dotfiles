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
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

    if [ -z "$default_branch" ]; then
        default_branch="main"
    fi
    git checkout $default_branch
    git pull origin $default_branch
    if [ $# != 0 ]
    then
        git checkout -b "$1"
    fi
}

function ksh {
    kubectl get secret "$1" --show-managed-fields -o jsonpath='{range .metadata.managedFields[*]}{.manager}{" did "}{.operation}{" at "}{.time}{"\n"}{end}'
}

function gse {
    dynamic-gitconfig.sh
}

# # I want to use this, but it doesn't work with autocomplete
# function kubectl_prompt() {
#     # Check if the command is being called for autocompletion
#     if [ -n "$COMP_LINE" ]; then
#         # Call the real kubectl command for autocompletion
#         command kubectl "$@"
#         return
#     fi
#     # Save the original arguments
#     local original_args=("$@")
#     read -r first _ <<< "$original_args"
#     echo $first
#
#     # if [[ ! $first =~ "^(get|logs|describe)$" ]]; then
#     if [[ ! $first =~ "^(get|logs)$" ]]; then
#         # Prompt the user for confirmation
#         echo -n "Are you sure you're pointed to the correct cluster? (Y/n) "
#
#         read -k 1 REPLY
#         echo    # Move to a new line
#         echo $REPLY
#         if [[ $REPLY =~ ^[Nnq]$ ]]; then
#             echo "Command aborted."
#             return 0
#         fi
#     fi
#
#     # Run the original kubectl command with all original arguments
#     command kubectl "${original_args[@]}"
# }
#
# source <(command kubectl completion zsh)
# compdef kubectl kubectl_prompt
