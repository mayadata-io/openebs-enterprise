# OpenEBS Enterprise Edition

The OpenEBS Enterprise Edition is a hardened version of the CNCF project OpenEBS. 

The Enterprise Edition is intended for enterprises that require a supported platform - all enterprise customers of MayaData receive the Enterprise Edition as well as the other capabilities offered by MayaData.

MayaData is adopting a simple solution similar to that adopted by other open source communities, to deliver on the requests by enterprises for an enterprise edition - while supporting the rapid development of the OpenEBS community. In short:
- The OpenEBS Enterprise Edition by MayaData will itself be open source.  
- All fixes found during the additional testing of OpenEBS will be included in the upstream of OpenEBS - assuming that the community agrees that they are useful.  

OpenEBS Enterprise Edition will NOT be a separate project;

This  document details how the Enterprise Edition version is developed, tested and released. This document is a living document - and will be revised with feedback from the broader OpenEBS Open Source community and based on ongoing input from production users of OpenEBS and Litmus and other MayaData software, including those listed on the Adopters.md listing of OpenEBS users.  

## Community vs Enterprise tagged images

The enterprise images are tagged as `X.Y.Z-ee`, the corresponding community version is `X.Y.Z`. 

### Community tagged images

The community container images are built directly from the upstream GitHub repositories. For example, cstor data engine image will be built using the code under `https://gitub.com/openebs/cstor`

The community tagged images will be pushed to the image registry under the corresponding github org. 
- docker_hub/openebs 
- quay/openebs 


The release image tags will be of the format: `X.Y.Z`

The release image tags will be generated from a GitHub branch named `vX.Y.x`. Example `1.9.0` will be generated from `v1.9.x`

### Enterprise tagged images

The enterprise version container images are built using the source code maintained only under mayadata-io GitHub repositories. For example, cstor data engine image will be built using the code under a corresponding forked repo `https://gitub.com/mayadata-io/cstor`. 

In other words, every community upstream project repository required for building OpenEBS Enterprise will have a fork created under mayadata-io Github org.

The release image tags will be of the format: `X.Y.Z-ee`

The release image tags will be generated from a GitHub branch named `vX.Y.x-ee`. Example `1.9.0-ee` will be generated from `v1.9.x-ee`.

The enterprise tagged images will be pushed to the image registry under the `mayadataio` org. 
- docker_hub/mayadataio

## OpenEBS Community: Build and Release Process

The process for building OpenEBS Community images are as follows:

- Each OpenEBS Repository will have either Travis or GitHub Action that runs component or repo level tests and pushes the tagged images to image-registry.
- Nightly (OpenEBS.ci E2e pipelines) builds are executed for the changes pushed to master. The E2e tests are maintained under https://github.com/openebs/e2e-tests. Nightly builds are executed on Packet Infrastructure, triggered via GitLab. GitLab machine is hosted by MayaData.
- A minor release is done every month. A release branch is created from the master. Release candidate images are built and pushed to image-registry using the corresponding Repository CI scripts. 
- Release pipelines are triggered manually on Release Candidate builds. The Release pipelines are executed on Native K8s, OpenShift and Konvoy clusters hosted by MayaData. 
- OpenEBS Release Checklist comprises of:
  - Successful execution of Release pipelines on Release tagged images. (RC and final release tag) 
  - Upgrade Testing (RC and final release tag)
  - Director (staging) (with RC2)
  - GitLab (openebs.ci) cluster is upgraded (with final release tag)
 
## OpenEBS Enterprise Edition: Build and Release Process
 
OpenEBS repos will be community maintained and MayaData may not have control to merge the fixes into the release branches with the same speed/SLA required by MayaData enterprise customers. This section outlines the changes to development processes, build and release process. 

### Source Code/Development 

OpenEBS Enterprise Edition is not intended to be a seperate project. It is just a fork to get quickly get the fixes and patches ready for enteprise customers. As much as possible the development continues to happen in upstream. 

A fork of the upstream OpenEBS will be made into the MayaData Github org. Example: openebs/cstor will be forked to mayadata-io/cstor.

For each openebs release branch (1.9.x), a corresponding (1.9.x-ee) branch will be created under mayadata. Example: openebs/cstor/branches/1.9.x - will be used as base to create openebs/cstor/branches/1.9.x-ee.

The plan for the fixes made due to the issues found through the OpenEBS Enterprise pipeline as follows:

- Upstream first, when applicable. 
  - Push the fix into OpenEBS Community master. 
  - Cherry pick the fix into the corresponding release branch. 
  - Rebase the Downstream (MayaData) respositories - master and release branches. 
  - Cherry pick the fixes into enteprise release branch. 
  - Generate the release from the enterprise release branch. 
  
- Fix and Upstream. 
  - An issue will be created in the openebs/openebs repo. 
  - Push the fix into enterprise release branch. 
  - Rebase the mayadata openebs master with the openebs master branch
  - Create a master-upstream-fix-issueid branch from the updated master. 
  - Cherry pick the fix from enterprise release branch to the master-upstream-fix
  - Raise the PR to the upstream (openebs) master branch. 

### Build

The process for building OpenEBS Enterprise Edition images are as follows:

- Each OpenEBS Repository will have either Travis or GitHub Action that runs component or repo level tests and pushes images to the enterprise image-registry. The images will be pushed to mayadata docker hub. Example: hub.docker.com/mayadata-io/cstor-ee. The image metadata within the docker images will indicate labels pointing to enterprise.
- The automation will be setup on the enteprise release branches. Enterprise images are created, by creating via GitHub release on the enterprise branch.

### Release Process

The process is outlined at https://e2e.mayadata.io/docs/getstarted


## Additional Test Coverage

The following table summarizes the differences between the Community vs Enteprise Test Coverage. 


| Teat Area           | Community                                                          | Enterprise Edition     
| :---                | :----                                                              | :---                   
| Functional Tests    | Added to [openebs/e2e-tests](https://github.com/openebs/e2e-tests) |  Same as Community
| Platform Support    | Limited to Ubuntu, OpenShift, Native K8s, Konvoy                   | All supported Platforms
| Performance         | None                                                               | Engine and Workload specific. 
| Soak                | Dogfooding                                                         | Workload cluster with regular choas
| Resiliency          | Limited Worloads per Engine. Added to `openebs/e2e-tests`          | All supported workloads and platforms
| Security            | Trivy checks prior to release.                                     | CIS Bench, Runtime checks, Certifications



## OpenEBS Enteprise Edition : Minor Release Cadence

The OpenEBS enterprise edition version will follow a monthly release cadence, lagging by a month from the community edition. 

- 10th of First Month: Enterprise release branches for OpenEBS Enterprise Edition are setup. 
- 15th of First Month: Release candidate builds are created from the release branch for all the components. Example image tag will be:  v1.9.0-RC1-ee
- 22nd of First Month: Final RC Build. Upgrade the Soak testbed with OpenEBS Enterprise releases.
- 5th of Second Month: Generate the GA builds. 
- 12th of Second Month: Documentation is updated. Hand-off to Marketting. 
- 15th of Second Month: Released and cakes are relished. 


## OpenEBS Enteprise Edition : Patch Release process

The point of having Enteprise editions is to help customers with patch releases. The patch releases follow a much shorter release cycle  and can be generated on demand based on the requirements and scope of the fixes. 

The following process assumes the patch fix is first made into the enteprise release branch. However, if it makes sense, the fixes will be made in upstream release branch and then synced into the enteprise release branches.

| Day | Enteprise Edition |  Community
| :--- | :--- | :---
| Day 0 | The fixes are merged into the corresponding release branches. Example: v1.9.x-ee. A new E2e pipeline setup is configured to run the customized (sub)set of tests. | Fixes are pushed to upstream master (and release branch v1.9.x if applicable). 
| Day 1 | Generate the patch version images. Example: 1.9.1-ee-RC1. Run the Patch E2e pipeline and upgrade tests. | 
| Day n | If code was fixed as a result of the patch E2e pipeline, generate and RC build and repeat tests.  Once the patch tests have passed, create patch release. Example: 1.9.1-ee | If code was fixed, push the changes to the upstream master/release branches. (PR)
| Day n+1 | Send out announcements if the patch is critical to other customers. | If the patch is critical, push it to impacted community release. Say v1.9.x and release 1.9.1

## Long Life Support

OpenEBS Enterprise Edition ships every month and customers are recommended to move to the latest version as soon as possible. 

OpenEBS Enterprise depends on the underlying Kubernetes platform. This will lead to the following situations:
1. OpenEBS Enterprise version a.b.c is required to support Platform m.n.o (Example: OpenEBS Enterprise 2.5-ee is required to support Platform 4.0). 
2. OpenEBS Enterprise version d.e.f requires a minimum Platform version p.q.r (Example: OpenEBS Enterprise 2-5-ee has to be run on Platform 4.0 or higher.)

Case 1 above is straight forward. The customer intends to move to Platform 4.0 and there is a clear upgrade path to OpenEBS Enterprise version that supports it.

Case 2, on the other hand, is more complicated. The customer wishes to upgrade OpenEBS Enterprise version, but may not be ready for upgrading the underlying platform. Also given that typically Platforms have longer release cycles, the customers can be stuck on an older OpenEBS Enterprise release.

Another scenario, call it Case 3, though OpenEBS enterprise release is rolled out monthly, we can expect some of the clusters to lag behind the latest version, depending on customer’s upgrade practices. Now, if a critical issue (related to high availability and security), has been reported and the fix can’t wait till the next scheduled release. In this case, a patch release needs to be rolled out. 

Patch release upgrades are expected to be seamless with minor fixes that don’t require a lot of planning cycles from the customer to upgrade. For example:
- Upgrading from 1.9.0 to 1.9.1 will only fix a security vulnerability found in a base image. 
- Upgrading from 1.9.0 to 1.10.1 will fix the security vulnerability as well as introduce new features/enhancements that customers may not be ready to take at a short notice. 

To help customers that are hitting Case 2 or Case 3, where the customer can’t upgrade to the latest release (and/or) and needs a patch release, OpenEBS Enterprise Long Life support includes:
- Critical fixes will be backported to the last two monthly releases. Example: Assuming there is a critical fix found in the 2.4-ee version and fixed in 2.4.1-ee. The fix will also be backported to 2.3.1-ee and 2.2.1-ee. 
- Critical fixes will be backported to the last major stable release.  Example, because of Case 2, if the customer is stuck on 1.9.1-ee, a patch will be provided as 1.9.2-ee

**Note: Patch on the last major release will be spun only on demand. A patch availability notice will be sent out to all the customers. If customers can’t use the patches provided on the current and last two monthly releases, the customer can be provided with a patch from the last major release.**
