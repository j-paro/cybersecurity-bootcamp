# scripts
A Collection of Useful Unix Bash Scripts

## lockusr
This script removes a user from all but their primary group. It also moves their "home" directory to "/locked_users". "/locked_users" is created if it doesn't exist. This assumes you have access to create a root-level directory.

## usrchk
This will check for problematic users. While this isn't currently implemented, the skeleton exists to warn of a user with ID "0". Ideally this script will include other checks indicative of problematic users.

## usrgrps
This outputs a machine's users and the groups they belong to.

# Ideas
- Script to warn of problematic services
