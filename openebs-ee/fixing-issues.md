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

# clone forked repo into local directory
./setup-update-repo <repo-name>
#./setup-update-repo jiva

# Pull latest changes and update forked repo
./sync-upstream-branch <repo-name> <community-release-branch>
./sync-upstream-branch <repo-name> master
#./sync-upstream-branch jiva v1.10.x
#./sync-upstream-branch jiva master

# Rebase community release branch to enterprise release branch
./rebase-forked-repo-branch <repo-name> <community-release-branch>
#./rebase-forked-repo-branch jiva v1.10.x
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

