This document outlines the process for rebasing forked repo with upstream tags

```
# You will be prompted to enter your github user name and password as this step is executed
# Click on Ctrl-C => if you are not sure on pushing the contents. 

git clone https://github.com/mayadata-io/hacks
cd openebs-enterprise/openebs-ee/sync-branches/

# Edit openebs-alpha-repos.txt with the correct community release branch for the alpha repos. 

./sync-tags.sh

# This will help fetch tags from community to mayadata forked repository.
```
