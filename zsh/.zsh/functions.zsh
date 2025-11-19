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

function kss {
  kubectl get secret "$1" -o json | jq '.data | map_values(@base64d)'}

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


###############################################################################
# KUBECTX Context Sync
###############################################################################
function gke_contexts() {
  if [[ -z "$1" ]]; then
    echo "❌ Error: GCP project ID is required."
    echo "   Usage: gke_contexts <PROJECT_ID>"
    return 1
  fi

  local GCP_PROJECT="$1"
  echo "🔍 Syncing GKE contexts for project: ${GCP_PROJECT}..."
  echo "----------------------------------------------------"

  gcloud container clusters list --format="value(name,location)" --project="$GCP_PROJECT" | while read -r CLUSTER_NAME LOCATION || [[ -n "$CLUSTER_NAME" ]]; do
    echo "--- PROCESSING CLUSTER: ${CLUSTER_NAME} ---"
    local REGION="$LOCATION"

    # Remove the region prefix from the cluster name.
    local REMAINDER=${CLUSTER_NAME#"$REGION-"}

    # Remove the random suffix from the remainder.
    local PRODUCT_ENV=${REMAINDER%-*}

    if [[ -z "$PRODUCT_ENV" ]]; then
      echo "⚠️  Skipping '${CLUSTER_NAME}': PARSING FAILED."
      continue
    fi

    # Construct the new context name
    local NEW_CONTEXT="${PRODUCT_ENV}-${REGION}"

    if kubectl config get-contexts "$NEW_CONTEXT" &> /dev/null; then
      echo "✅ Context '${NEW_CONTEXT}' already exists. Skipping."
    else
      echo "⏳ Attempting to create alias '${NEW_CONTEXT}'..."
      gcloud container clusters get-credentials "$CLUSTER_NAME" --location "$LOCATION" --project "$GCP_PROJECT" &> /dev/null
      local ORIGINAL_CONTEXT="gke_${GCP_PROJECT}_${LOCATION}_${CLUSTER_NAME}"
      if kubectl config rename-context "$ORIGINAL_CONTEXT" "$NEW_CONTEXT" &> /dev/null; then
        echo "👍 Success! Created new context '${NEW_CONTEXT}'."
      else
        echo "❌ FAILED to rename context for cluster '${CLUSTER_NAME}'."
      fi
    fi
    echo
  done

  echo "----------------------------------------------------"
  echo "✨ Sync complete."
}
