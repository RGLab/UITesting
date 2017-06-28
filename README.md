# UITesting

[`prod`](https://www.immunespace.org/): [![Build Status](https://travis-ci.org/RGLab/UITesting.svg?branch=master)](https://travis-ci.org/RGLab/UITesting)

[`test`](https://test.immunespace.org/): [![Build Status](https://travis-ci.org/RGLab/UITesting.svg?branch=test)](https://travis-ci.org/RGLab/UITesting)

## Requirments

- [R](https://cran.r-project.org/) (>= 3.3.2)
    - [testthat](https://cran.r-project.org/web/packages/testthat/index.html) (>= 1.0.2)
    - [RSelenium](https://cran.r-project.org/web/packages/RSelenium/index.html) (>= 1.6.2)
- [Sauce Labs](https://saucelabs.com/)


## Setup in Ubuntu

### Set environment variables

From the command line (or in `.bashrc` file):

```sh
export ISR_login=yourImmuneSpace@email.here
export ISR_pwd=yourImmuneSpacePasswordHere
export SAUCE_USERNAME=yourUsername
export SAUCE_ACCESS_KEY=yourAccessKey
```

### Run tests

To run all tests from the command line:

```sh
Rscript test.R
```

Or in R:

```R
source("test.R")
```

To run a test file in R:

```R
testthat::test_file("tests/test-front.R")
```


## Setup in Travis CI

### Configure [`.travis.yml`](.travis.yml)

- To install R and required packages
- To cache packages
- To run [`test.R`](test.R) script
- To setup [Sauce Connect](https://docs.travis-ci.com/user/sauce-connect/)
- To communicate with `Sauce Labs` after test
- To notify a Slack channel

### Set environment variables

See [Defining Variables in Repository Settings](https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings)

### Create [DESCRIPTION](DESCRIPTION) file

Even though this is not a package, DESCRIPTION file is needed to run a builder in Travis in order to declare dependencies according to [Hadley](https://github.com/travis-ci/travis-ci/issues/5913#issuecomment-210733660)


## Tests

- Front page ([`test-0-front.R`](tests/test-0-front.R))
- Home page ([`test-home.R`](tests/test-home.R))
- Overview page ([`test-overview.R`](tests/test-overview.R))
- Data Finder page ([`test-datafinder.R`](tests/test-datafinder.R))
- Participants page ([`test-participants.R`](tests/test-participants.R))
- Clinical and Assay Data page ([`test-data.R`](tests/test-data.R))
- Modules page ([`test-modules.R`](tests/test-modules.R))
    - Data Explorer ([`test-modules-de.R`](tests/test-modules-de.R))
    - Gene Expression Explorer ([`test-modules-gee.R`](tests/test-modules-gee.R))
    - Gene Set Enrichment Analysis ([`test-modules-gsea.R`](tests/test-modules-gsea.R))
    - Immune Response Predictor ([`test-modules-irp.R`](tests/test-modules-irp.R))
- Reports page ([`test-reports.R`](tests/test-reports.R))
    - SDY144 ([`test-reports-sdy144.R`](tests/test-reports-sdy144.R))
    - SDY180 ([`test-reports-sdy180.R`](tests/test-reports-sdy180.R))
    - SDY207 ([`test-reports-sdy207.R`](tests/test-reports-sdy207.R))
    - SDY269 ([`test-reports-sdy269.R`](tests/test-reports-sdy269.R))


## To Do
- [x] Save logs and screenshots: https://docs.travis-ci.com/user/uploading-artifacts/
- [ ] Set up dependent builds: https://github.com/travis-ci/travis-ci/issues/249#issuecomment-124136642
- [x] Set up cron jobs: https://docs.travis-ci.com/user/cron-jobs/
- [ ] Iterate through each study
- [x] Add slack notification
- [x] Use `Sauce Labs` instead of `phantomjs`: https://saucelabs.com/beta/signup/OSS/None