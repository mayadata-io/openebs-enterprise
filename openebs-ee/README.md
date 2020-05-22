This repository contains few quick hacks to sync OpenEBS Community (upstream) container images and GitHub repositories into corresponding OpenEBS Enterprise container registry and mayadata forked GitHub repositories. 

For more details about OpenEBS Enterprise images and repositories, please check: https://github.com/mayadata-io/office-of-information/blob/master/openebs-enterprise-edition.md

## Pushing Community Images into Enterprise Docker Registry. 

### Pushing Release Candidates  (RC tags)

Note: Some OpenEBS container images like NDM, ZFS Local PV, Mayastor are still under development and are tagged with custom versions. Prior to running the script below, they will need to be edited with appropriate release names. 

```
# Set Docker Login and Password environment variables in your shell as DNAME and DPASS respectively.
git clone https://github.com/mayadata-io/hacks
cd hacks/openebs-ee/tag-images
# Edit openebs-custom-tag-images.txt with the correct community release tags for the custom images. 
./tag-ee.sh <community release tag> <release candidate number>
# Example: ./tag-ee.sh 1.10.0 RC3
# This will help tag the community images tagged with 1.10.0 as 1.10.0-ee-RC3 and 
# push to https://hub.docker.com/mayadata/
```

Note: If this is the first time an image is pushed to mayadata docker registry, it will be created as a private repo. Please login and make it public. 

### Pushing Release 

Note: Some OpenEBS container images like NDM, ZFS Local PV, Mayastor are still under development and are tagged with custom versions. Prior to running the script below, they will need to be edited with appropriate release names. 

```
# Set Docker Login and Password environment variables in your shell as DNAME and DPASS respectively.
git clone https://github.com/mayadata-io/hacks
cd hacks/openebs-ee/tag-images
# Edit openebs-custom-tag-images.txt with the correct community release tags for the custom images. 
./tag-ee.sh <community release tag>
# Example: ./tag-ee.sh 1.10.0
# This will help tag the community images tagged with 1.10.0 as 1.10.0-ee and 
# push to https://hub.docker.com/mayadata/
```

Note: If this is the first time an image is pushed to mayadata docker registry, it will be created as a private repo. Please login and make it public. 

### Check if Enterprise Release branches are created

Note: Some OpenEBS container images like NDM, ZFS Local PV, Mayastor are still under development and are tagged with custom versions. Prior to running the script below, they will need to be edited with appropriate release names. 

```
# Set Docker Login and Password environment variables in your shell as DNAME and DPASS respectively.
git clone https://github.com/mayadata-io/hacks
cd hacks/openebs-ee/sync-branches/
# Edit openebs-alpha-repos.txt with the correct community release branch for the alpha repos. 
./check-release-branch.sh <community release branch>
# Example: ./check-release-branch.sh v1.10.x
# This will help check if the community release branch and 
# enterprise release branches exist on the mayadata forked repos. 
```

### Setup and sync Enterprise Release branches

Note: Some OpenEBS container images like NDM, ZFS Local PV, Mayastor are still under development and are tagged with custom versions. Prior to running the script below, they will need to be edited with appropriate release names. 

```
# Set Docker Login and Password environment variables in your shell as DNAME and DPASS respectively.
git clone https://github.com/mayadata-io/hacks
cd hacks/openebs-ee/sync-branches/
# Edit openebs-alpha-repos.txt with the correct community release branch for the alpha repos. 
./sync-release-branch.sh <community release branch>
# Example: ./sync-release-branch.sh v1.10.x
# This will help rebase mayadata forked repository with the corresponding openebs repository. 
# git push is done by the script. 
# You will be prompted to enter your github user name and password to push. 
# Click on Ctrl-C => if you are not sure on pushing the contents. 
```

### Rebase Enterprise release branches from community release branch.

Prior to running this step, you have to execute run [sync-release-branches](#setup-and-sync-enterprise-release-branches).

```
# Set Docker Login and Password environment variables in your shell as DNAME and DPASS respectively.
git clone https://github.com/mayadata-io/hacks
cd hacks/openebs-ee/sync-branches/
# Edit openebs-alpha-repos.txt with the correct community release branch for the alpha repos. 
./rebase-ee-branch.sh <community release branch>
# Example: ./rebase-ee-branch.sh v1.10.x
# This will help rebase the changes from v1.10.x to v1.10.x-ee branch. 
# git push is done by the script. 
# You will be prompted to enter your github user name and password to push. 
# Click on Ctrl-C => if you are not sure on pushing the contents. 
```

