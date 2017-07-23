# ci
TAQTIQA LLC continuous integration scripts

## Travis
**IMPORTANT:**
  - The .travis.yml must pipe scripts to bash (not to sh)!  In the Travis CI environment a #!/bin/bash shebang here won't help.

### Install Container Build Tool: `acbuild`
**Assumptions:**
  - Git > 1.9.0.  To deepen the shallow clone `git fetch --unshallow`.

Travis config:
````yaml
before_install:
  - git clone https://github.com/taqtiqa/ci.git
  - cat ci/travis/install-acbuild.sh | sudo bash # pipe to bash not sh!
````

See [acbuild docs](https://github.com/containers/build/blob/master/Documentation/getting-started.md)