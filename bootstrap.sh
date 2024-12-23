#!/usr/bin/env bash

set -u
set -e

_divider="--------------------------------------------------------------------------------"
_prompt=">>>"
_indent="   "

header() {
    cat 1>&2 <<EOF
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░▒▓▓▓▓▓▓▓░░░░░░░▒▓▓░░░░▒▓▓░░░▓▓▓░░░░░▒▓▒░░░░░▓▓▒░░▒▓▓▒░░░▒▓▓▓▓▓▓▓░░░░░░░░░░
░░░░░░▒███▓▓▓███▓░░░░▓██▒░░░███░░░▓██▓░░░░███░░░░███▒░░▒██▓░░░▒███▓▓▓███▓░░░░░░░
░░░░░░▒██▓░░░░███▒░░░▓██▒░░░███░░░░███░░░▓███▓░░░██▓░░░▒██▓░░░▒██▓░░░░███▒░░░░░░
░░░░░░▒██▓░░░░▒██▓░░░▓██▒░░░███░░░░▒██▓░░██▓██░░███░░░░▒██▓░░░▒██▓░░░░▓██▒░░░░░░
░░░░░░▒██▓░░░░▒██▓░░░▓██▒░░░███░░░░░███░██▓░██▓▒██▓░░░░▒██▓░░░▒██▓░░░░▓██▒░░░░░░
░░░░░░▒██▓░░░░▒██▓░░░▓██▒░░░███░░░░░░█████░░░█████░░░░░▒██▓░░░▒██▓░░░░▓██▒░░░░░░
░░░░░░▒██▓░░░░▒██▓░░░▓██▒░░░███░░░░░░▒███▒░░░▓███░░░░░░▒██▓░░░▒██▓░░░░▓██▒░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

$_divider
Website: https://niiwin.app
$_divider

EOF
}

main() {
    header

    local prompt=yes
    local name=$1
    local dockerize=no

    if [ -x $name ]; then
      err "Usage: bootstrap <app name>"
    fi

    if [ -d "$name" ]; then
      err "Directory $name already exists."
    fi

    install_dockerized_niiwin "$name"
}

install_dockerized_niiwin() {
    need_cmd git
    need_cmd curl
    need_cmd docker
    need_env_var BUNDLE_GEM__FURY__IO

    local name="$1"
    local latest_niiwin_version="3.1.0" # TODO: Change this to the latest available template

    printf "%s Cloning the source template for niiwin $latest_niiwin_version into $name\n"
    ensure git clone git@github.com:animikii/dockerized-niiwin.git $name
    cd $name
    ensure git checkout $latest_niiwin_version

    local kebob_case_name=$(echo "$name" | tr '_' '-') # ex: my-app
    local camel_case_name=$(echo "$name" | awk -F '_' '{ for (i=1; i<=NF; i++) $i = toupper(substr($i,1,1)) substr($i,2) } 1' OFS="") # ex: MyApp

    printf "%s Renaming the project from HelloApp to $camel_case_name\n"
    find . -type f -exec \
    perl -i \
        -pe "s/hello_app/${name}/g;" \
        -pe "s/hello-app/${kebob_case_name}/g;" \
        -pe "s/HelloApp/${camel_case_name}/g;" {} +

    printf "%s Setting up Gemfury token\n"
    ensure sed "s/a1a1a1\-a1a1a1a1a1a1a1a1a1a1a1a1a1/$BUNDLE_GEM__FURY__IO/g" ".env.example" > ".env" 

    printf "%s Setting up git author information\n"
    local local_git_email=`git config --get user.email` || echo "person@animikii.com"
    local local_git_name=`git config --get user.name` || echo "Animikii Team Member"
    # The steps below are optional, because it is possible for this value to be configured
    # manually in .env
    sed "s/person\@animikii\.com/$local_git_email/g" ".env" > ".env.tmp" && mv .env.tmp .env
    sed "s/Animikii Team Member/$local_git_name/g" ".env" > ".env.tmp" && mv .env.tmp .env


    printf "%s Creating initial commit\n"
    rm -rf .git/
    git init
    git add .
    git commit -am "Initial commit"

    # Build the image and start the containers in the background so that we can run rails db:setup
    docker compose up --build --detach --remove-orphans
    # Create and seed database
    ./run rails db:setup
    # Build js and css assets
    ./run yarn install
    ./run yarn build
    # Restart the containers without -d so that we can see the logs
    docker compose down
    docker compose up
}

say() {
    printf 'boostrap.sh: %s\n' "$1"
}

err() {
    say "$1" >&2
    exit 1
}

need_env_var() {
    local var_name="$1"

    # Check if the environment variable is defined
    if [ -z "${!var_name+x}" ]; then
        err "Error: Environment variable '$var_name' is not defined."
    fi
}

need_cmd() {
    if ! check_cmd "$1"; then
        err "need '$1' (command not found)"
    fi
}

check_cmd() {
    command -v "$1" > /dev/null 2>&1
}

# Run a command that should never fail. If the command fails execution
# will immediately terminate with an error showing the failing
# command.
ensure() {
    if ! "$@"; then err "command failed: $*"; fi
}

# This is just for indicating that commands' results are being
# intentionally ignored. Usually, because it's being executed
# as part of error handling.
ignore() {
    "$@"
}

main "$@" || exit 1
