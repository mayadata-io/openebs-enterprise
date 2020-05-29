This document outlines the process of fixing issues found with enterprise release testing. 

At a high level the process involves 
- [Update enterprise release branch with latest changes](#sync-upstream-branch)
- [Create fix branch from enterprise release branch](#create-fix-branch)
- [Raise PR to enterprise release branch](#test-fix)
- [Raise PR to community release branch](#upstream-fix)
- [Pull fix from upstream to enterprise release branch](#pull-fixes-into-enterprise-branch)

## Sync upstream branch

In some of the below steps, You will be prompted to enter your github user name and password to push. 
 Click on Ctrl-C => if you are not sure on pushing the contents. 

```
git clone https://github.com/mayadata-io/hacks
cd hacks/openebs-ee/sync-branches

# Run this script that helps to merge(rebase) changes
# from community OpenEBS repository to the corresponding
# MayaData forked repository.
#
# After rebasing the master and community release branch, 
# the changes from community release branch are rebased to 
# corresponding enterprise release branch.

./sync-upstream-branch.sh <repo> <master-branch> <release-branch>
# Example: ./sync-upstream-branch.sh jiva master v1.10.x
# Example: ./sync-upstream-branch.sh cstor develop v1.10.x
```

## Create Fix branch

Create a new branch for the fix from the enterprise release branch. 

Example: 
```
git checkout v1.10.x-ee
git branch <fix-branch-name>
git checkout <fix-branch-name>
git push --set-upstream origin <fix-branch-name>
```

## Test Fix

- Make the changes and test locally. 
- Raise a WIP (Draft) PR to forked repo to the enterprise release branch. 
- Verify that the integration tests are passing

## Upstream Fix

- Raise a PR from the <fix-branch-name> to the upstream release branch. 
- Wait for reviews and integration tests to complete. 
- Raise a cherry pick PR to the upstream master branch.

## Pull Fixes into Enterprise Branch

- Follow the [steps above](#sync-upstream-branch) to pull the latest changes into enteperise please. 
- Close the WIP (Draft) PRs by linking to the commits resolving the issue.
- Delete the fix branch

