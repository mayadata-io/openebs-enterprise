This document outlines the process for rebasing forked repo with upstream branches

```
# You will be prompted to enter your github user name and password as this step is executed
# Click on Ctrl-C => if you are not sure on pushing the contents. 

git clone https://github.com/mayadata-io/hacks
cd openebs-enterprise/openebs-ee/sync-branches/

# Edit openebs-alpha-repos.txt with the correct community release branch for the alpha repos. 

./rebase-ee-branch.sh <community release branch>

# Example: ./rebase-ee-branch.sh v1.10.x

# This script will check and do the following:
# - Rebase forked master with upstream master
# - Rebase forked community release branch with upstream community release branch
# - Rebase forked enterprise release branch with upstream community release branch
```
