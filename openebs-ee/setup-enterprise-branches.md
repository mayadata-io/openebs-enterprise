This document outlines the process for setting up enterprise release branches from community branches

```
# You will be prompted to enter your github user name and password as this step is executed
# Click on Ctrl-C => if you are not sure on pushing the contents. 

git clone https://github.com/mayadata-io/hacks
cd openebs-enterprise/openebs-ee/sync-branches/

# Edit openebs-alpha-repos.txt with the correct community release branch for the alpha repos. 

./setup-enterprise-branches.sh <community release branch>

# Example: ./setup-enterprise-branches.sh v1.10.x

# This script will check and do the following:
# - Check if the community branch v1.10.x is present. If not, ignore the repo
# - Check if the community branch v1.10.x is present on forked repo. If absent create it.
# - Check if the corresponding enterprise branch v1.10.x-ee is present on forked repo. If absent, create it. 
```
