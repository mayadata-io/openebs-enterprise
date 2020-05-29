This repository contains few hacks to merge(rebase) OpenEBS Community (upstream) repositories with MayaData forked Enterprise repositories. Also hacks for pushing enterprise container images. 

For more details about OpenEBS Enterprise images and repositories, please check: https://github.com/mayadata-io/office-of-information/blob/master/openebs-enterprise-edition.md

Check the following guides:
- [Setup Enterprise Release branches](./setup-enterprise-branches.md)
- [Rebase Enterprise Release branches with upstream changes](./sync-with-upstream.md)
- [Pushing enteprise release or release candidate images](./making-enterprise-release.md)
- [Fixing issues found in enterprise branches](./fixing-issues.md)


Note: If this is the first time an image is pushed to mayadata docker registry, it will be created as a private repo. Please login and make it public. 

====

### Sync community release tags

Note: Some OpenEBS container images like NDM, ZFS Local PV, Mayastor are still under development and are tagged with custom versions. Prior to running the script below, they will need to be edited with appropriate release names. 

```
git clone https://github.com/mayadata-io/hacks
cd hacks/openebs-ee/sync-branches/
# Edit openebs-alpha-repos.txt with the correct community release branch for the alpha repos. 
./sync-tags.sh
# This will help fetch tags from community to mayadata forked repository.
# git push is done by the script. 
# You will be prompted to enter your github user name and password to push. 
# Click on Ctrl-C => if you are not sure on pushing the contents. 
```

