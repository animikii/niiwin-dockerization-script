#!/usr/bin/env bash

# Set failure modes. Details: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

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

say() {
    printf 'bootstrap.sh: %s\n' "$1"
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
        err "'$1' (command not found)."
    fi
}

check_cmd() {
    command -v "$1" > /dev/null 2>&1
}

header

if (( $# != 1 )); then
    err "Usage: ./bootstrap.sh -s your_app_name"
fi

name=$1

if [ -d $name ]; then
    err "Directory $name already exists."
fi

need_cmd git
need_cmd docker
need_env_var BUNDLE_GEM__FURY__IO

latest_niiwin_version="3.2.0" # Change this to the latest available template

printf "%s Cloning the source template for niiwin $latest_niiwin_version into $name\n"
git clone git@github.com:animikii/dockerized-niiwin.git $name
cd $name
git checkout $latest_niiwin_version

kebob_case_name=$(echo "$name" | tr '_' '-') # ex: my-app
camel_case_name=$(echo "$name" | awk -F '_' '{ for (i=1; i<=NF; i++) $i = toupper(substr($i,1,1)) substr($i,2) } 1' OFS="") # ex: MyApp

printf "%s Renaming the project from HelloApp to $camel_case_name\n"
find . -type f -exec \
perl -i \
    -pe "s/hello_app/${name}/g;" \
    -pe "s/hello-app/${kebob_case_name}/g;" \
    -pe "s/HelloApp/${camel_case_name}/g;" {} +

printf "%s Setting up Gemfury token\n"
sed "s/a1a1a1\-a1a1a1a1a1a1a1a1a1a1a1a1a1/$BUNDLE_GEM__FURY__IO/g" ".env.example" > ".env" 

printf "%s Setting up git author information\n"
local_git_email=`git config --get user.email` || echo "person@animikii.com"
local_git_name=`git config --get user.name` || echo "Animikii Team Member"
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
# Restart the containers without detaching so that we can see the logs
docker compose down
docker compose up --remove-orphans
