This document outlines the process of creating enterprise release or enterprise release candidate containers.

Prior to running this steps outlined here, follow:
- [Setup Enterprise Release branches](./setup-enterprise-branches.md)
- [Rebase Enterprise Release branches with upstream changes](./sync-with-upstream.md)

## Enterprise Release Candidate

To push enterprise RC container images, (say 1.10.0-ee-RC4), you will need to do the following:

- **Step 1** Create a github release on [mayadata/linux-utils](https://github.com/mayadata-io/linux-utils/releases). Provide the release name as v1.10.0-ee-RC4. _Note the leading v in the release name._ This step will trigger the releases on the following repositories. 
  * linux-utils
    * jiva
    * libcstor
      * cstor
        * istgt
          * external-storage
            * maya
              * velero-plugin
              * cstor-operators
                * cstor-csi
              * jiva-operator
                * jiva-csi

  In the above step, it is possible that some repos will show failed builds due to travis errors of flaky builds. Restart the build. 

- **Step 2** Some of the repositories don't follow release version or they are not yet added to the release pipeline. Trigger manual builds. This list includes:
  * node-disk-manager
  * zfs-localpv
  _Note that builds should be triggered from <release>-ee branch_

- **Step 3** Some of the repositories don't have travis setup. For these, their community images are taken and tagged as enterprise containers. Run the following script. 
  ```
  # Prior to running the script, set your Docker Login and Password as environment variables 
  # in your shell as DNAME and DPASS respectively.
  git clone https://github.com/mayadata-io/hacks
  cd hacks/openebs-ee/tag-images

  # Important! Edit tag-ee.sh with the correct community release tags for the custom images. 

  ./tag-ee.sh <community release tag> <release candidate number>

  # Example: ./tag-ee.sh 1.10.0 RC4
  # This will help tag the community images tagged with 1.10.0 as 1.10.0-ee-RC4 and 
  # push to https://hub.docker.com/mayadataio/
  ```

- **Step 4** Verify that the enterprise images are available. 

  ```
  # skip this step if you are already in tag-images directory
  git clone https://github.com/mayadata-io/hacks
  cd hacks/openebs-ee/tag-images

  # Important! Edit openebs-ent-custom-rel-tag-images.txt with the correct enterprise release tags

  ./check-release-tag.sh 1.10.0-ee-RC4
  ```

_Note: If this is the first time an image is pushed to mayadata docker registry, it will be created as a private repo. Please login and make it public._ 
  
## Enterprise Release 

The process is similar to Release Candidate builds, except that don't mention RC in the tags and scripts. For instance. 
- In **Step 1** or **Step 2**, use the tag v1.10.0-ee or custom tag without suffix of RC.
- In **Step 3**, run the tag-ee.sh script without RC as `./tag-ee.sh 1.10.0`
- In **Step 4**, run the check-release-tag.sh script without RC as `./check-release-tag.sh 1.10.0-ee`



